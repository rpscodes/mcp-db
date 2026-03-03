#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";
import pkg from 'pg';
const { Pool } = pkg;

// Database connection pool
const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'customer_support',
  user: process.env.PGUSER || process.env.USER,
  password: process.env.PGPASSWORD,
});

// Define available tools
const TOOLS: Tool[] = [
  {
    name: "get_chat_trends",
    description: "Analyze chat session trends over time, including volume by category, status distribution, and satisfaction ratings. Optionally filter by date range or component (product name).",
    inputSchema: {
      type: "object",
      properties: {
        start_date: {
          type: "string",
          description: "Start date for analysis (YYYY-MM-DD format). Optional.",
        },
        end_date: {
          type: "string",
          description: "End date for analysis (YYYY-MM-DD format). Optional.",
        },
        component: {
          type: "string",
          description: "Filter by component/product name (e.g. 'SkyVision Pro', 'FlightPack Battery 6000mAh'). Optional.",
        },
      },
    },
  },
  {
    name: "get_common_issues",
    description: "Identify the most common issues and topics from customer messages. Analyzes message content to find frequently mentioned keywords and phrases. Optionally filter by component or session category.",
    inputSchema: {
      type: "object",
      properties: {
        limit: {
          type: "number",
          description: "Maximum number of issues to return. Default is 10.",
        },
        component: {
          type: "string",
          description: "Filter by component/product name. Optional.",
        },
        category: {
          type: "string",
          description: "Filter by session category: support, troubleshooting, complaint, or feedback. Use 'feedback' to find feature requests.",
        },
      },
    },
  },
  {
    name: "get_product_insights",
    description: "Get component-level insights for the SkyVision Pro ecosystem including complaint rates, satisfaction scores, resolution times, and common issues per component.",
    inputSchema: {
      type: "object",
      properties: {
        component: {
          type: "string",
          description: "Specific component/product name to analyze. If not provided, returns insights for all components in the ecosystem.",
        },
      },
    },
  },
  {
    name: "get_sentiment_analysis",
    description: "Analyze sentiment distribution across customer messages, broken down by category, time period, and optionally by component.",
    inputSchema: {
      type: "object",
      properties: {
        category: {
          type: "string",
          description: "Filter by chat category: support, troubleshooting, complaint, or feedback. Optional.",
        },
        component: {
          type: "string",
          description: "Filter by component/product name. Optional.",
        },
      },
    },
  },
  {
    name: "get_resolution_metrics",
    description: "Get metrics about chat resolution including average resolution time, resolution rate, and performance by category. Optionally filter by component.",
    inputSchema: {
      type: "object",
      properties: {
        component: {
          type: "string",
          description: "Filter by component/product name. Optional.",
        },
      },
    },
  },
  {
    name: "search_conversations",
    description: "Search through customer conversations by keyword or phrase. Useful for finding specific issues or topics.",
    inputSchema: {
      type: "object",
      properties: {
        keyword: {
          type: "string",
          description: "Keyword or phrase to search for in messages.",
        },
        limit: {
          type: "number",
          description: "Maximum number of results to return. Default is 20.",
        },
      },
      required: ["keyword"],
    },
  },
  {
    name: "get_customer_history",
    description: "Get chat history and interaction patterns for a specific customer.",
    inputSchema: {
      type: "object",
      properties: {
        customer_id: {
          type: "number",
          description: "Customer ID to retrieve history for.",
        },
      },
      required: ["customer_id"],
    },
  },
  {
    name: "execute_custom_query",
    description: "Execute a custom SQL query on the customer support database. Use this for advanced analytics not covered by other tools. Available tables: products, customers, chat_sessions, messages, session_summaries (view).",
    inputSchema: {
      type: "object",
      properties: {
        query: {
          type: "string",
          description: "SQL SELECT query to execute. Must be a SELECT statement only.",
        },
      },
      required: ["query"],
    },
  },
  {
    name: "get_component_health",
    description: "Dashboard view of the SkyVision Pro ecosystem health. Shows per-component metrics: total issues, complaints, open issues, avg satisfaction, avg resolution time, unique customers, and repeat contacts. Answers 'which component is causing the most pain?' in a single call.",
    inputSchema: {
      type: "object",
      properties: {
        sort_by: {
          type: "string",
          description: "Sort results by: 'issues' (default), 'satisfaction', or 'resolution_time'.",
          enum: ["issues", "satisfaction", "resolution_time"],
        },
      },
    },
  },
];

