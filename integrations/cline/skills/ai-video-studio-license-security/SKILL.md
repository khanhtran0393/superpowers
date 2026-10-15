---
name: ai-video-studio-license-security
description: Review or change AI Video Studio licensing, entitlement validation, backend authorization, secrets, IP-protection packaging, customer-device revocation, remote administration, or uninstall controls.
---

# AI Video Studio: license and security review

Use when touching license issuance/validation, subscription state, device binding, backend endpoints, API secrets, IPC authorization, code obfuscation, remote revocation, or customer-device administration. Trace the actual authorization path before proposing changes.

## Map the trust boundary

1. Identify the authoritative backend, database records, signed claims, device identity, local cache, offline grace period, and every place a license decision can be made.
2. Trace UI/API entry points to data mutations or privileged local actions. Identify authentication, authorization, tenant/device binding, expiry, replay protection, and audit logging.
3. Search for credentials in renderer bundles, installer assets, logs, test fixtures, crash reports, and generated artifacts.
4. Treat obfuscation as reverse-engineering friction, not as authoritative client-side entitlement enforcement.

## Security requirements

- Keep privileged entitlement decisions and signing keys server-side. Verify signed claims with a trusted public key and define expiry, key rotation, clock skew, and offline behavior.
- Enforce authorization server-side for every admin endpoint. Never trust a client-supplied user/device/tenant ID alone.
- Do not add arbitrary command execution, hidden remote-control channels, bypasses, or undocumented persistence. Prefer a narrow, versioned command schema with allowlisted actions.
- For remote revoke/uninstall, require authenticated/authorized policy, bind the command to the correct account/device, reject stale/replayed commands, log outcomes, and respect user/data-retention policy. Never interpret a server response as an arbitrary shell command.
- Do not expose tokens, API keys, signing secrets, customer media, or unnecessary personal data in logs or diagnostics. Redact before export.
- Use established cryptographic libraries; do not invent cryptographic primitives.
- A license revocation must not silently delete user-created files. Uninstall must be a narrowly defined, authorized action with clear policy and result reporting.

## Tests

Cover valid/invalid/expired/revoked licenses, wrong-device/tenant claims, invalid signatures, key rotation, clock skew, offline grace, backend timeout, stale/replayed admin commands, insufficient roles, missing installer files, and uninstaller failure. Verify denial paths fail closed without leaking secrets or deleting user data.

Classify findings by severity and concrete evidence. Do not claim security based only on obfuscation or a happy-path test.
