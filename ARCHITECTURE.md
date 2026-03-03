# SkyVision Drones Support Insights Agent - Architecture

## Architecture Overview

This is a full-stack, AI-powered customer support analytics system with **four layers**:

```
React Chat UI (Vite, port 5173)
        |  fetch + SSE
        v
Express Server + MCP Client (port 3001)
        |  stdio transport
        v
MCP Server (TypeScript, stdio)
        |  pg Pool
        v
PostgreSQL (localhost:5432, customer_support db)
```

---

## Architecture Diagram

```
+------------------------------------------------------------------+
|                     FRONTEND (React + Vite)                      |
|                        Port 5173                                 |
|                                                                  |
|  +------------------+  +------------------+  +----------------+  |
|  | Suggestion       |  | Message Bubbles  |  | Tool Call      |  |
|  | Buttons          |  | (User/Assistant) |  | Panels         |  |
|  +------------------+  +------------------+  +----------------+  |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |              App.tsx - State Management                     |  |
|  |  - messages[]    - streaming content    - SSE EventSource   |  |
|  +------------------------------------------------------------+  |
+----------------------------------+-------------------------------+
                                   |
                          fetch POST /api/chat
                          (JSON: messages array)
                                   |
                          SSE Response Stream:
                          - "content" events
                          - "tool_call" events
                          - "tool_result" events
                          - "done" event
                                   |
                                   v
+------------------------------------------------------------------+
|                 BACKEND (Express.js + MCP Client)                |
|                          Port 3001                               |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |                    POST /api/chat                           |  |
|  |                                                             |  |
|  |  1. Receive user message + conversation history             |  |
|  |  2. Send to GPT-4o with MCP tool definitions                |  |
|  |  3. Parse streaming response for tool_calls                 |  |
|  |  4. Execute tool calls via MCP Client                       |  |
|  |  5. Append tool results to conversation                     |  |
|  |  6. Loop back to step 2 (max 10 iterations)                 |  |
|  |  7. Stream final text response via SSE                      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  +---------------------------+  +-----------------------------+  |
|  | OpenAI SDK (GPT-4o)       |  | MCP Client (stdio)         |  |
|  | - Tool-calling API        |  | - Connects to MCP Server   |  |
|  | - Streaming responses     |  | - Executes tool calls      |  |
|  | - System prompt config    |  | - Returns JSON results     |  |
|  +---------------------------+  +-----------------------------+  |
+----------------------------------+-------------------------------+
                                   |
                          stdio (stdin/stdout)
                          JSON-RPC messages
                                   |
                                   v
+------------------------------------------------------------------+
|                   MCP SERVER (TypeScript, stdio)                 |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |              Tool Registry (9 Tools)                        |  |
|  |                                                             |  |
|  |  +-------------------+  +-------------------+              |  |
|  |  | get_chat_trends   |  | get_common_issues |              |  |
|  |  | Category dist,    |  | Keyword frequency |              |  |
|  |  | daily volume,     |  | analysis, stop-   |              |  |
|  |  | status breakdown  |  | word filtering    |              |  |
|  |  +-------------------+  +-------------------+              |  |
|  |                                                             |  |
|  |  +-------------------+  +---------------------+            |  |
|  |  | get_product_      |  | get_sentiment_      |            |  |
|  |  | insights          |  | analysis             |            |  |
|  |  | Complaint rates,  |  | Sentiment dist by   |            |  |
|  |  | satisfaction,     |  | category, overall   |            |  |
|  |  | resolution time   |  | percentages         |            |  |
|  |  +-------------------+  +---------------------+            |  |
|  |                                                             |  |
|  |  +-------------------+  +---------------------+            |  |
|  |  | get_resolution_   |  | search_             |            |  |
|  |  | metrics           |  | conversations       |            |  |
|  |  | Resolution rates, |  | Full-text keyword   |            |  |
|  |  | avg time, by      |  | search across all   |            |  |
|  |  | category          |  | messages            |            |  |
|  |  +-------------------+  +---------------------+            |  |
|  |                                                             |  |
|  |  +-------------------+  +---------------------+            |  |
|  |  | get_customer_     |  | execute_custom_     |            |  |
|  |  | history           |  | query               |            |  |
|  |  | Individual        |  | Ad-hoc SELECT       |            |  |
|  |  | customer sessions |  | queries (read-only) |            |  |
|  |  +-------------------+  +---------------------+            |  |
|  |                                                             |  |
|  |  +-------------------+                                      |  |
|  |  | get_component_    |                                      |  |
|  |  | health            |                                      |  |
|  |  | Per-component     |                                      |  |
|  |  | ecosystem health  |                                      |  |
|  |  | dashboard         |                                      |  |
|  |  +-------------------+                                      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |              CallToolRequestHandler                         |  |
|  |  - Receives tool name + args via stdio                      |  |
|  |  - Routes to correct handler (switch/case)                  |  |
|  |  - Executes parameterized SQL queries                       |  |
|  |  - Returns JSON results                                     |  |
|  +------------------------------------------------------------+  |
+----------------------------------+-------------------------------+
                                   |
                          SQL queries (parameterized)
                          pg.Pool connection pooling
                                   |
                                   v
+------------------------------------------------------------------+
|                    POSTGRESQL DATABASE                            |
|              localhost:5432 / customer_support                    |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |                      TABLES                                 |  |
|  |                                                             |  |
|  |  +------------------+       +--------------------+          |  |
|  |  | products (5)     |       | customers (15)     |          |  |
|  |  | - id             |       | - id               |          |  |
|  |  | - name           |       | - name             |          |  |
|  |  | - category       |       | - email            |          |  |
|  |  +------------------+       +--------------------+          |  |
|  |         |                          |                        |  |
|  |         |                          |                        |  |
|  |         |        +-----------------+                        |  |
|  |         |        |                                          |  |
|  |         v        v                                          |  |
|  |  +-----------------------------+                            |  |
|  |  | chat_sessions (25)          |                            |  |
|  |  | - id                        |                            |  |
|  |  | - customer_id (FK)          |                            |  |
|  |  | - product_id (FK)           |                            |  |
|  |  | - status (open/resolved/    |                            |  |
|  |  |          escalated)         |                            |  |
|  |  | - category (support/        |                            |  |
|  |  |   troubleshooting/          |                            |  |
|  |  |   complaint/feedback)       |                            |  |
|  |  | - priority (low/med/high)   |                            |  |
|  |  | - satisfaction_rating (1-5) |                            |  |
|  |  | - created_at, resolved_at   |                            |  |
|  |  +-----------------------------+                            |  |
|  |              |                                              |  |
|  |              v                                              |  |
|  |  +-----------------------------+                            |  |
|  |  | messages (100+)             |                            |  |
|  |  | - id                        |                            |  |
|  |  | - session_id (FK)           |                            |  |
|  |  | - sender (customer/agent)   |                            |  |
|  |  | - content (text)            |                            |  |
|  |  | - sentiment (positive/      |                            |  |
|  |  |   neutral/negative)         |                            |  |
|  |  | - created_at                |                            |  |
|  |  +-----------------------------+                            |  |
|  +------------------------------------------------------------+  |
+------------------------------------------------------------------+
```

