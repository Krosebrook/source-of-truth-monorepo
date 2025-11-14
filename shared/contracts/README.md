# Agent Contracts

This directory contains unified schemas and contracts for all FlashFusion AI agents.

## Files

- `agent-output.schema.json` - Unified JSON schema for agent outputs

## Usage

All agents (Claude, Codex, Gemini, GitHub Agent) must accept these CLI flags:

```bash
agent-cli --prompt <path> --context <path> --output-schema <path> --out <dir>
```

## Agent Parity

Each agent must:

1. Accept the four standard CLI flags
2. Output JSON conforming to `agent-output.schema.json`
3. Provide validation before execution
4. Log to structured JSON format (see `shared/logging/`)

## Validation

To validate agent output:

```bash
# Using ajv-cli
npx ajv validate -s shared/contracts/agent-output.schema.json -d output.json

# Using Node.js
node scripts/validate-agent-output.js output.json
```
