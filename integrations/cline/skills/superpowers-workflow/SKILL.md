---
name: superpowers-workflow
description: Choose and sequence the relevant Superpowers development Skills for non-trivial code changes, debugging, refactors, reviews, or verification in a Cline workspace.
---

# Superpowers workflow for Cline

Use this as a router for software-engineering work. Prefer the smallest workflow that provides reliable evidence; do not turn a one-line, unambiguous edit into a large ceremony.

## Choose the workflow

- New behavior, feature, or architectural change: use /brainstorming when intent or trade-offs need exploration, then /writing-plans for multi-step work.
- Executing a written plan: use /executing-plans and track task completion against observable evidence.
- Bug, flaky test, performance issue, build failure, or unexpected behavior: start with /systematic-debugging; reproduce and locate root cause before changing code.
- Feature, fix, refactor, or behavior change: use /test-driven-development where the test setup permits a test-first cycle.
- Before reporting completion or preparing an integration: use /verification-before-completion and inspect the full diff.
- Electron IPC, process lifecycle, storage, license/security, network resilience, or Windows packaging: also use the matching /ai-video-studio-* Skill.
- If Cline has no native independent reviewer/subagent in this session, perform a distinct self-review pass and state that it was self-review, not an independent review.

## Evidence rules

- A status report is not evidence. Read actual command output and exit code.
- Distinguish checks that passed, failed, were skipped, and could not run.
- Test negative paths and cleanup, not only success paths.
- Do not broaden scope without recording why. Preserve user data and avoid unrelated formatting changes.