---

## Agentic Loop Detail

```
                        User Message
                             |
                             v
                   +-------------------+
                   | Format for GPT-4o |
                   | (system prompt +  |
                   |  tools + history) |
                   +-------------------+
                             |
                             v
                 +-----------------------+
          +----->| Call GPT-4o (stream)  |
          |      +-----------------------+
          |                |
          |                v
          |      +-------------------+
          |      | Response contains |------- No ------+
          |      | tool_calls?       |                  |
          |      +-------------------+                  |
          |                |                            |
          |               Yes                           |
          |                |                            |
          |                v                            v
          |      +-------------------+        +------------------+
          |      | Execute each tool |        | Stream text      |
          |      | via MCP Client    |        | response via SSE |
          |      +-------------------+        | to frontend      |
          |                |                  +------------------+
          |                v                           |
          |      +-------------------+                 v
          |      | Append tool       |              [DONE]
          |      | results to        |
          |      | conversation      |
          |      +-------------------+
          |                |
          |                v
          |      +-------------------+
          +------| iteration < 10?  |------- No ------> [DONE]
                 +-------------------+
```

---

## Layer 1: PostgreSQL Database (`setup_database.sql`)

**4 tables** model a drone support center:

| Table | Rows | Purpose | Key Fields |
|---|---|---|---|
| `products` | 5 | SkyVision Pro ecosystem (Drone + Accessories) | name, category |
| `customers` | 15 | Customer profiles | name, email |
| `chat_sessions` | 25 | Support tickets (Jan-Feb 2024) | status, category, priority, satisfaction_rating |
| `messages` | 100+ | Individual chat messages | sender, content, sentiment |

