#!/usr/bin/env bash
#
# setup.sh -- Register the Robinhood Trading MCP server for agent use.
#
# Usage:
#   ./integrations/mcp-robinhood-trading/setup.sh

set -euo pipefail

echo "Robinhood Trading MCP Integration Setup"
echo "========================================"
echo ""

SERVER_NAME="robinhood-trading"
SERVER_URL="https://agent.robinhood.com/mcp/trading"

if command -v claude >/dev/null 2>&1; then
  echo "Registering the server with Claude Code..."
  claude mcp add "$SERVER_NAME" --transport http "$SERVER_URL"
  echo ""
  echo "Registered. Claude Code will prompt you to link your Robinhood"
  echo "account the first time an agent calls one of its tools."
else
  echo "The 'claude' CLI was not found on PATH."
  echo ""
  echo "Register the server manually for Claude Code:"
  echo "  claude mcp add $SERVER_NAME --transport http $SERVER_URL"
  echo ""
  echo "For other MCP clients, add this to your MCP config instead:"
  echo ""
  echo '  {'
  echo '    "mcpServers": {'
  echo "      \"$SERVER_NAME\": {"
  echo '        "transport": "http",'
  echo "        \"url\": \"$SERVER_URL\""
  echo '      }'
  echo '    }'
  echo '  }'
fi

echo ""
echo "This integration moves real money. Before using it with any agent:"
echo "  1. Read integrations/mcp-robinhood-trading/README.md in full,"
echo "     especially the Safety Rules section"
echo "  2. Add a Trading Integration section to the agent's prompt"
echo "     (see finance-investment-researcher-with-trading.md for an example)"
echo "  3. Confirm the agent asks for explicit, per-order approval before"
echo "     it submits, modifies, or cancels anything"
