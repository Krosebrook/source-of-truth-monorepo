# OTEL Telemetry Pilot Runbook (HarvestFlow) — 2025-11-15

Purpose: Implement the Splunk-style “compliance & observability fabric” path by instrumenting one agent workflow end-to-end and logging verifiable evidence (trace IDs + hashes) into `docs/compliance/compliance_log.json`.

## Target Workflow
- **System**: HarvestFlow orchestrator (file audit + release bundle pipeline).
- **Entry Point**: `projects/local/harvestflow/scripts/create_release_bundle.ts`.
- **Signals**: Traces (agent turn → tool call), metrics (duration, success), events (policy decisions).

## Prerequisites
1. Install OTEL CLI / collectors (local dev): `pnpm add -w @opentelemetry/api @opentelemetry/sdk-node`.
2. Configure exporter (dev) → `OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318`.
3. Register service metadata:
   ```json
   {
     "service.name": "harvestflow-orchestrator",
     "service.namespace": "agents",
     "deployment.environment": "dev"
   }
   ```
4. Update `.env.local` with telemetry toggles (`ENABLE_AI_TELEMETRY=true`).

## Instrumentation Steps
1. **Bootstrap SDK**
   ```ts
   // projects/local/harvestflow/scripts/telemetry.ts
   const sdk = new NodeSDK({
     resource: new Resource({
       [SEMRESATTRS_SERVICE_NAME]: "harvestflow-orchestrator",
       [SEMRESATTRS_DEPLOYMENT_ENVIRONMENT]: process.env.DEPLOYMENT_ENV || "dev"
     }),
     traceExporter: new OTLPTraceExporter(),
     metricReader: new PeriodicExportingMetricReader({
       exporter: new OTLPMetricExporter()
     })
   });
   ```
2. **Wrap agent turns**
   ```ts
   await tracer.startActiveSpan("agent.turn", span => {
     span.setAttribute("agent.role", "orchestrator");
     span.setAttribute("workflow.id", "harvestflow-release");
     // ... execute main logic
     span.end();
   });
   ```
3. **Log safety events**
   - Emit event `safety.policy.decision` with attributes `policy_id`, `verdict`, `confidence`.
4. **Capture artefact hashes**
   - After run completion, compute `sha256` for generated bundle + logs.
   - Append record to `docs/compliance/compliance_log.json` with fields:
     ```json
     {
       "trace_id": "<otel-trace-id>",
       "artefacts": [
         {"path": "harvestflow/bundles/<id>.tar.gz", "sha256": "<hash>"}
       ]
     }
     ```

## Verification Checklist
- [ ] OTEL collector receives spans (verify via `docker logs otel-collector` or Splunk Observability UI).
- [ ] Trace ID + artefact hashes documented in compliance log.
- [ ] Council notified (include trace link) before promoting instrumentation beyond dev.
- [ ] Alerts configured for:
  - Missing telemetry (`otel.export.failure` > 3 in 5 min).
  - Span duration > SLA (5m) for `agent.turn`.

## Rollout Plan
1. Pilot in dev (single engineer) → capture evidence.
2. Present results to AI Governance Council (2025-11-19) for go/no-go.
3. Enable telemetry flag in staging → watch metrics.
4. Document lessons learned + automation requirements (CI checks for telemetry toggles).

## References
- Splunk “AI Governance in 2025” — Compliance & Observability Fabric guidance.
- OTEL Semantic Conventions for AI agents (Google whitepaper).
