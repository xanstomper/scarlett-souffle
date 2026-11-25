# UWP / Sideloading / Porting Checklist (Dev Community)

Evidence-grounded by Scarlett Soufflé observations (Tiramisu dashboard, WDP, UPnP). Use for defensive hardening and authorized lab testing.

## Build & packaging
- [ ] Treat `.tiramisu` manifests/profiles/shims/import mappings as sensitive build artifacts.
- [ ] Validate app manifests, capabilities, and signing before sideload.
- [ ] Keep test/dev packages separate from personal accounts and retail environments.
- [ ] Remove debug endpoints/log verbosity from release builds.

## Dashboard / management surface
- [ ] Require auth+CSRF for all mutation endpoints (`/api/settings`, config, launch, upload, restore, delete, stop/rescan, controls).
- [ ] Never expose control PIN/token in unauth status responses.
- [ ] Disable CORS wildcard; set strict origin allowlist.
- [ ] Bind management UI to localhost or trusted VLAN; firewall 9127/11443/2869/1900.

## File handling & config
- [ ] Canonicalize paths and reject traversal/dot-segments (already seen in webxfer) but still enforce auth.
- [ ] Treat args/config as untrusted; allowlist flags, length-limit, and avoid shell passthrough.
- [ ] Validate upload content types/sizes; isolate extraction dirs; scan archives.
- [ ] Protect save/debug exports; require auth and redact PII/secrets.

## Network & protocol
- [ ] SSRF defenses: scheme allowlist, DNS/IP validation, block loopback/private/link-local/metadata, no redirect-to-internal.
- [ ] Disable UPnP/SSDP when unused; if needed, restrict to trusted LAN and patch firmware.
- [ ] Restrict WDP anonymous endpoints; monitor for unauth info disclosure.

## Porting/runtime trust boundaries
- [ ] Review host->guest command-line, registry hive, and file path handoff.
- [ ] Confirm guest shim blocks shell/process escape expectations; test only in owned lab.
- [ ] Log and alert on pairing, settings changes, uploads, launches, restores, deletes.

## Jailbreak/exploit research ethics
- [ ] Owned hardware only; isolated lab network.
- [ ] Reversible proofs, no persistence, no data exfiltration.
- [ ] Distinguish confirmed auth/misconfig vulns from unproven kernel/hypervisor claims.
- [ ] Coordinate disclosure; redact identifiers.
