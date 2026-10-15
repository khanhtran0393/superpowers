# AI Video Studio development rules

Inspect the actual repository, current branch, project instructions, and test commands before relying on assumptions. User and repository security requirements take precedence.

## Workflow and evidence

- For a small, unambiguous edit, make the smallest safe change. For a multi-file or architectural change, use brainstorming and writing-plans before implementation.
- For bugs, regressions, performance failures, or build errors, use systematic-debugging: reproduce first, gather logs at component boundaries, trace data flow, and state the evidence-backed root cause before editing.
- For behavior changes and bug fixes, write a focused regression test first where the test setup permits it. Run it and confirm it fails for the expected reason before implementing the smallest fix.
- Read full command output and exit codes. Before claiming a test, build, packaging step, or bug fix succeeded, run the relevant command in the current working tree. Report unrun checks and known failures explicitly.
- Review the final diff for unintended files, secrets, generated artifacts, path changes, and unrelated refactors. Never infer that a task is complete merely because files changed.
- Do not invent file names, APIs, tests, tool capabilities, task status, or execution results. Do not fabricate delegation when an agent capability is unavailable.

## Electron, IPC, and child processes

- Treat renderer input as untrusted. Expose narrow, allowlisted operations through preload/contextBridge; validate payload types, sizes, paths, and caller permissions in the main process.
- Do not expose arbitrary shell execution or unrestricted filesystem access to the renderer. Keep secrets and privileged credentials out of renderer code and client bundles.
- For FFmpeg, Whisper, Python/Uvicorn, and other child processes, define explicit ownership, cancellation, timeout, exit/error handling, bounded output, and shutdown behavior. On Windows, investigate Job Objects or another verified process-tree strategy when descendants can outlive the parent.
- Throttle or coalesce high-volume progress/log IPC messages without dropping terminal status, failures, or cancellation signals. Test backpressure and cleanup paths, not just the happy path.
- Prefer structured error events and correlation IDs. Do not swallow process errors or mark work successful before the child exits with an accepted status.

## Storage and cleanup

- Keep installation/runtime files, mutable user data, cache/temp files, and generated project output in explicitly defined locations. Resolve paths centrally and test spaces, Unicode, and Windows profile redirection.
- Make migrations idempotent and preserve existing user data. Upgrades and uninstallers must not delete user projects or user-created content as incidental cleanup.
- Before deletion, reject empty paths, filesystem roots, paths outside the allowed app-owned root, reparse-point/symlink escapes, and unexpected path aliases.
- Provide a dry-run or inventory step for broad cleanup where practical. Test interrupted migrations, locked files, permission failures, and low disk space.

## Security, licensing, and remote administration

- Keep license issuance and authoritative entitlements on the trusted backend. The desktop client must not be the sole authority for privileged license decisions.
- Authenticate and authorize every administrative action server-side. Use least privilege, auditable records, replay protection, and explicit command allowlists. Remote revoke/uninstall flows must not accept arbitrary shell commands or act as hidden arbitrary-execution mechanisms.
- Validate identity, tenant/device binding, expiry, signature, and freshness before executing a remote administrative action. Report outcomes and respect user-data retention policy.
- Do not log access tokens, signing keys, API keys, license secrets, customer media, or unnecessary personal data. Redact secrets in diagnostic bundles.
- Obfuscation is defense-in-depth, not a substitute for backend authorization, cryptographic verification, and safe client architecture.

## Cloud APIs and long-running work

- Set explicit deadlines. Retry only transient failures and idempotent operations; use bounded exponential backoff with jitter and respect provider rate limits such as HTTP 429 and Retry-After.
- Do not blindly retry non-idempotent jobs or billing/license mutations. Use idempotency keys or reconcile status before retrying uncertain operations.
- Scope circuit breakers to the affected provider/operation, bound queues and concurrency, and expose recovery state without leaking credentials.
- Propagate cancellation and shutdown; avoid unbounded logs, queues, and retry loops.

## Windows release verification

- Verify clean install, upgrade, launch, update, uninstall, and user-data preservation on a supported Windows environment. Include paths with spaces/Unicode and a non-admin user where applicable.
- Validate packaged files, native dependencies, architecture, signatures/hashes when configured, and runtime data paths. Keep secrets and user data out of installer artifacts.
- Investigate antivirus false positives through reproducible builds, signing, dependency provenance, and vendor submission channels; do not disguise behavior to evade security products.
- Separate static checks, unit tests, integration tests, actual Windows packaging, and manual checks in reports. Unit tests alone do not prove the installer works.

## Safety boundaries

Do not merge, publish, deploy, revoke customer licenses, uninstall customer software, delete user data, rotate production credentials, or run destructive cleanup without explicit authorization for that operation. Before risky operations, explain the target, impact, rollback plan, and verification.
