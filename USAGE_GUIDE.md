# Customer Support Insights Agent - Usage Guide

## Overview

This project consists of:
1. **PostgreSQL Database** - Contains customer support chat data
2. **MCP Server** - Provides tools to analyze the data
3. **Claude as Agent** - Uses the MCP server to provide insights

## Quick Start

### 1. Verify PostgreSQL is Running

```bash
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
psql -d customer_support -c "SELECT COUNT(*) FROM chat_sessions;"
```

Expected output: Should show 20 chat sessions

### 2. Test the MCP Server

```bash
cd mcp-server
npm run dev
```

The server should start and display: "Customer Support MCP Server running on stdio"

Press `Ctrl+C` to stop.

### 3. Using with Claude Code

The MCP server is already configured in `~/.config/claude/mcp_config.json`.

Start a new Claude Code session and the MCP server will automatically connect.

## Example Queries to Try

Once connected, you can ask Claude natural language questions:

### Trend Analysis
- "What are the current trends in customer support chats?"
- "Show me the chat volume trends over the last 30 days"
- "What's the distribution of chat categories?"

### Common Issues
- "What are the most common issues customers are facing?"
- "Show me the top keywords from customer complaints"
- "What topics come up most frequently in troubleshooting sessions?"

### Product Insights
- "Which products have the most complaints?"
- "What's the satisfaction rating for each product?"
- "Show me detailed insights for the SmartPhone Pro X"
- "Which products take the longest to resolve issues?"

### Sentiment Analysis
- "Analyze the sentiment of customer messages"
- "What's the sentiment breakdown for complaint chats?"
- "Show me positive vs negative sentiment trends"

### Resolution Metrics
- "What's the average resolution time?"
- "Show me resolution metrics by category"
- "What's our resolution rate for troubleshooting issues?"

### Search and Investigation
- "Search for conversations mentioning 'battery'"
- "Find all messages about connectivity issues"
- "Show me conversations where customers mentioned 'freezing'"

### Customer History
- "Show me the chat history for customer ID 1"
- "What products has customer John Smith contacted us about?"

### Custom Analysis
- "Execute a query to show me the top 5 products by session count"
- "Find customers who have had more than 2 support sessions"
- "Show me all open sessions"

## Database Schema Reference

### Tables

**products**
- id, name, category, created_at

**customers**
- id, name, email, created_at

**chat_sessions**
- id, customer_id, product_id, status, category, priority, satisfaction_rating, created_at, resolved_at

**messages**
- id, session_id, sender, content, sentiment, created_at

**session_summaries (view)**
- Aggregated data about sessions including message counts and resolution times

### Sample Data Overview

- **20 chat sessions** spanning January-February 2024
- **15 unique customers**
- **10 products** across categories: Electronics, Audio, Wearables, Smart Home, Accessories, Gaming
- **4 chat categories**: support, troubleshooting, complaint, feedback
- **3 priority levels**: low, medium, high
- **Realistic conversations** covering scenarios like:
  - Battery drain issues
  - Connectivity problems
  - Product setup assistance
  - Positive feedback
  - Warranty claims
  - Feature questions

## Advanced Usage

### Direct SQL Queries

You can ask Claude to execute custom SQL queries:

```
"Execute this query:
SELECT p.name, COUNT(*) as issue_count
FROM chat_sessions cs
JOIN products p ON cs.product_id = p.id
WHERE cs.category = 'complaint'
GROUP BY p.name
ORDER BY issue_count DESC"
```

### Combining Multiple Tools

Ask Claude to use multiple tools for comprehensive analysis:

```
"Give me a complete overview of our customer support performance including:
- Resolution metrics
- Common issues
- Product insights
- Sentiment analysis"
```

### Filtering by Date

```
"Show me chat trends from January 15 to January 31, 2024"
```

## Troubleshooting

### MCP Server Not Connecting

1. Check if PostgreSQL is running:
   ```bash
   brew services list | grep postgresql
   ```

2. Verify database exists:
   ```bash
   psql -l | grep customer_support
   ```

3. Test database connection:
   ```bash
   psql -d customer_support -c "SELECT 1;"
   ```

### Database Connection Errors

If you see connection errors, ensure PostgreSQL is in your PATH:

```bash
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
```

Add this to your `~/.bash_profile` or `~/.zshrc` to make it permanent.

### Rebuilding the MCP Server

If you make changes to the server code:

```bash
cd mcp-server
npm run build
```

Then restart your Claude session.

## Understanding the Results

### Satisfaction Ratings
- Scale: 1-5 (1 = very dissatisfied, 5 = very satisfied)
- NULL values indicate sessions still in progress

### Resolution Time
- Measured in minutes from session start to resolution
- Only calculated for resolved sessions

### Sentiment
- positive: Friendly, satisfied tone
- neutral: Factual, informational
- negative: Frustrated, angry, dissatisfied

### Categories
- **support**: General help and questions
- **troubleshooting**: Technical issues needing diagnosis
- **complaint**: Dissatisfaction with product/service
- **feedback**: Suggestions and positive comments

## Next Steps

### Extending the Database

To add more data, you can:

1. Create SQL insert statements
2. Connect a real data source
3. Build an API to receive new chat data

### Customizing the MCP Server

Edit `mcp-server/src/index.ts` to:
- Add new tools
- Modify existing queries
- Add more sophisticated analytics
- Integrate with external APIs

### Building Reports

Ask Claude to:
- Generate weekly summary reports
- Create visualizations (CSV export for charts)
- Identify trends over time
- Flag priority issues

## MCP Server Tools Reference

| Tool | Purpose | Parameters |
|------|---------|------------|
| get_chat_trends | Analyze trends over time | start_date, end_date |
| get_common_issues | Find frequent keywords | limit |
| get_product_insights | Product performance metrics | product_id (optional) |
| get_sentiment_analysis | Sentiment distribution | category (optional) |
| get_resolution_metrics | Resolution performance | none |
| search_conversations | Keyword search | keyword, limit |
| get_customer_history | Customer interaction history | customer_id |
| execute_custom_query | Run custom SQL | query |

## Tips for Best Results

1. **Be specific**: Instead of "show me data", ask "what are the top 3 products with complaints?"
2. **Ask for context**: "Why is the satisfaction rating low for WirelessBuds Max?"
3. **Request comparisons**: "Compare resolution times between complaints and support requests"
4. **Seek insights**: "What patterns do you see in troubleshooting sessions?"
5. **Ask follow-ups**: Claude maintains context, so you can drill down into specific findings
