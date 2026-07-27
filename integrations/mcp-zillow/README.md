# MCP Zillow Integration

> Give any agent access to Zillow real estate search and listings using the Model Context Protocol (MCP).

## What It Does

An MCP Zillow server exposes tools for searching homes, retrieving property details, Zestimates, and rental listings directly to an agent — no manual copy-paste of listing data required.

This integration points to [`@striderlabs/mcp-zillow`](https://www.npmjs.com/package/@striderlabs/mcp-zillow), a third-party MCP server. It is **not maintained by this project** and is not vendored into this repo — you install and run it yourself, at your own discretion.

## Before You Use This

- **Read Zillow's Terms of Use** before pointing any automated tool at zillow.com. Automated scraping/access is restricted under Zillow's ToS, and `@striderlabs/mcp-zillow` works by driving a headless browser (Playwright) against the live site, including a stealth plugin intended to evade bot detection. Using it may violate Zillow's terms and put your account/IP at risk of being blocked.
- **This is a young, single-maintainer package** (v1.0.0 at time of writing). Review its source and dependencies yourself before running it — treat it like any other third-party code with browser-automation capabilities.
- Prefer Zillow's official APIs/data licensing options for any production or commercial use case.

## Setup

Install the server and its browser dependency:

```bash
npm install @striderlabs/mcp-zillow
npx playwright install chromium
```

Add it to your MCP client config (Claude Code, Cursor, Claude Desktop, etc.):

```json
{
  "mcpServers": {
    "zillow": {
      "command": "npx",
      "args": ["mcp-zillow"]
    }
  }
}
```

Any MCP server that exposes Zillow search/listing tools under compatible names will work — check the [MCP ecosystem](https://modelcontextprotocol.io) for alternatives.

## How to Add Zillow Access to Any Agent

To enhance an existing agent (e.g. a Real Estate researcher or market-analysis agent) with Zillow access, add a section like this to the agent's prompt:

```markdown
## Zillow Integration

When researching properties or markets:
- Use the Zillow MCP tools to search listings, pull property details, and retrieve Zestimates instead of asking the user to paste listing data
- Cite the source listing (address/URL) for any figures you report
- Do not present Zestimates as appraisals or guaranteed values — they are automated estimates
```

## Tips

- **Scope your queries**: pull only the listings/fields you need — repeated broad scraping is more likely to trip anti-bot defenses and more likely to violate ToS.
- **Cache results locally** if an agent needs to reference the same listings across a session, rather than re-querying.
