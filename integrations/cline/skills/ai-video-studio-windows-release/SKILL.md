---
name: ai-video-studio-windows-release
description: Build, package, sign, install, upgrade, uninstall, or investigate Windows-specific AI Video Studio distribution issues, missing dependencies, antivirus false positives, path handling, or release regressions.
---

# AI Video Studio: Windows release validation

Use for Electron packaging, installer scripts, native dependencies, bundled Python/FFmpeg/Whisper assets, signing, antivirus false positives, startup failures, or upgrade/uninstall testing.

## Inventory before editing

1. Read package manifests, build configuration, installer scripts, resource-copy rules, signing settings, and release workflows.
2. Identify supported Windows versions, architectures, prerequisites, and actual release commands. Do not invent a build command.
3. Trace every runtime dependency from source to packaged path. Verify casing, relative paths, current-working-directory assumptions, architecture, and spaces/Unicode in paths.
4. Separate developer-machine success from a clean packaged install.

## Verification layers

- Static: check manifest/configuration consistency, included resources, secret scanning, dependency provenance, and installer/uninstaller safety.
- Automated: run available unit, integration, lint, type-check, and build tests. Capture full output and exit codes.
- Packaging: create the distributable with the documented command; inspect contents, architecture, expected binaries, metadata, and signatures/hashes where configured.
- Windows runtime: launch from an installed location, run one representative media pipeline, cancel work, close/relaunch, upgrade from a supported prior version, and uninstall according to policy.
- Data safety: verify settings/projects/output are retained or removed only according to documented policy and cache cleanup remains within allowed roots.

## Antivirus false positives

- Establish a reproducible artifact and hash. Identify the exact file and detection, audit dependencies/build steps, and use code signing and the vendor's false-positive submission process.
- Do not rename, pack, encrypt, or disguise executable behavior to evade security products. Keep installer behavior minimal, deterministic, and documented.
- Security scans and runtime tests are distinct; neither replaces the other.

## Report

List what was verified in the current environment, what requires a clean Windows machine or signing credentials, artifact hash when available, and untested release risks. Source review or unit tests alone do not prove the installer works.
