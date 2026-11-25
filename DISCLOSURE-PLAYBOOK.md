# Disclosure Playbook (Dev Kits / Tooling / UWP)

Grounded in Scarlett Soufflé observations. Use only for systems you own or are authorized to test.

## 1. Triage & scope
- Identify asset owner, firmware/build, exposure (LAN/WAN), and whether device is dev kit or retail.
- Capture evidence read-only first: service banners, anonymous endpoints, CORS/auth behavior.
- Redact serials, ConsoleId, DeviceId, Devkit cert expiry, emails, gamertags, XboxUserId, tokens.

## 2. Evidence standard (3-gate)
- **Baseline:** normal/expected behavior.
- **Attack:** minimal, authorized, reversible probe.
- **Diff:** measurable response/status/body/config change.
- Record timestamps, request/response headers, and cleanup.

## 3. Prioritize by impact
- **Critical/High:** unauth control pairing, unauth mutation (launch/upload/delete/restore/config), anonymous device/user identity leaks, SSRF with internal reach.
- **Medium:** unauth info leaks, CORS *, read-only control queries, file manifests.
- **Info:** banner exposure, benign metadata, negative clearances (e.g., SMBv1 absent).

## 4. Do-not-cross lines
- No persistence, no credential brute force, no third-party pivot, no exfiltration, no destructive payloads.
- No mutating UPnP SOAP actions, no control input injection, no launch/delete/restore/upload without explicit per-action authorization and rollback.
- Do not publish weaponized PoCs or raw identifiers.

## 5. Report package
- Affected endpoint/component and version/build.
- Minimal repro and rollback.
- Impact and attack chain.
- Suggested fix: auth+CSRF, bind localhost/trusted VLAN, remove secrets from status, SSRF allowlist, disable UPnP/WDP exposure.
- Attach sanitized logs/screenshots.

## 6. Dev-community remediation checklist
- [ ] AuthN/AuthZ on every management endpoint.
- [ ] CSRF tokens on browser-facing mutations.
- [ ] No PIN/token/secret in unauth status.
- [ ] CORS allowlist, not `*`.
- [ ] SSRF egress allowlist; block loopback/RFC1918/link-local/metadata as appropriate.
- [ ] Audit debug/save bundle contents for PII/secrets.
- [ ] Network isolation for dev kits.
