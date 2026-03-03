#!/bin/bash

echo "================================"
echo "Testing Customer Support MCP Setup"
echo "================================"
echo ""

# Test 1: Check PostgreSQL
echo "[1/5] Checking PostgreSQL..."
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
if psql -d customer_support -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ PostgreSQL is running and accessible"
else
    echo "❌ PostgreSQL connection failed"
    exit 1
fi

# Test 2: Check database tables
echo ""
echo "[2/5] Checking database tables..."
TABLES=$(psql -d customer_support -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
if [ "$TABLES" -ge 4 ]; then
    echo "✅ Database tables exist ($TABLES tables found)"
else
    echo "❌ Database tables missing"
    exit 1
fi

# Test 3: Check sample data
echo ""
echo "[3/5] Checking sample data..."
SESSIONS=$(psql -d customer_support -t -c "SELECT COUNT(*) FROM chat_sessions;")
MESSAGES=$(psql -d customer_support -t -c "SELECT COUNT(*) FROM messages;")
echo "✅ Found $SESSIONS chat sessions and $MESSAGES messages"

# Test 4: Check MCP server files
echo ""
echo "[4/5] Checking MCP server..."
if [ -f "mcp-server/dist/index.js" ]; then
    echo "✅ MCP server build exists"
else
    echo "⚠️  MCP server not built, building now..."
    cd mcp-server && npm run build && cd ..
    if [ -f "mcp-server/dist/index.js" ]; then
        echo "✅ MCP server built successfully"
    else
        echo "❌ MCP server build failed"
        exit 1
    fi
fi

# Test 5: Check MCP configuration
echo ""
echo "[5/5] Checking MCP configuration..."
if [ -f "$HOME/.config/claude/mcp_config.json" ]; then
    echo "✅ MCP configuration exists"
else
    echo "❌ MCP configuration not found"
    exit 1
fi

echo ""
echo "================================"
echo "✅ All tests passed!"
echo "================================"
echo ""
echo "Sample queries to try:"
echo "  • What are the most common customer issues?"
echo "  • Show me product insights for all products"
echo "  • What's the average resolution time by category?"
echo "  • Search for conversations mentioning 'battery'"
echo ""
echo "To get started, ask Claude any of these questions!"
