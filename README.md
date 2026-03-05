# SkyVision Drones - Support Insights Agent

## Running the Project

```bash
# 1. Start PostgreSQL
brew services start postgresql@16

#2. Create a .env file under the chat-ui folder and add your LLM API key
cd chat-ui
echo "OPENAI_API_KEY=ADD_YOUR_API_KEY_HERE" > .env

# 3. Start the app (backend + frontend)
npm run dev

# 4. Open in browser
open http://localhost:5173/
```

To stop:
```bash
# Ctrl+C in the terminal running npm run dev
brew services stop postgresql@16
```

---

An AI-powered system that analyzes customer support chat data for a drone manufacturing company using MCP (Model Context Protocol) and Claude.

## Project Structure

```
mcp-db/
├── README.md                    # This file
├── USAGE_GUIDE.md              # Detailed usage instructions and examples
├── setup_database.sql          # Database schema and sample data
├── test_setup.sh               # Verification script
└── mcp-server/                 # MCP server implementation
    ├── src/
    │   └── index.ts            # Main server code with 9 analysis tools
    ├── dist/                   # Compiled JavaScript (generated)
    ├── package.json
    ├── tsconfig.json
    └── README.md               # MCP server documentation
```

## What This Project Does

This system enables natural language conversations with Claude to gain insights from SkyVision Drones' customer support data:

- **Operations insights**: Identify top pain points, common hardware/software issues, and reduce support volume
- **Product discovery**: Use customer feedback to inform roadmap planning and feature prioritization
- **Analyze trends**: Chat volume, categories, satisfaction ratings over time
- **Product insights**: Complaint rates, resolution times, satisfaction by drone model
- **Sentiment analysis**: Track customer sentiment across conversations
- **Search conversations**: Find specific topics or keywords in chat history
- **Customer analytics**: View individual customer interaction patterns
- **Custom queries**: Run SQL queries for advanced analysis

## Components

### 1. PostgreSQL Database
- **Database name**: `customer_support`
- **Sample data**: 25 chat sessions, 15 customers, 5 products (SkyVision Pro ecosystem), ~100+ messages
- **Time period**: January-February 2024
- **Categories**: Support, troubleshooting, complaint, feedback

### 2. MCP Server (TypeScript)
- Built with `@modelcontextprotocol/sdk`
- Provides 9 specialized tools for data analysis
- Connects to PostgreSQL via `pg` library
- Runs as stdio server for Claude integration

### 3. Agent (Claude)
- Uses MCP server tools to analyze data
- Answers questions in natural language
- Provides insights, trends, and recommendations
- Can execute complex multi-tool analyses

## Quick Start

### Prerequisites
✅ PostgreSQL 16 (installed via Homebrew)
✅ Node.js 18+ (for MCP server)
✅ Claude Code CLI

### Verify Setup

Run the test script:

```bash
./test_setup.sh
```

This will check:
- PostgreSQL connection
- Database tables and data
- MCP server build
- Configuration files

### Start Using

Simply start asking Claude questions about your drone support data:

```
"What are the most common drone issues?"
"Show me product insights for all products"
"Which drones have the most warranty claims?"
"What features are customers requesting?"
```

See `USAGE_GUIDE.md` for many more examples!

## Setup Details

### Database Connection
- Host: localhost
- Port: 5432
- Database: customer_support
- User: Your system user
- No password required for local development

### MCP Configuration
Located at: `~/.config/claude/mcp_config.json`

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

## Sample Data Overview

### Products (5 — SkyVision Pro Ecosystem)

**Drone:**
- SkyVision Pro (flagship drone, $1,200)

**Accessories:**
- FlightPack Battery 6000mAh
- DroneLink Controller
- VisionCam Gimbal
- QuickCharge Hub

### Chat Categories
- **Support** (30%): Setup help, compatibility questions, warranty claims
- **Troubleshooting** (35%): Motor failure, GPS errors, connectivity, arming issues
- **Complaint** (25%): Battery quality, camera quality, signal loss, pricing
- **Feedback** (10%): Feature requests, positive reviews, product suggestions

