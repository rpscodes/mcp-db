import "dotenv/config";
import express from "express";
import cors from "cors";
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import OpenAI from "openai";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const app = express();
app.use(cors());
app.use(express.json());

let mcpClient: Client;
let openaiTools: OpenAI.Chat.Completions.ChatCompletionTool[] = [];

async function initMCP() {
  const serverPath = path.resolve(__dirname, "../mcp-server/dist/index.js");
  const transport = new StdioClientTransport({
    command: "node",
    args: [serverPath],
  });

  mcpClient = new Client({ name: "chat-ui", version: "1.0.0" });
  await mcpClient.connect(transport);

  const { tools } = await mcpClient.listTools();
  openaiTools = tools.map((tool) => ({
    type: "function" as const,
    function: {
      name: tool.name,
      description: tool.description || "",
      parameters: tool.inputSchema as Record<string, unknown>,
    },
  }));

  console.log(
    `MCP connected. ${openaiTools.length} tools available:`,
    openaiTools.map((t) => t.function.name).join(", ")
  );
}

const SYSTEM_PROMPT = `You are a Support Insights Agent for SkyVision Drones, a drone manufacturing company. You have access to a database of customer support chat sessions covering consumer drones (SkyVision Pro, Scout Mini, AeroMax 4K), commercial drones (AgriScan 200, SurveyHawk X1), and accessories (batteries, controllers, gimbals, prop guards, chargers).

Use the available tools to query the database and provide data-driven answers. When presenting data:
- Use clear formatting with headers and bullet points
- Highlight key metrics and trends
- Provide actionable insights for operations teams (reducing top pain points) and product management (product discovery, roadmap planning)
- If a query returns no results, suggest alternative approaches

Always query the data before answering — don't guess or make up statistics.`;

app.post("/api/chat", async (req, res) => {
  const { messages } = req.body as {
    messages: OpenAI.Chat.Completions.ChatCompletionMessageParam[];
  };

  res.setHeader("Content-Type", "text/event-stream");
  res.setHeader("Cache-Control", "no-cache");
  res.setHeader("Connection", "keep-alive");

  const send = (event: string, data: unknown) => {
    res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
  };

  try {
    const openai = new OpenAI();
    const conversation: OpenAI.Chat.Completions.ChatCompletionMessageParam[] = [
      { role: "system", content: SYSTEM_PROMPT },
      ...messages,
    ];

    let iterations = 0;
    const MAX_ITERATIONS = 10;

    while (iterations < MAX_ITERATIONS) {
      iterations++;

      const stream = await openai.chat.completions.create({
        model: "gpt-4o",
        messages: conversation,
        tools: openaiTools.length > 0 ? openaiTools : undefined,
        stream: true,
      });

      let assistantContent = "";
      const toolCalls: Map<
        number,
        { id: string; name: string; arguments: string }
      > = new Map();

      for await (const chunk of stream) {
        const delta = chunk.choices[0]?.delta;
        if (!delta) continue;

        if (delta.content) {
          assistantContent += delta.content;
          send("content", { text: delta.content });
        }

        if (delta.tool_calls) {
          for (const tc of delta.tool_calls) {
            if (!toolCalls.has(tc.index)) {
              toolCalls.set(tc.index, { id: "", name: "", arguments: "" });
            }
            const entry = toolCalls.get(tc.index)!;
            if (tc.id) entry.id = tc.id;
            if (tc.function?.name) entry.name = tc.function.name;
            if (tc.function?.arguments) entry.arguments += tc.function.arguments;
          }
        }
      }

      if (toolCalls.size === 0) {
        break;
      }

      const toolCallsArray = Array.from(toolCalls.values());

      conversation.push({
        role: "assistant",
        content: assistantContent || null,
        tool_calls: toolCallsArray.map((tc) => ({
          id: tc.id,
          type: "function" as const,
          function: { name: tc.name, arguments: tc.arguments },
        })),
      });

      for (const tc of toolCallsArray) {
        send("tool_call", { name: tc.name, arguments: tc.arguments });

        try {
          const args = JSON.parse(tc.arguments || "{}");
          const result = await mcpClient.callTool({
            name: tc.name,
            arguments: args,
          });

          const resultText =
            typeof result.content === "string"
              ? result.content
              : Array.isArray(result.content)
                ? result.content
                    .map((c: { type: string; text?: string }) =>
                      c.type === "text" ? c.text : JSON.stringify(c)
                    )
                    .join("\n")
                : JSON.stringify(result.content);

          send("tool_result", {
            name: tc.name,
            result: resultText.slice(0, 2000),
          });

          conversation.push({
            role: "tool",
            tool_call_id: tc.id,
            content: resultText,
          });
        } catch (err) {
          const errorMsg = err instanceof Error ? err.message : String(err);
          send("tool_result", { name: tc.name, result: `Error: ${errorMsg}` });
          conversation.push({
            role: "tool",
            tool_call_id: tc.id,
            content: `Error: ${errorMsg}`,
          });
        }
      }
    }

    send("done", {});
    res.end();
  } catch (err) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    send("error", { message: errorMsg });
    res.end();
  }
});

// Serve static files in production
app.use(express.static(path.join(__dirname, "dist")));
app.get("*", (_req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});

const PORT = process.env.PORT || 3001;

initMCP()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Failed to initialize MCP client:", err);
    process.exit(1);
  });