**Why this design:** The schema mirrors a real support system with normalized relationships. Sentiment is pre-tagged on messages (positive/neutral/negative), enabling fast aggregation without runtime NLP. Sessions carry metadata (category, priority, status) that enables multi-dimensional analytics.

---

## Layer 2: MCP Server (`mcp-server/src/index.ts`)

This is the **data access layer**, implementing the [Model Context Protocol](https://modelcontextprotocol.io) with **9 tools**:

| Tool | What It Does |
|---|---|
| `get_chat_trends` | Category distribution, daily volume, status breakdown (filterable by component) |
| `get_common_issues` | Keyword frequency analysis from message text (filterable by component) |
| `get_product_insights` | Per-component complaint rates, satisfaction, resolution time |
| `get_sentiment_analysis` | Sentiment distribution overall, by category, and by component |
| `get_resolution_metrics` | Resolution rates, avg time, satisfaction by category and component |
| `search_conversations` | Full-text keyword search across messages |
| `get_customer_history` | Individual customer interaction history |
| `execute_custom_query` | Arbitrary SELECT queries for ad-hoc analysis |
| `get_component_health` | Ecosystem health dashboard: per-component issues, satisfaction, resolution time |

**Why MCP instead of a REST API:**
- **Standardized tool discovery** -- the AI can call `ListTools` to learn what's available, including input schemas and descriptions. No hardcoded API knowledge needed.
- **Reusable** -- the same MCP server works with Claude Desktop, Claude Code, or any MCP-compatible client, not just this UI.
- **Stdio transport** -- no network overhead; the Express server spawns the MCP server as a child process and communicates over stdin/stdout. This is simpler and faster than HTTP for local co-located services.

**Why parameterized SQL:** All queries use `$1, $2` placeholders (never string interpolation) to prevent SQL injection. The `execute_custom_query` tool enforces a `SELECT`-only check as a safety guardrail.

**Why connection pooling (`pg.Pool`):** Reuses database connections across tool calls rather than opening/closing per request, which is critical for responsiveness in an agentic loop where multiple tools may fire in sequence.

---

## Layer 3: Express Server + MCP Client (`chat-ui/server.ts`)

This is the **orchestration layer** -- the brain of the system. It does three things:

### 1. Bridges MCP tools to OpenAI's tool-calling format

On startup, it connects to the MCP server, fetches all available tools, and converts their MCP schemas into OpenAI-compatible function definitions. This means adding a new MCP tool automatically makes it available to the LLM -- zero frontend changes needed.

### 2. Implements the Agentic Loop

1. Receive user message + conversation history
2. Send to GPT-4o with tool definitions
3. If GPT-4o returns `tool_calls`: execute each via MCP client, append results, go to step 2
4. If GPT-4o returns text: stream to frontend via SSE
5. Max 10 iterations to prevent infinite loops

**Why a loop (up to 10 iterations):** Complex questions may require multiple tools. For example, "Compare product complaint rates and show me the worst conversations" needs `get_product_insights` then `search_conversations`. The loop lets the AI autonomously chain tools without frontend coordination.

### 3. Streams responses via Server-Sent Events (SSE)

Four event types flow to the frontend:

| Event | Purpose |
|---|---|
| `content` | Incremental text chunks from the LLM |
| `tool_call` | Tool name + arguments (so users see what's happening) |
| `tool_result` | Data returned from the tool (truncated to 2000 chars) |
| `done` | End of response |

**Why SSE instead of WebSockets:** SSE is simpler (unidirectional, built-in reconnection, works over HTTP/1.1), and we only need server-to-client streaming. WebSockets would be overengineered for this use case.

**Why stream at all:** Without streaming, the user would see nothing for 5-15 seconds while tools execute. Streaming provides real-time visibility into the AI's reasoning and tool usage, dramatically improving perceived performance and trust.

---

## Layer 4: React Chat UI (`chat-ui/src/App.tsx`)

A conversational interface with:

- **Message bubbles** -- blue for user, white-bordered for assistant
- **Collapsible tool call panels** -- shows exactly which tools were called, with what arguments, and what data came back. This is crucial for transparency and debugging.
- **Suggestion buttons** -- pre-built prompts like "What are the most common issues?" to lower the barrier to entry
- **Streaming rendering** -- content updates character-by-character as SSE events arrive

**Why React + Vite:** Vite provides instant HMR for development, and React's state model handles the incremental message updates from SSE cleanly. No state management library needed -- a single `useState` for messages is sufficient for this scope.

---

## Key Architectural Decisions Summary

| Decision | Rationale |
|---|---|
| **MCP over REST** | Standardized tool protocol; reusable across AI clients; auto-discovery |
| **Stdio transport** | Zero network overhead for co-located services; simpler than HTTP |
| **Agentic loop in backend** | Frontend stays dumb; AI chains tools autonomously |
| **SSE streaming** | Real-time UX; simpler than WebSockets for unidirectional flow |
| **Pre-tagged sentiment** | Fast aggregation; no runtime NLP dependency |
| **Separation into 3 processes** | Each layer is independently testable, replaceable, and scalable |
| **TypeScript throughout** | Type safety across all layers; shared tooling |
| **Tool transparency in UI** | Users see exactly what data the AI accessed -- builds trust |

---

## End-to-End Example

**User asks:** *"What are the most common drone issues?"*

1. **React** sends `POST /api/chat` with the message
2. **Express** forwards to GPT-4o with 9 tool definitions
3. **GPT-4o** decides to call `get_common_issues`
4. **Express** executes via MCP client -> **MCP Server** queries `messages` table, counts keyword frequencies, filters stop words, aggregates by category
5. **MCP Server** returns JSON: `{top_keywords: [{word: "battery", count: 12}, ...], issue_categories: [...]}`
6. **Express** adds result to conversation, calls GPT-4o again
7. **GPT-4o** now generates a natural language summary with insights
8. **React** renders the response with an expandable tool call panel showing the raw data

---

## Technology Stack

| Layer | Technology | Version |
|---|---|---|
| Frontend | React | 19.0 |
| Bundler | Vite | 6.0 |
| Backend | Express.js | 4.21 |
| AI | OpenAI SDK (GPT-4o) | 4.77 |
| Protocol | MCP SDK | 1.26 |
| Database Driver | pg | 8.18 |
| Database | PostgreSQL | 5432 |
| Language | TypeScript | 5.9 |

---

## Extension Points

1. **Add New Tools:** Edit `mcp-server/src/index.ts` TOOLS array and add handler in CallToolRequestSchema switch
2. **Add UI Features:** Extend `chat-ui/src/App.tsx` component
3. **Connect Real Data:** Replace INSERT statements in `setup_database.sql` with API endpoints
4. **Add Authentication:** Wrap Express endpoints with JWT/session middleware
5. **Scale Database:** Add indexes, connection pooling config, read replicas
6. **Caching:** Add Redis layer in MCP server for frequent queries
