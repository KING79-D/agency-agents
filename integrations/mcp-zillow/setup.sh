#!/usr/bin/env bash
#
# setup.sh -- Install the MCP Zillow server for real estate search/listing tools.
#
# Usage:
#   ./integrations/mcp-zillow/setup.sh
#
# NOTE: This installs a third-party package (@striderlabs/mcp-zillow) that
# drives a headless browser against zillow.com. Review Zillow's Terms of
# Use and the package source before running this in any automated context.

set -euo pipefail

echo "MCP Zillow Integration Setup"
echo "=============================="
echo ""
echo "This will install @striderlabs/mcp-zillow and its Playwright browser."
echo "It is a third-party package, not maintained by this project."
echo "See integrations/mcp-zillow/README.md for ToS and risk notes before continuing."
echo ""
read -r -p "Continue? [y/N] " REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

npm install @striderlabs/mcp-zillow
npx playwright install chromium

echo ""
echo "Installed. Add this to your MCP client config:"
echo ""
echo '  {'
echo '    "mcpServers": {'
echo '      "zillow": {'
echo '        "command": "npx",'
echo '        "args": ["mcp-zillow"]'
echo '      }'
echo '    }'
echo '  }'
echo ""
echo "See integrations/mcp-zillow/README.md for how to wire this into an agent prompt."
