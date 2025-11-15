# FlashFusion Agent Framework

## Quick Start

### View Available Prompts
```bash
ls -la ~/agents/prompts/
```

### Run Full Pipeline
```bash
# See execution.md for the complete workflow
cat ~/agents/prompts/04-execution.md
```

### Create Custom Agent
See `example-custom-agent.md` for a complete tutorial.

## Agent Roles

1. **Context Engineer** - Extract project context
2. **Deliverables Map** - Define outputs
3. **Safety & Quality** - Validate compliance
4. **Execution** - Run end-to-end pipeline
5. **Drift Guardian** - Self-audit

## Output Location
All agent outputs go to: `~/agents/outputs/<llm>-run/`

## Spec Version
Current: **3.2**
