---
name: ai-video-studio-electron-runtime
description: Review or change AI Video Studio Electron IPC, preload/contextBridge, FFmpeg, Whisper, Python/Uvicorn or other child-process lifecycle, progress reporting, throttling, cancellation, shutdown, and Windows process-tree cleanup.
---

# AI Video Studio: Electron, IPC, and process runtime

Use whenever a change touches the Electron main/renderer boundary, IPC throughput, child processes, native executables, transcription/rendering jobs, app shutdown, or orphan-process risk. Inspect the implementation before assuming a file name or existing protection.

## Investigation

1. Map renderer/UI -> preload/contextBridge -> main-process IPC handler -> service/queue -> child process -> progress/error event -> UI.
2. Identify trust boundaries, process ownership, and job states such as queued, running, cancelled, succeeded, and failed.
3. Inspect tests, package scripts, and platform abstractions. Capture a baseline where feasible.
4. For performance reports, measure event rate, payload size, queue growth, and UI responsiveness instead of guessing.

## IPC controls

- Expose narrow, allowlisted methods. Keep arbitrary shell execution, filesystem access, and unrestricted generic IPC unavailable to the renderer.
- Validate payload type, schema, length, path, and operation permission in the main process, even if the renderer validates too.
- Avoid accepting raw channel names or command strings from untrusted renderer content.
- For progress/log floods, coalesce or throttle repeated progress messages and bound queues/buffers. Preserve terminal completion, failure, cancellation, and actionable diagnostics.
- Avoid expensive synchronous work in the main process and avoid forwarding every child stdout/stderr chunk.

## Child-process lifetime

- Track each spawned process with a stable job ID and explicit owner. Handle spawn errors, error/exit/close events, timeout, cancellation, app shutdown, and partial startup.
- Do not report success until the child exits with an accepted code and required outputs are validated.
- Define descendant behavior. On Windows, evaluate Job Objects with kill-on-job-close or a verified equivalent; ensure children cannot escape the intended lifetime.
- Bound stdout/stderr memory and logs. Close handles/listeners and make cleanup idempotent.
- Avoid fire-and-forget launches unless persistence after restart is deliberately designed with durable job state and recovery semantics.

## Required tests

Where possible, test malformed IPC payloads, unauthorized calls, high-frequency progress, bounded queues, spawn failure, non-zero exit, cancellation races, timeout, shutdown, orphan descendants, and repeated cleanup. Prefer condition-based waiting to arbitrary sleeps unless testing an actual timer interval.

Distinguish Windows integration tests from mocks. Never claim Job Object behavior was verified from a non-Windows mock alone. Report exact cases, test commands, exit codes, and outstanding Windows-only checks.
