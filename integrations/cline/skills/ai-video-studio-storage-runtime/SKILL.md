---
name: ai-video-studio-storage-runtime
description: Analyze or modify AI Video Studio path resolution, install/runtime separation, user data, cache/temp files, generated media, migrations, disk cleanup, or uninstall/upgrade retention.
---

# AI Video Studio: storage and runtime separation

Use when changing file paths, writable data locations, install layout, portable mode, generated videos, caches, temporary assets, migration, disk cleanup, or uninstallation. Inspect the current path helpers and callers first; never infer paths from names alone.

## Establish the contract

1. Inventory path producers/consumers: installation directory, runtime resources, user configuration, project inputs/outputs, cache, temporary render/transcription assets, logs, and backups.
2. Identify locations that must be read-only, writable, per-user, portable, shared, or disposable. Find every fallback and environment variable.
3. Trace initialization so paths do not depend on an unavailable runtime, current working directory, or a location that changes between development and packaged builds.
4. Record legacy paths and migration rules before changing a shared helper.

## Safe path design

- Centralize canonical path resolution and use a consistent contract in Electron and Python services where applicable.
- Test development mode, packaged Windows mode, paths with spaces/Unicode, redirected user profiles, missing directories, access denied, read-only install folders, and low disk space.
- Before writes/deletes, reject empty values, filesystem roots, paths outside an allowed app-owned root, unexpected path aliases, and symlink/reparse-point traversal.
- Keep user projects and generated outputs distinct from disposable cache/temp locations.
- Migrations must be idempotent and crash-recoverable. Preserve source data until destination verification succeeds; do not delete the old copy first.
- Avoid destructive startup cleanup. Prefer preview/inventory, explicit retention policy, age/size bounds, and a report of removed bytes/files.

## Verification

Test fresh install, legacy-layout upgrade, interrupted migration, duplicate invocation, locked files, permission failures, and rollback. Verify cleanup removes only expected app-owned paths and user-created media/configuration remains intact.

Uninstall logic must distinguish application binaries from user data and document the policy. Never use broad recursive deletion with an empty or weakly normalized path. Obtain explicit authorization before cleanup against real user data.
