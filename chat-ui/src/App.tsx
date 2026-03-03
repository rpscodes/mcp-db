import { useState, useRef, useEffect } from "react";

interface ToolCall {
  name: string;
  arguments: string;
  result?: string;
  expanded?: boolean;
}

interface Message {
  role: "user" | "assistant";
  content: string;
  toolCalls?: ToolCall[];
}

const SUGGESTIONS = [
  "What are the most common issues with the SkyVision Pro?",
  "Show me component health across the ecosystem",
  "What features are customers requesting?",
  "Which components have the worst resolution times?",
];

export default function App() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  async function sendMessage(text: string) {
    if (!text.trim() || loading) return;

    const userMsg: Message = { role: "user", content: text.trim() };
    const updatedMessages = [...messages, userMsg];
    setMessages(updatedMessages);
    setInput("");
    setLoading(true);

    const assistantMsg: Message = { role: "assistant", content: "", toolCalls: [] };

    try {
      const apiMessages = updatedMessages.map((m) => ({
        role: m.role,
        content: m.content,
      }));

      const res = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ messages: apiMessages }),
      });

      const reader = res.body?.getReader();
      if (!reader) throw new Error("No response stream");

      const decoder = new TextDecoder();
      let buffer = "";

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split("\n");
        buffer = lines.pop() || "";

        let eventType = "";
        for (const line of lines) {
          if (line.startsWith("event: ")) {
            eventType = line.slice(7);
          } else if (line.startsWith("data: ")) {
            const data = JSON.parse(line.slice(6));

            if (eventType === "content") {
              assistantMsg.content += data.text;
              setMessages([...updatedMessages, { ...assistantMsg }]);
            } else if (eventType === "tool_call") {
              assistantMsg.toolCalls = [
                ...(assistantMsg.toolCalls || []),
                { name: data.name, arguments: data.arguments },
              ];
              setMessages([...updatedMessages, { ...assistantMsg }]);
            } else if (eventType === "tool_result") {
              const calls = assistantMsg.toolCalls || [];
              const last = calls.findLast((tc) => tc.name === data.name);
              if (last) last.result = data.result;
              setMessages([...updatedMessages, { ...assistantMsg }]);
            } else if (eventType === "error") {
              assistantMsg.content += `\n\nError: ${data.message}`;
              setMessages([...updatedMessages, { ...assistantMsg }]);
            }
          }
        }
      }
    } catch (err) {
      assistantMsg.content = `Error: ${err instanceof Error ? err.message : String(err)}`;
    }

    setMessages([...updatedMessages, { ...assistantMsg }]);
    setLoading(false);
  }

  function toggleToolCall(msgIndex: number, tcIndex: number) {
    setMessages((prev) =>
      prev.map((m, i) => {
        if (i !== msgIndex || !m.toolCalls) return m;
        return {
          ...m,
          toolCalls: m.toolCalls.map((tc, j) =>
            j === tcIndex ? { ...tc, expanded: !tc.expanded } : tc
          ),
        };
      })
    );
  }

  return (
    <div className="app">
      <header className="header">
        <h1>SkyVision Drones - Support Insights</h1>
        <p>Analyze drone customer support data for product and operations insights</p>
      </header>

      <div className="chat-area">
        {messages.length === 0 && (
          <div className="suggestions">
            <p className="suggestions-label">Try asking:</p>
            <div className="suggestions-grid">
              {SUGGESTIONS.map((s) => (
                <button key={s} className="suggestion" onClick={() => sendMessage(s)}>
                  {s}
                </button>
              ))}
            </div>
          </div>
        )}

        {messages.map((msg, i) => (
          <div key={i} className={`message ${msg.role}`}>
            <div className="message-label">{msg.role === "user" ? "You" : "Agent"}</div>
            <div className="message-bubble">
              {msg.toolCalls && msg.toolCalls.length > 0 && (
                <div className="tool-calls">
                  {msg.toolCalls.map((tc, j) => (
                    <div key={j} className="tool-call">
                      <button
                        className="tool-call-header"
                        onClick={() => toggleToolCall(i, j)}
                      >
                        <span className={`arrow ${tc.expanded ? "expanded" : ""}`}>
                          &#9654;
                        </span>
                        <span className="tool-name">{tc.name}</span>
                        <span className={`tool-status ${tc.result ? "done" : "running"}`}>
                          {tc.result ? "completed" : "running..."}
                        </span>
                      </button>
                      {tc.expanded && (
                        <div className="tool-call-body">
                          <div className="tool-section">
                            <div className="tool-section-label">Arguments</div>
                            <pre>{formatJson(tc.arguments)}</pre>
                          </div>
                          {tc.result && (
                            <div className="tool-section">
                              <div className="tool-section-label">Result</div>
                              <pre>{formatJson(tc.result)}</pre>
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}
              {msg.content && (
                <div className="message-content">{msg.content}</div>
              )}
            </div>
          </div>
        ))}

        {loading && messages[messages.length - 1]?.role === "user" && (
          <div className="message assistant">
            <div className="message-label">Agent</div>
            <div className="message-bubble">
              <div className="typing">Thinking...</div>
            </div>
          </div>
        )}

        <div ref={bottomRef} />
      </div>

      <div className="input-area">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            sendMessage(input);
          }}
        >
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask about drone support data..."
            disabled={loading}
          />
          <button type="submit" disabled={loading || !input.trim()}>
            Send
          </button>
        </form>
      </div>
    </div>
  );
}

function formatJson(str: string): string {
  try {
    return JSON.stringify(JSON.parse(str), null, 2);
  } catch {
    return str;
  }
}
