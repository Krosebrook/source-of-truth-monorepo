# FlashFusion Telemetry Access Guide (2025)

## Purpose
Describe how FlashFusion teams access agent telemetry, correlate runs to commits/tickets, and manage credentials securely.

## Dashboards & Data Stores
| Destination | URL / Path | Data Scope | Owner |
| --- | --- | --- | --- |
| Telemetry Lake (Databricks) | `databricks://flashfusion/lakehouse/agents` | Raw agent envelopes, tool call logs, evaluator scores | Data Engineering |
| Operations Dashboard | `https://ops.flashfusion.internal/dashboards/agents-runtime` | Live SLOs (success rate, p95 latency, cost/task) | AI Ops |
| Compliance Dashboard | `https://ops.flashfusion.internal/dashboards/policy-violations` | Policy hits, escalation history, audit outcomes | Compliance |
| Incident Timeline | `https://ops.flashfusion.internal/incidents/trace` | Trace replay, incident tagging, rollback notes | Security |

## Credential Management
- Access provisioned via Okta group **`FlashFusion-Telemetry`** with least-privilege scopes per dashboard.
- Secrets for service accounts stored in shared secrets manager path `secrets/flashfusion/telemetry/{env}`; reference via CI/CD only.
- Rotation cadence: 90 days; logs appended to `logs/agents/telemetry-access-log.md`.
- Request new access through ServiceNow form `REQ-TELEMETRY-ACCESS`; approvals required from AI Ops + Compliance.

## Standard Queries
- **Trace drilldown**: use notebook `telemetry/notebooks/trace-diff.sql` with parameters `traceId`, `date`.
- **Cost analysis**: run `telemetry/jobs/cost-aggregator` daily; results in table `agents.cost_metrics_daily`.
- **Policy review**: evaluation hits stored in table `agents.policy_hits`; join with `agents.policy_snapshot` for context.

## Operational Notes
- Ensure each agent run pushes `traceId`, `commitSha`, `ticketId` metadata; monitor ingestion lag (<5 min target).
- Telemetry exports older than 18 months snapshotted to cold storage bucket `s3://flashfusion-telemetry-archive`.
- Incident notifications mirrored to Slack `#flashfusion-ai` via webhook `ops-telemetry-alerts`.

## Claims Check
- URLs reflect internal ops dashboards; verify access endpoints quarterly.
- Pending creation of `telemetry-access-log.md` in `logs/agents/`; ensure log exists before next rotation cycle.
