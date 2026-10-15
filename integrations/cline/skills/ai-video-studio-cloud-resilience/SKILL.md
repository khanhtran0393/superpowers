---
name: ai-video-studio-cloud-resilience
description: Design or debug AI Video Studio calls to Gemini, OpenAI, ElevenLabs, licensing services, or other network APIs, including timeouts, retries, backoff, rate limits, circuit breakers, cancellation, and job recovery.
---

# AI Video Studio: cloud resilience

Use when changing cloud AI requests, licensing/API calls, retries, timeout handling, provider failover, job polling, or backend outages. Inspect the actual caller, provider semantics, and error contract before adding resilience behavior.

## Request model

- Define an end-to-end deadline and separate connection, per-attempt, and overall operation timeouts.
- Classify permanent failures (most 4xx validation/auth/permission errors), transient failures (connection resets, selected 5xx, temporary network failures), rate limits (429/Retry-After), cancellation, and uncertain outcomes.
- Retry only idempotent operations or those protected by an idempotency key. Do not blindly repeat video generation, billing, license mutation, or job submission when the first outcome is unknown.
- Use bounded exponential backoff with full jitter, attempt/duration budgets, and Retry-After support. Avoid synchronized storms and nested retry loops.
- Propagate cancellation and deadlines into HTTP requests, queues, polling, and child processes.

## Circuit breaker and bulkheads

- Choose breaker scope based on the failure mode. Track closed/open/half-open states and bound recovery probes.
- Count transient failures, not caller validation errors or expected business denials. Keep unrelated providers isolated.
- Limit concurrency, queue length, and per-provider resource use. Keep telemetry free of credentials and request secrets.
- Return typed, actionable errors to the UI. Distinguish retryable from non-retryable failures and surface uncertain upstream acceptance.

## Verification

Test timeout, cancellation, transient outage recovery, 429 with Retry-After, exhausted budget, non-retryable 4xx, circuit-open fast failure, successful half-open probe, concurrent calls, duplicate submission/idempotency, and shutdown. Use deterministic clocks/randomness or injected policies where possible.

Report retry counts, timing bounds, and idempotency assumptions. Retries alone do not prove resilience.