// Initialize MCP server
const server = new Server(
  {
    name: "customer-support-db",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools: TOOLS };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "get_chat_trends": {
        const { start_date, end_date, component } = args as { start_date?: string; end_date?: string; component?: string };

        const conditions: string[] = [];
        const params: any[] = [];
        let paramIdx = 1;

        if (start_date) {
          conditions.push(`cs.created_at >= $${paramIdx++}`);
          params.push(start_date);
        }
        if (end_date) {
          conditions.push(`cs.created_at <= $${paramIdx++}`);
          params.push(end_date);
        }
        if (component) {
          conditions.push(`p.name ILIKE $${paramIdx++}`);
          params.push(`%${component}%`);
        }

        const whereClause = conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";
        const joinClause = component ? "JOIN products p ON cs.product_id = p.id" : "";

        // Get category distribution
        const categoryQuery = `
          SELECT cs.category, COUNT(*) as count,
                 AVG(cs.satisfaction_rating) as avg_satisfaction,
                 COUNT(*) FILTER (WHERE cs.status = 'resolved') as resolved_count
          FROM chat_sessions cs
          ${joinClause}
          ${whereClause}
          GROUP BY cs.category
          ORDER BY count DESC
        `;

        // Get daily volume trend
        const trendQuery = `
          SELECT DATE(cs.created_at) as date,
                 COUNT(*) as session_count,
                 AVG(cs.satisfaction_rating) as avg_satisfaction
          FROM chat_sessions cs
          ${joinClause}
          ${whereClause}
          GROUP BY DATE(cs.created_at)
          ORDER BY date DESC
          LIMIT 30
        `;

        // Get status distribution
        const statusQuery = `
          SELECT cs.status, COUNT(*) as count
          FROM chat_sessions cs
          ${joinClause}
          ${whereClause}
          GROUP BY cs.status
        `;

        const [categoryResult, trendResult, statusResult] = await Promise.all([
          pool.query(categoryQuery, params),
          pool.query(trendQuery, params),
          pool.query(statusQuery, params),
        ]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                category_distribution: categoryResult.rows,
                daily_trends: trendResult.rows,
                status_distribution: statusResult.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_common_issues": {
        const { limit = 10, component, category } = args as { limit?: number; component?: string; category?: string };

        const conditions: string[] = ["m.sender = 'customer'", "m.sentiment IN ('negative', 'neutral')"];
        const params: any[] = [];
        let paramIdx = 1;

        if (component) {
          conditions.push(`p.name ILIKE $${paramIdx++}`);
          params.push(`%${component}%`);
        }
        if (category) {
          conditions.push(`cs.category = $${paramIdx++}`);
          params.push(category);
        }

        const whereClause = "WHERE " + conditions.join(" AND ");
        const joinClause = `JOIN chat_sessions cs ON m.session_id = cs.id JOIN products p ON cs.product_id = p.id`;

        const query = `
          SELECT
            LOWER(REGEXP_REPLACE(REGEXP_REPLACE(m.content, '[-/]', ' ', 'g'), '[^a-zA-Z0-9 ]', '', 'g')) as cleaned_content
          FROM messages m
          ${joinClause}
          ${whereClause}
          LIMIT 500
        `;

        const result = await pool.query(query, params);

        // Simple keyword extraction (count word frequency)
        const wordCount: Record<string, number> = {};
        const bigramCount: Record<string, number> = {};
        const stopWords = new Set([
          'the', 'is', 'at', 'which', 'on', 'a', 'an', 'and', 'or', 'but', 'in', 'with', 'to', 'for', 'of', 'as', 'by',
          'my', 'i', 'it', 'that', 'this', 'from', 'are', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
          'should', 'can', 'could', 'be', 'been', 'being', 'just', 'you', 'your', 'me', 'im', 'ive', 'not', 'no', 'yes',
          'hi', 'hello', 'thanks', 'thank', 'please',
          // Product/brand terms
          'skyvision', 'pro', 'drone', 'battery', 'controller', 'gimbal', 'charger', 'flightpack', 'dronelink',
          'visioncam', 'quickcharge', 'hub', 'product',
          // Common filler words
          'really', 'very', 'about', 'need', 'want', 'got', 'were', 'when', 'what', 'how', 'also', 'some', 'more',
          'like', 'going', 'know', 'make', 'much', 'still', 'only', 'even', 'dont', 'cant', 'wont', 'thats', 'well',
          'back', 'after', 'them', 'they', 'their', 'there', 'then', 'than', 'here', 'other', 'over', 'into', 'same',
          'down', 'been',
        ]);

        result.rows.forEach((row) => {
          const allWords: string[] = row.cleaned_content.split(/\s+/);
          const filteredWords = allWords.filter((w: string) => w.length > 3 && !stopWords.has(w));
          filteredWords.forEach((word: string) => {
            wordCount[word] = (wordCount[word] || 0) + 1;
          });

          // Bigram extraction
          for (let i = 0; i < allWords.length - 1; i++) {
            const w1 = allWords[i];
            const w2 = allWords[i + 1];
            if (w1.length >= 3 && w2.length >= 3 && !stopWords.has(w1) && !stopWords.has(w2)) {
              const bigram = `${w1} ${w2}`;
              bigramCount[bigram] = (bigramCount[bigram] || 0) + 1;
            }
          }
        });

        const topIssues = Object.entries(wordCount)
          .sort(([, a], [, b]) => b - a)
          .slice(0, limit)
          .map(([word, count]) => ({ keyword: word, frequency: count }));

        const topPhrases = Object.entries(bigramCount)
          .sort(([, a], [, b]) => b - a)
          .slice(0, limit)
          .map(([phrase, count]) => ({ phrase, frequency: count }));

        // Also get actual issue categories
        const catConditions: string[] = [];
        const catParams: any[] = [];
        let catIdx = 1;
        let catJoin = "";

        if (component) {
          catJoin = "JOIN products p ON cs.product_id = p.id";
          catConditions.push(`p.name ILIKE $${catIdx++}`);
          catParams.push(`%${component}%`);
        }
        if (category) {
          catConditions.push(`cs.category = $${catIdx++}`);
          catParams.push(category);
        }

        const catWhere = catConditions.length > 0 ? "WHERE " + catConditions.join(" AND ") : "";

        const categoryQuery = `
          SELECT cs.category, COUNT(*) as count,
                 ROUND(AVG(cs.satisfaction_rating), 2) as avg_satisfaction
          FROM chat_sessions cs
          ${catJoin}
          ${catWhere}
          GROUP BY cs.category
          ORDER BY count DESC
        `;

        const categoryResult = await pool.query(categoryQuery, catParams);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                top_keywords: topIssues,
                top_phrases: topPhrases,
                issue_categories: categoryResult.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_product_insights": {
        const { component } = args as { component?: string };

        const conditions: string[] = [];
        const params: any[] = [];
        let paramIdx = 1;

        if (component) {
          conditions.push(`p.name ILIKE $${paramIdx++}`);
          params.push(`%${component}%`);
        }

        const whereClause = conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

        const query = `
          SELECT
            p.id,
            p.name,
            p.category,
            COUNT(cs.id) as total_sessions,
            COUNT(cs.id) FILTER (WHERE cs.category = 'complaint') as complaints,
            COUNT(cs.id) FILTER (WHERE cs.category = 'troubleshooting') as troubleshooting_sessions,
            COUNT(cs.id) FILTER (WHERE cs.category = 'feedback') as feedback_sessions,
            COUNT(cs.id) FILTER (WHERE cs.category = 'support') as support_sessions,
            ROUND(AVG(cs.satisfaction_rating), 2) as avg_satisfaction,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60), 2) as avg_resolution_minutes,
            COUNT(cs.id) FILTER (WHERE cs.status = 'resolved') as resolved_count,
            COUNT(cs.id) FILTER (WHERE cs.status = 'open') as open_count,
            COUNT(DISTINCT cs.customer_id) as unique_customers
          FROM products p
          LEFT JOIN chat_sessions cs ON p.id = cs.product_id
          ${whereClause}
          GROUP BY p.id, p.name, p.category
          ORDER BY total_sessions DESC
        `;

        const result = await pool.query(query, params);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(result.rows, null, 2),
            },
          ],
        };
      }

      case "get_sentiment_analysis": {
        const { category, component } = args as { category?: string; component?: string };

        const conditions: string[] = [];
        const params: any[] = [];
        let paramIdx = 1;

        if (category) {
          conditions.push(`cs.category = $${paramIdx++}`);
          params.push(category);
        }
        if (component) {
          conditions.push(`p.name ILIKE $${paramIdx++}`);
          params.push(`%${component}%`);
        }

        const whereClause = conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";
        const joinClause = "JOIN chat_sessions cs ON m.session_id = cs.id JOIN products p ON cs.product_id = p.id";

        const query = `
          SELECT
            m.sentiment,
            COUNT(*) as count,
            ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) as percentage
          FROM messages m
          ${joinClause}
          ${whereClause}
          GROUP BY m.sentiment
          ORDER BY count DESC
        `;

        // By-component breakdown
        const componentQuery = `
          SELECT
            p.name as component,
            m.sentiment,
            COUNT(*) as count
          FROM messages m
          JOIN chat_sessions cs ON m.session_id = cs.id
          JOIN products p ON cs.product_id = p.id
          ${conditions.length > 0 ? whereClause : ""}
          GROUP BY p.name, m.sentiment
          ORDER BY p.name, count DESC
        `;

        const overallQuery = `
          SELECT
            cs.category,
            m.sentiment,
            COUNT(*) as count
          FROM messages m
          JOIN chat_sessions cs ON m.session_id = cs.id
          JOIN products p ON cs.product_id = p.id
          GROUP BY cs.category, m.sentiment
          ORDER BY cs.category, count DESC
        `;

        const [sentimentResult, componentBreakdown, categoryBreakdown] = await Promise.all([
          pool.query(query, params),
          pool.query(componentQuery, params),
          pool.query(overallQuery),
        ]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                overall_sentiment: sentimentResult.rows,
                by_component: componentBreakdown.rows,
                by_category: categoryBreakdown.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_resolution_metrics": {
        const { component } = args as { component?: string };

        const conditions: string[] = [];
        const params: any[] = [];
        let paramIdx = 1;
        let joinClause = "";

        if (component) {
          joinClause = "JOIN products p ON cs.product_id = p.id";
          conditions.push(`p.name ILIKE $${paramIdx++}`);
          params.push(`%${component}%`);
        }

        const whereClause = conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

        const query = `
          SELECT
            cs.category,
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE cs.status = 'resolved') as resolved_sessions,
            ROUND(COUNT(*) FILTER (WHERE cs.status = 'resolved')::numeric / COUNT(*) * 100, 2) as resolution_rate,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60) FILTER (WHERE cs.resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            ROUND(AVG(cs.satisfaction_rating) FILTER (WHERE cs.satisfaction_rating IS NOT NULL), 2) as avg_satisfaction
          FROM chat_sessions cs
          ${joinClause}
          ${whereClause}
          GROUP BY cs.category
          ORDER BY total_sessions DESC
        `;

        const overallQuery = `
          SELECT
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE cs.status = 'resolved') as resolved_sessions,
            COUNT(*) FILTER (WHERE cs.status = 'open') as open_sessions,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60) FILTER (WHERE cs.resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            ROUND(AVG(cs.satisfaction_rating) FILTER (WHERE cs.satisfaction_rating IS NOT NULL), 2) as avg_satisfaction
          FROM chat_sessions cs
          ${joinClause}
          ${whereClause}
        `;

        // Per-component breakdown
        const componentQuery = `
          SELECT
            p.name as component,
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE cs.status = 'resolved') as resolved_sessions,
            ROUND(COUNT(*) FILTER (WHERE cs.status = 'resolved')::numeric / COUNT(*) * 100, 2) as resolution_rate,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60) FILTER (WHERE cs.resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            ROUND(AVG(cs.satisfaction_rating) FILTER (WHERE cs.satisfaction_rating IS NOT NULL), 2) as avg_satisfaction
          FROM chat_sessions cs
          JOIN products p ON cs.product_id = p.id
          GROUP BY p.name
          ORDER BY total_sessions DESC
        `;

        const [categoryMetrics, overallMetrics, componentMetrics] = await Promise.all([
          pool.query(query, params),
          pool.query(overallQuery, params),
          pool.query(componentQuery),
        ]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                overall: overallMetrics.rows[0],
                by_category: categoryMetrics.rows,
                by_component: componentMetrics.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "search_conversations": {
        const { keyword, limit = 20 } = args as { keyword: string; limit?: number };

        const query = `
          SELECT
            m.id,
            m.session_id,
            c.name as customer_name,
            p.name as product_name,
            cs.category,
            m.sender,
            m.content,
            m.sentiment,
            m.created_at
          FROM messages m
          JOIN chat_sessions cs ON m.session_id = cs.id
          JOIN customers c ON cs.customer_id = c.id
          JOIN products p ON cs.product_id = p.id
          WHERE LOWER(m.content) LIKE LOWER($1)
          ORDER BY m.created_at DESC
          LIMIT $2
        `;

        const result = await pool.query(query, [`%${keyword}%`, limit]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                matches_found: result.rows.length,
                conversations: result.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_customer_history": {
        const { customer_id } = args as { customer_id: number };

        const customerQuery = `
          SELECT * FROM customers WHERE id = $1
        `;

        const sessionsQuery = `
          SELECT
            cs.*,
            p.name as product_name,
            p.category as product_category
          FROM chat_sessions cs
          JOIN products p ON cs.product_id = p.id
          WHERE cs.customer_id = $1
          ORDER BY cs.created_at DESC
        `;

        const [customerResult, sessionsResult] = await Promise.all([
          pool.query(customerQuery, [customer_id]),
          pool.query(sessionsQuery, [customer_id]),
        ]);

        if (customerResult.rows.length === 0) {
          return {
            content: [
              {
                type: "text",
                text: JSON.stringify({ error: "Customer not found" }),
              },
            ],
          };
        }

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                customer: customerResult.rows[0],
                total_sessions: sessionsResult.rows.length,
                sessions: sessionsResult.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "execute_custom_query": {
        const { query } = args as { query: string };

        // Security check - only allow SELECT statements
        const trimmedQuery = query.trim().toUpperCase();
        if (!trimmedQuery.startsWith("SELECT")) {
          return {
            content: [
              {
                type: "text",
                text: JSON.stringify({ error: "Only SELECT queries are allowed" }),
              },
            ],
          };
        }

        const result = await pool.query(query);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                rows_returned: result.rows.length,
                data: result.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_component_health": {
        const { sort_by = "issues" } = args as { sort_by?: string };

        let orderBy: string;
        switch (sort_by) {
          case "satisfaction":
            orderBy = "avg_satisfaction ASC NULLS FIRST";
            break;
          case "resolution_time":
            orderBy = "avg_resolution_minutes DESC NULLS FIRST";
            break;
          default:
            orderBy = "total_issues DESC";
        }

        const query = `
          SELECT
            p.name as component,
            p.category,
            COUNT(cs.id) as total_issues,
            COUNT(cs.id) FILTER (WHERE cs.category = 'complaint') as complaints,
            COUNT(cs.id) FILTER (WHERE cs.status = 'open') as open_issues,
            ROUND(AVG(cs.satisfaction_rating) FILTER (WHERE cs.satisfaction_rating IS NOT NULL), 2) as avg_satisfaction,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60) FILTER (WHERE cs.resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            COUNT(DISTINCT cs.customer_id) as unique_customers,
            COUNT(cs.customer_id) - COUNT(DISTINCT cs.customer_id) as repeat_contacts
          FROM products p
          LEFT JOIN chat_sessions cs ON p.id = cs.product_id
          GROUP BY p.id, p.name, p.category
          ORDER BY ${orderBy}
        `;

        const result = await pool.query(query);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                ecosystem: "SkyVision Pro",
                component_health: result.rows,
                sorted_by: sort_by,
              }, null, 2),
            },
          ],
        };
      }

      default:
        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({ error: `Unknown tool: ${name}` }),
            },
          ],
        };
    }
  } catch (error: any) {
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify({ error: error.message }),
        },
      ],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Customer Support MCP Server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
