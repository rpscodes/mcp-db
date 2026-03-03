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
    description: "Analyze chat session trends over time, including volume by category, status distribution, and satisfaction ratings. Optionally filter by date range.",
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
      },
    },
  },
  {
    name: "get_common_issues",
    description: "Identify the most common issues and topics from customer messages. Analyzes message content to find frequently mentioned keywords and phrases.",
    inputSchema: {
      type: "object",
      properties: {
        limit: {
          type: "number",
          description: "Maximum number of issues to return. Default is 10.",
        },
      },
    },
  },
  {
    name: "get_product_insights",
    description: "Get insights about products including complaint rates, satisfaction scores, and common issues for each product.",
    inputSchema: {
      type: "object",
      properties: {
        product_id: {
          type: "number",
          description: "Specific product ID to analyze. If not provided, returns insights for all products.",
        },
      },
    },
  },
  {
    name: "get_sentiment_analysis",
    description: "Analyze sentiment distribution across all customer messages, broken down by category and time period.",
    inputSchema: {
      type: "object",
      properties: {
        category: {
          type: "string",
          description: "Filter by chat category: support, troubleshooting, complaint, or feedback. Optional.",
        },
      },
    },
  },
  {
    name: "get_resolution_metrics",
    description: "Get metrics about chat resolution including average resolution time, resolution rate, and performance by category.",
    inputSchema: {
      type: "object",
      properties: {},
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
        const { start_date, end_date } = args as { start_date?: string; end_date?: string };

        let whereClause = "";
        const params: any[] = [];

        if (start_date && end_date) {
          whereClause = "WHERE created_at BETWEEN $1 AND $2";
          params.push(start_date, end_date);
        } else if (start_date) {
          whereClause = "WHERE created_at >= $1";
          params.push(start_date);
        } else if (end_date) {
          whereClause = "WHERE created_at <= $1";
          params.push(end_date);
        }

        // Get category distribution
        const categoryQuery = `
          SELECT category, COUNT(*) as count,
                 AVG(satisfaction_rating) as avg_satisfaction,
                 COUNT(*) FILTER (WHERE status = 'resolved') as resolved_count
          FROM chat_sessions
          ${whereClause}
          GROUP BY category
          ORDER BY count DESC
        `;

        // Get daily volume trend
        const trendQuery = `
          SELECT DATE(created_at) as date,
                 COUNT(*) as session_count,
                 AVG(satisfaction_rating) as avg_satisfaction
          FROM chat_sessions
          ${whereClause}
          GROUP BY DATE(created_at)
          ORDER BY date DESC
          LIMIT 30
        `;

        // Get status distribution
        const statusQuery = `
          SELECT status, COUNT(*) as count
          FROM chat_sessions
          ${whereClause}
          GROUP BY status
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
        const { limit = 10 } = args as { limit?: number };

        // Extract keywords from customer messages
        const query = `
          SELECT
            LOWER(REGEXP_REPLACE(content, '[^a-zA-Z0-9 ]', '', 'g')) as cleaned_content
          FROM messages
          WHERE sender = 'customer' AND sentiment IN ('negative', 'neutral')
          LIMIT 500
        `;

        const result = await pool.query(query);

        // Simple keyword extraction (count word frequency)
        const wordCount: Record<string, number> = {};
        const stopWords = new Set(['the', 'is', 'at', 'which', 'on', 'a', 'an', 'and', 'or', 'but', 'in', 'with', 'to', 'for', 'of', 'as', 'by', 'my', 'i', 'it', 'that', 'this', 'from', 'are', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'should', 'can', 'could', 'be', 'been', 'being', 'just', 'you', 'your', 'me', 'im', 'ive', 'not', 'no', 'yes', 'hi', 'hello', 'thanks', 'thank', 'please']);

        result.rows.forEach((row) => {
          const words = row.cleaned_content.split(/\s+/).filter((w: string) => w.length > 3 && !stopWords.has(w));
          words.forEach((word: string) => {
            wordCount[word] = (wordCount[word] || 0) + 1;
          });
        });

        const topIssues = Object.entries(wordCount)
          .sort(([, a], [, b]) => b - a)
          .slice(0, limit)
          .map(([word, count]) => ({ keyword: word, frequency: count }));

        // Also get actual issue categories
        const categoryQuery = `
          SELECT category, COUNT(*) as count,
                 ROUND(AVG(satisfaction_rating), 2) as avg_satisfaction
          FROM chat_sessions
          GROUP BY category
          ORDER BY count DESC
        `;

        const categoryResult = await pool.query(categoryQuery);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                top_keywords: topIssues,
                issue_categories: categoryResult.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_product_insights": {
        const { product_id } = args as { product_id?: number };

        let whereClause = "";
        const params: any[] = [];

        if (product_id) {
          whereClause = "WHERE p.id = $1";
          params.push(product_id);
        }

        const query = `
          SELECT
            p.id,
            p.name,
            p.category,
            COUNT(cs.id) as total_sessions,
            COUNT(cs.id) FILTER (WHERE cs.category = 'complaint') as complaints,
            COUNT(cs.id) FILTER (WHERE cs.category = 'troubleshooting') as troubleshooting_sessions,
            COUNT(cs.id) FILTER (WHERE cs.category = 'feedback') as feedback_sessions,
            ROUND(AVG(cs.satisfaction_rating), 2) as avg_satisfaction,
            ROUND(AVG(EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60), 2) as avg_resolution_minutes,
            COUNT(cs.id) FILTER (WHERE cs.status = 'resolved') as resolved_count,
            COUNT(cs.id) FILTER (WHERE cs.status = 'open') as open_count
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
        const { category } = args as { category?: string };

        let whereClause = "";
        const params: any[] = [];

        if (category) {
          whereClause = "WHERE cs.category = $1";
          params.push(category);
        }

        const query = `
          SELECT
            m.sentiment,
            COUNT(*) as count,
            ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) as percentage
          FROM messages m
          JOIN chat_sessions cs ON m.session_id = cs.id
          ${whereClause}
          GROUP BY m.sentiment
          ORDER BY count DESC
        `;

        const overallQuery = `
          SELECT
            cs.category,
            m.sentiment,
            COUNT(*) as count
          FROM messages m
          JOIN chat_sessions cs ON m.session_id = cs.id
          GROUP BY cs.category, m.sentiment
          ORDER BY cs.category, count DESC
        `;

        const [sentimentResult, categoryBreakdown] = await Promise.all([
          pool.query(query, params),
          pool.query(overallQuery),
        ]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                overall_sentiment: sentimentResult.rows,
                by_category: categoryBreakdown.rows,
              }, null, 2),
            },
          ],
        };
      }

      case "get_resolution_metrics": {
        const query = `
          SELECT
            category,
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE status = 'resolved') as resolved_sessions,
            ROUND(COUNT(*) FILTER (WHERE status = 'resolved')::numeric / COUNT(*) * 100, 2) as resolution_rate,
            ROUND(AVG(EXTRACT(EPOCH FROM (resolved_at - created_at))/60) FILTER (WHERE resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            ROUND(AVG(satisfaction_rating) FILTER (WHERE satisfaction_rating IS NOT NULL), 2) as avg_satisfaction
          FROM chat_sessions
          GROUP BY category
          ORDER BY total_sessions DESC
        `;

        const overallQuery = `
          SELECT
            COUNT(*) as total_sessions,
            COUNT(*) FILTER (WHERE status = 'resolved') as resolved_sessions,
            COUNT(*) FILTER (WHERE status = 'open') as open_sessions,
            ROUND(AVG(EXTRACT(EPOCH FROM (resolved_at - created_at))/60) FILTER (WHERE resolved_at IS NOT NULL), 2) as avg_resolution_minutes,
            ROUND(AVG(satisfaction_rating) FILTER (WHERE satisfaction_rating IS NOT NULL), 2) as avg_satisfaction
          FROM chat_sessions
        `;

        const [categoryMetrics, overallMetrics] = await Promise.all([
          pool.query(query),
          pool.query(overallQuery),
        ]);

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                overall: overallMetrics.rows[0],
                by_category: categoryMetrics.rows,
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
