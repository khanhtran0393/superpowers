---
name: ai-video-studio-regression-review
description: Review AI Video Studio changes for plan compliance, regressions, user-data safety, security boundaries, missing tests, process cleanup, and unverified completion claims.
---

# AI Video Studio: regression and change review

Use after a fix, refactor, feature, or security-sensitive change, and before reporting completion.

## Review in separate passes

1. **Scope** — compare the diff with request/plan. Identify unrelated files, generated artifacts, dependency changes, or missing migration/docs.
2. **Correctness** — inspect the full changed code and callers/callees. Trace malformed input, concurrency, cancellation, retries, partial failure, and error paths.
3. **Security and data** — review trust boundaries, secrets, path traversal, authorization, logs, broad deletes, and upgrade/uninstall retention.
4. **Reliability** — inspect resource ownership, timers/listeners/IPC subscriptions, child processes, queue bounds, timeouts, and shutdown.
5. **Tests** — map each acceptance criterion to a test or explicit manual check. Source-text assertions and mocks of the behavior under test are weak evidence.
6. **Verification** — run appropriate tests/builds, read complete output, and record exit codes. Separate unrun checks, environment limitations, and pre-existing failures.

## Finding format

For each issue, state severity (critical/high/medium/low), exact file/line or function when available, failure scenario, impact, and concrete fix. Distinguish proven defects from risks needing reproduction.

If Cline has no separate review agent in the current session, make a distinct self-review pass and say it was self-review, not independent review.

## Approval standard

Do not approve based on naming, comments, claimed intent, or a green narrow test alone. Critical security issues, data-loss paths, broken acceptance criteria, and failing relevant tests block completion. Do not expand scope to fix unrelated findings without recording the decision.
