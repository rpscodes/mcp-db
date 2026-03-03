# Customer Support MCP Server

An MCP (Model Context Protocol) server that provides tools to analyze customer support chat data from a PostgreSQL database.

## Features

This MCP server provides 8 powerful tools for analyzing customer support interactions:

1. **get_chat_trends** - Analyze chat session trends over time
2. **get_common_issues** - Identify frequently mentioned keywords and topics
3. **get_product_insights** - Get detailed insights about product performance
4. **get_sentiment_analysis** - Analyze customer sentiment distribution
5. **get_resolution_metrics** - Track resolution times and success rates
6. **search_conversations** - Search through conversations by keyword
7. **get_customer_history** - Retrieve full customer interaction history
8. **execute_custom_query** - Run custom SQL queries for advanced analytics

## Prerequisites

- Node.js 18+
- PostgreSQL 16 with customer_support database running
- TypeScript (installed as dev dependency)

## Installation

```bash
npm install
npm run build
```

## Configuration

### For Claude Desktop

Add this to your Claude Desktop configuration file:

**MacOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "customer-support": {
      "command": "node",
      "args": [
        "/Users/vravula/ai-code/mcp-db/mcp-server/dist/index.js"
      ]
    }
  }
}
```

### For Claude Code CLI

Add to your MCP settings file (`~/.config/claude/mcp_config.json`):

```json
{
  "mcpServers": {
    "customer-support": {
      "command": "node",
      "args": [
        "/Users/vravula/ai-code/mcp-db/mcp-server/dist/index.js"
      ]
    }
  }
}
```

## Usage Examples

Once configured, you can ask Claude questions like:

- "What are the most common customer issues?"
- "Show me sentiment analysis for troubleshooting requests"
- "What products have the highest complaint rates?"
- "What's the average resolution time by category?"
- "Search for conversations mentioning 'battery'"
- "Show me customer history for customer ID 5"

## Development

Run in development mode with hot reload:

```bash
npm run dev
```

Build for production:

```bash
npm run build
```

## Database Schema

The server connects to a PostgreSQL database with the following tables:

- `products` - Product information
- `customers` - Customer information
- `chat_sessions` - Chat session metadata
- `messages` - Individual messages in chat sessions
- `session_summaries` - Pre-computed view with session statistics

## Environment Variables

- `PGUSER` - PostgreSQL username (defaults to system user)
- `PGPASSWORD` - PostgreSQL password (optional for local development)
- `PGHOST` - PostgreSQL host (defaults to localhost)
- `PGPORT` - PostgreSQL port (defaults to 5432)
- `PGDATABASE` - Database name (defaults to customer_support)

## Security

The `execute_custom_query` tool only allows SELECT statements to prevent destructive operations on the database.
