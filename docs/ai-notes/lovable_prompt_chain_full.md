# Lovable Master Prompt — AI Tools (Paste-ready)

You are building a production-minded AI tool on Lovable.dev. Follow **every** instruction below with zero omissions.

{Include sections in order:}
- 00_objective
- 01_ux_foundation
- 02_demo_flow
- 03_exports
- 04_security
- 05_accessibility
- 06_performance
- 07_wow_moments
- 08_ux_patterns
- 09_video_media
- 10_model_routing
- 11_governance_rules

### Persistence & Privacy
- Enforce RLS and user isolation. For shared exports, anonymize identifiers and strip PII.
- Never expose secrets client-side. Use server functions.

### Exports & Direct Integrations
- Provide PDF, MP4/WebM, and share links.
- Integrate Notion (append or create page), Canva (populate template), Google Drive (upload file).

### Demo Hero Sequence
Onboarding → AI action → animated response (with media) → export/share (audit logged).

### Accessibility
- WCAG 2.2 AA checks must run on every render; fix automatically where safe. Provide captions/alt text.

### Performance
- Observe budgets (LCP ≤ 2.5s, CLS ≤ 0.1, TTI ≤ 3.5s). Stream long operations. Cache common computations.

### Fallback Behavior
- If video not supported, fallback to animated image → static image, and **explain** the downgrade to the user briefly.

### Observability & Audit
- Log: model, tokens_in/out, latency_ms, export events (destination, artifact hash, checksum, time, user hash).
## Objective (Paste into Lovable)
Build a user-friendly AI tool that solves a real, validated problem using **Lovable AI + Lovable Cloud**.
Prioritize: problem/solution clarity, seamless AI+Cloud integration, delightful + accessible UX, and production exports.
## UI/UX Foundation
- Mobile-first responsive layout with parity on desktop.
- Dark/light themes; neutral by default; toggle to FlashFusion brand.
- Micro-interactions (hover, press, page transitions) with reduced-motion fallback.
- Video-in-UI (looping previews/tutorials) where supported; graceful downgrade to GIF → static.
- Sound/haptics on mobile; disabled if `prefers-reduced-motion` or `prefers-reduced-transparency`.
- WCAG 2.2 AA: keyboard nav, ARIA, contrast, focus order.
## Hardwired Demo Flow (Hero)
1) Onboarding (goals + preferences) →
2) AI Action (multi-model) →
3) Animated Response (video/visuals) →
4) Export/Share (PDF/Notion/Canva/Drive).
Allow free exploration outside the guided path.
## Exports & Integrations
- Exports: PDF (print-ready), MP4/WebM snippets, share links.
- Direct Integrations: Notion (page append), Canva (template fill), Google Drive (file upload).
- Export audit log: destination, artifact hash, checksum, user hash, timestamp.
## Security, Privacy & RLS
- Enforce Row-Level Security; user-only access by default.
- Anonymize all shared artifacts; strip PII.
- Never surface raw keys; use server functions for secrets.
## Accessibility (Enforced)
- Run a11y checks each render; log failures and apply auto-fixes when deterministic.
- Provide captions for video, alt text for images, and consistent landmarks (header/main/footer).
## Performance & Guardrails
- Preload critical UI; lazy-load heavy media.
- Cap AI request concurrency; stream partial results.
- Budgets: LCP ≤ 2.5s, CLS ≤ 0.1, TTI ≤ 3.5s.
- Retry/backoff for model calls; cache repeated prompts (Redis).
## Wow Moments (Auto-Demonstrated)
- Personalized onboarding visuals and tone presets.
- Animated AI response (typing + visual flourish, reduced motion fallback).
- Context-aware recommendations that learn preferences.
- One-click “Export & Share” with visible audit confirmation.
## UX Patterns
- Empty states with guided actions.
- Inline validation and recovery steps.
- Progress indicators with optimistic UI.
- Granular undo/redo; autosave with version history.
## Video & Media Constraints
- Keep clips ≤ 10s for previews; loop by default.
- Provide user control: pause, mute, replay.
- If device perf is low → fallback to poster frame.
## Model Routing (Guidance)
- Claude: structure, long-form writing, safety/compliance.
- Gemini: images/video generation, OCR/screens, media summaries.
- GPT: code-gen, UI logic, tests, schema.
- Grok / search agent: retrieval & web context; fallback to Firecrawl.
Record `{model, tokens_in, tokens_out, latency_ms}` per call.
## Governance (Embed & Log)
- Explain fallback when a feature downgrades.
- Validate WCAG on every render; log pass/fail + fixes.
- Log every export for audit (see schema in governance).
