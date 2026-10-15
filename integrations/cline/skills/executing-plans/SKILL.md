---
name: executing-plans
description: Execute a written implementation plan in the current Cline session when implementation work has multiple verifiable steps and no explicitly available native subagent workflow is being used.
---

# Executing Plans (Cline-compatible)

Use this Skill when a written plan exists and the user has authorized implementation. It adapts Superpowers' execution discipline to Cline without assuming that a subagent, Task tool, reviewer agent, or worktree API exists.

## Preconditions

1. Read the plan and any referenced specification well enough to understand scope, acceptance criteria, and constraints.
2. Inspect the current Git branch, working-tree diff, project instructions, and existing test/build commands.
3. Check whether the workspace is isolated. Do not start risky multi-file work on the default branch if an isolated branch/worktree is available and appropriate.
4. If a plan has a critical gap or unsafe assumption, record it and resolve it from user instructions and repository evidence. Ask only if proceeding would otherwise be a guess or cross a security/destructive boundary.

## Execute one task at a time

For each unchecked plan task:

1. Define the expected observable behavior in working notes.
2. Inspect the files and tests that own that behavior; follow repository patterns.
3. Write the smallest focused test first where practical. Run it and verify it fails for the expected reason.
4. Implement the minimum change that satisfies the test. Do not bundle unrelated refactors or speculative abstractions.
5. Run the focused test, then the relevant broader test suite. Read complete output and exit code.
6. Review the diff for correctness, security, compatibility, and accidental scope expansion.
7. Update the plan checkbox only after evidence supports completion. Keep a brief progress ledger for plans that may outlive the current context.

If a focused test cannot be written or run, state why and use the strongest available alternative. Do not claim an unrun test passed.

## Tool and delegation limits

- Use only tools and agent capabilities actually exposed by the active Cline setup.
- If native subagents are available and authorized, delegate only independent, bounded tasks with explicit inputs and review the resulting diff. Otherwise execute inline and review your changes in a separate pass.
- Never claim an independent review occurred unless another reviewer actually performed it.
- Never invent command output, code changes, test results, or commits.
- Do not commit, push, open a pull request, merge, publish, deploy, or change production data unless the user explicitly authorized that side effect.

## Stop conditions

Stop before irreversible/destructive operations, security-sensitive changes, or side effects outside the local workspace that are not covered by the user's authorization. Explain the exact target and impact and request authorization when required.

## Completion report

Run verification commands fresh after the work. Report changed files and behavior, commands and exit codes, relevant test counts, checks not run, known risks, and exact branch/commit state. A plan is not complete because every checkbox is checked; implementation, test evidence, and diff review must agree.
