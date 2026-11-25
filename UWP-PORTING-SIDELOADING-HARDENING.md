# UWP / Porting / Sideloading / Dev-Mode Hardening Notes

Evidence-grounded guidance for dev community. Not legal advice; not a jailbreak guide.

## Observed context (this estate)

- Xbox Series S/SystemOS dev kit, Dev Mode "Universal Windows App Devkit", Sandbox `XDKS.1`, DefaultApp Dev Home (WDP anonymous exposure, redacted).
- dev dashboard dashboard exposed game inventory, compat labels (x64 D3D11 Ready, x64 Windows Ready, x86 32-bit JIT), per-game `.dev dashboard` manifests/profiles/shims/import mappings.
- Missing auth on dev dashboard management endpoints enabled info disclosure, SSRF, settings mutation, and control pairing proof.

## UWP/dev-mode risks

- **Management plane exposure:** WDP and dev dashboards are admin surfaces. Anonymous reads leak OS build, package inventory, device/user identifiers. Keep on isolated network, VPN, or localhost tunnel.
- **Sideload/package workflow tamper:** Unauth upload/restore/config/launch endpoints can compromise dev content integrity. Require strong auth and signed packages/artifacts.
- **Credential/token hygiene:** Debug/save bundles may contain sensitive data; treat as secrets. Redact before sharing.
- **CORS wildcard:** Browser-origin attacks become practical on LAN. Disable `*` and require CSRF tokens.

## Porting/shim layer risks

- `.dev dashboard` profiles/shims/import mappings are useful for compatibility but reveal internals. Protect them as build artifacts.
- Command-line args/config files are trust boundaries. Sanitize and allowlist; do not pass raw dashboard input to runtime command lines without policy.
- File upload/extract paths must be canonicalized and auth-gated even when path sanitization exists.

## Sideloading / "jailbreak" research boundaries

- **Proven here:** missing auth, info leaks, SSRF, control pairing, config mutation. 
- **Not proven here:** hypervisor/bootrom/kernel escape, persistent unsigned retail jailbreak, bypass of platform security boundaries.
- Responsible research: use owned hardware, isolated lab, reversible tests, no persistence/gain, coordinated disclosure. Do not publish weaponized exploits or raw device identifiers.

## Practical checklist

- [ ] Bind 9127/11443/2869/1900 to trusted interfaces only.
- [ ] Add auth+CSRF to every mutation endpoint.
- [ ] Remove secrets/PINs from status endpoints.
- [ ] Restrict SSRF destinations; deny loopback/RFC1918/link-local/metadata by default.
- [ ] Audit exported bundles for PII/secrets.
- [ ] Separate dev kit accounts from personal accounts.
- [ ] Log and alert on control pairing, config changes, uploads, restores, launches.