### Sample Scenarios
- Motor bearing failure (SkyVision Pro)
- Compass calibration for first-time flyers (SkyVision Pro)
- Image quality complaint and return (VisionCam Gimbal)
- Swollen/fast-draining battery issues (FlightPack Battery)
- Failed firmware update bricking drone (SkyVision Pro)
- Return-to-Home failure during flight (SkyVision Pro)
- Lost drone due to signal loss and low RTH altitude (SkyVision Pro)
- Controller connectivity and pairing issues (DroneLink Controller)
- Feature requests: follow-me mode, obstacle avoidance
- Positive feedback: flight stability, real estate photography, QuickCharge Hub
- Battery storage and maintenance tips (FlightPack Battery)

## Available MCP Tools

1. **get_chat_trends** - Trends over time with component filtering
2. **get_common_issues** - Keyword frequency analysis with component filtering
3. **get_product_insights** - Per-component metrics for the ecosystem
4. **get_sentiment_analysis** - Sentiment distribution by component and category
5. **get_resolution_metrics** - Resolution performance by component
6. **search_conversations** - Keyword search
7. **get_customer_history** - Customer interaction history
8. **execute_custom_query** - Custom SQL (SELECT only)
9. **get_component_health** - Ecosystem health dashboard

## Example Insights You Can Get

### Operations Questions
- "What are the top pain points across all drones?"
- "Which products generate the most support tickets?"
- "What issues are taking longest to resolve?"
- "How many warranty claims do we have by product?"

### Product Management Questions
- "What features are customers requesting?"
- "What's the customer sentiment for each drone model?"
- "What are the most common complaints about our batteries?"
- "Which products have the highest satisfaction ratings?"

### Customer Intelligence
- "Show me all conversations about signal loss"
- "Show me the component health dashboard"
- "What are customers saying about the SkyVision Pro?"
- "Which customers have contacted us multiple times?"
- "What's the feedback on our commercial drones?"

## Extending the Project

### Add More Data
1. Insert new records via SQL
2. Connect a real-time data source
3. Import CSV files
4. Build an API for data ingestion

### Customize Analysis
1. Add new tools to `mcp-server/src/index.ts`
2. Create custom SQL views
3. Implement new analytics algorithms
4. Add data visualization exports

### Scale Up
1. Use connection pooling for production
2. Add caching layer (Redis)
3. Implement data partitioning
4. Set up read replicas

## Technology Stack

- **Database**: PostgreSQL 16
- **MCP Server**: TypeScript, Node.js
- **MCP SDK**: @modelcontextprotocol/sdk
- **DB Client**: node-postgres (pg)
- **AI Agent**: Claude (via Claude Code)
- **Protocol**: Model Context Protocol (MCP)

## Architecture

```
┌─────────────────┐
│     Claude      │ (Agent - Natural Language Interface)
│   (AI Agent)    │
└────────┬────────┘
         │ MCP Protocol
         │ (stdio)
         │
┌────────▼────────┐
│   MCP Server    │ (9 Analysis Tools)
│  (TypeScript)   │
└────────┬────────┘
         │ SQL Queries
         │ (pg library)
         │
┌────────▼────────┐
│   PostgreSQL    │ (SkyVision Drones Support Data)
│    Database     │
└─────────────────┘
```

## Documentation

- `README.md` (this file) - Project overview and setup
- `USAGE_GUIDE.md` - Detailed usage examples and queries
- `mcp-server/README.md` - MCP server technical docs
- `setup_database.sql` - Database schema with comments

## Troubleshooting

### PostgreSQL Not Running
```bash
brew services start postgresql@16
```

### MCP Server Not Found
```bash
cd mcp-server && npm run build
```

### Database Connection Error
```bash
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
```

### MCP Config Not Loading
Restart your Claude session after making config changes.

<!-- ## Future Enhancements

- [ ] Real-time data streaming
- [ ] Dashboard for visualizations
- [ ] Automated report generation
- [ ] Integration with ticketing systems
- [ ] Machine learning for issue prediction
- [ ] Multi-language support
- [ ] Export capabilities (CSV, PDF, Excel)
- [ ] Email alert system for critical issues -->

## License

MIT

## Support

For issues or questions:
1. Check `USAGE_GUIDE.md` for detailed examples
2. Run `./test_setup.sh` to verify setup
3. Check PostgreSQL logs for database issues
4. Review MCP server logs for tool errors

## Author

Built as a demonstration of MCP server capabilities for drone support analytics.
