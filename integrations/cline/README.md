# Superpowers + Cline integration for AI Video Studio

This integration exposes Cline-native, project-scoped Skills and rules for using Superpowers workflows while maintaining AI Video Studio. It does not modify application source code, add an MCP server, or grant Cline new operating-system permissions.

## Included

- Core Superpowers Skills: brainstorming, writing-plans, systematic-debugging, test-driven-development, verification-before-completion, using-git-worktrees, and finishing-a-development-branch.
- A Cline-compatible inline executing-plans Skill that does not assume a Superpowers Task or subagent tool exists.
- Domain Skills for Electron/IPC and child-process safety, storage/runtime separation, license/security, cloud resilience, Windows release validation, and regression review.
- A project rule with cross-cutting safety and verification requirements.

Skills install under .cline/skills/ and the project rule under .clinerules/. Cline's current Skills documentation: https://docs.cline.bot/customization/skills.

## Install on Windows

From the Superpowers checkout, run in PowerShell:

    .\integrations\cline\install.ps1 -TargetPath "C:\path\to\AI Video Studio"

Replace the target with the actual AI Video Studio repository root. The directory must already exist. Open that workspace in Cline, enable Skills in Cline settings, and inspect the installed Skills before use. Review and commit the resulting .cline/skills and .clinerules files in the application repository when appropriate.

The installer skips existing destinations by default. To update existing integration files, use:

    .\integrations\cline\install.ps1 -TargetPath "C:\path\to\AI Video Studio" -Force

Force mode backs up each overwritten destination under .cline/integration-backups/<timestamp>/ before replacing it. Review backups before removing them.

## Validate

Run from the Superpowers repository root:

    python .\integrations\cline\validate.py

This validates Skill metadata, directory/name consistency, the description length limit, installer configuration, and required files. It does not prove Cline loaded the Skills, that the application test suite passes, or that a Windows package works.

## Workflow

For a multi-module change, use brainstorming and writing-plans, execute via /executing-plans, use systematic-debugging for failures, and run verification-before-completion before reporting success. Invoke the matching ai-video-studio-* Skill for affected subsystems.

The domain Skills are guidance, not claims about the current app implementation. The agent must inspect the actual source, callers, tests, and build scripts before proposing edits.

## Update and uninstall

Without Force, rerunning the installer only adds missing destinations; it preserves local changes but does not update already installed files. Use Force intentionally to update the bundled integration; overwritten files are backed up first.

To uninstall manually, remove only Skills installed by this integration and .clinerules/ai-video-studio-development.md if they have not been customized. Do not delete application data, user projects, credentials, or unrelated Cline configuration.

## Limitations

- This is a Cline Skills/rules integration, not an MCP server or an application runtime feature shipped to customers.
- It does not change application code, run builds, modify package scripts, configure credentials, alter license policy, or delete user data.
- Review actions with destructive, privileged, licensing, publishing, deployment, or production impact.
