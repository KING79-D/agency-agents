# Robinhood Trading MCP Integration

> Give finance agents the ability to check live market data and manage a
> Robinhood account through the Model Context Protocol (MCP).

## What It Does

By default, agents in The Agency reason about markets and portfolios in the
abstract — they can write a thesis but can't see an account or act on it. The
Robinhood Trading MCP server changes that by exposing an agent's own
Robinhood account as tools:

- **Live account state**: Positions, buying power, and balances instead of
  numbers an analyst has to paste in
- **Market data**: Quotes and instrument lookups to ground research in
  current prices, not a stale snapshot
- **Order management**: Placing, reviewing, and canceling orders so a
  recommendation can become an action — with a human still deciding whether
  it should

## Setup

Add the server to Claude Code:

```bash
claude mcp add robinhood-trading --transport http https://agent.robinhood.com/mcp/trading
```

For other MCP clients, add the equivalent HTTP server entry to your MCP
config:

```json
{
  "mcpServers": {
    "robinhood-trading": {
      "transport": "http",
      "url": "https://agent.robinhood.com/mcp/trading"
    }
  }
}
```

Authentication and account linking happen through Robinhood's own OAuth flow
the first time a tool call is made — no credentials are stored in this repo
or in any agent file.

## ⚠️ Safety Rules (Non-Negotiable)

This integration moves real money. Any agent enhanced with it must follow
these rules without exception:

1. **Never place, modify, or cancel an order without explicit, informed
   user confirmation for that specific order.** Describe the order (symbol,
   side, quantity, order type, price, estimated cost) and get a clear "yes"
   first. A standing "you're authorized to trade for me" is not consent for
   a specific order.
2. **Always check account state before recommending size.** Pull current
   buying power and existing positions before suggesting a quantity — never
   assume.
3. **State risk plainly.** Every order suggestion includes what happens if
   the trade goes wrong, not just the upside.
4. **No leverage or options strategies beyond what the user has explicitly
   asked to use.** Don't escalate risk on your own initiative.
5. **Treat cancel/modify requests as urgent.** If a user wants to back out
   of an order, act on that before anything else.

## How to Add Trading to Any Finance Agent

To enhance an existing agent with trading capability, add a **Trading
Integration** section to the agent's prompt.

### The Pattern

```markdown
## Trading Integration

You have access to the Robinhood Trading MCP server for this account. Use it to:

- Pull live quotes and instrument data to ground analysis in current prices
- Check account buying power and existing positions before sizing any recommendation
- Translate an approved thesis into a specific order (symbol, side, quantity, order type)
- Review open orders and recent fills when asked for a portfolio or account update
- Cancel or modify an order immediately when the user asks, ahead of any other task

Before placing, modifying, or canceling any order:
- State the exact order you're about to submit and its estimated cost or proceeds
- Confirm the user has explicitly approved *this* order, not a general go-ahead
- Check that account buying power actually supports it

Never place an order speculatively "to see what happens," and never increase
position size or add leverage beyond what the user specifically requested.
```

### What the Agent Does With This

The LLM will use the Robinhood MCP tools automatically when given these
instructions — typically tools for quotes and instrument lookup, account and
position state, and order placement/review/cancellation. No code changes to
the agent files, no API integration to write by hand.

## Example: Enhancing the Investment Researcher

See [finance-investment-researcher-with-trading.md](finance-investment-researcher-with-trading.md)
for a complete example — the standard Investment Researcher agent with a
Trading Integration section added, so a research thesis can be checked
against the live account and turned into a confirmed order.

## Tips

- **Research and execution are different confidence levels.** An agent can
  be high-conviction on a thesis and still require explicit per-order
  confirmation — the two aren't in tension.
- **Paper-trade the workflow first.** Run the agent through its full
  research-to-order flow with small, low-risk orders before trusting it with
  size.
- **Keep the agent useful without the integration.** Per the repo's agent
  design guidelines, strip this section out and the Investment Researcher
  should still be a complete, useful agent on its own.
