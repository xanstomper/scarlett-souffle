# Dev Kit Hardening Baseline (Xbox Dev Mode / UWP Tooling)

Actionable baseline for devs operating Xbox dev kits and UWP/porting tooling on shared networks.

## Network exposure
- Isolate dev kits on a trusted VLAN; block 9127/tcp, 11443/tcp, 2869/tcp, 1900/udp from untrusted LAN/Wi-Fi.
- Prefer localhost tunnel/VPN for remote management. Do not expose WDP or dev dashboard dashboard broadly.

## Authentication & browser controls
- Require auth on every read/write management endpoint; remove PIN/secret fields from unauth status APIs.
- Add CSRF protection for all browser-facing POST/PUT/DELETE.
- Replace CORS `*` with strict allowlist.

## Data minimization & secrecy
- Treat debug/save bundles, logs, package inventories, and manifests as sensitive.
- Redact ConsoleId/DeviceId/SerialNumber/cert expiry, emails, gamertags, XboxUserId/UserId before sharing.
- Avoid personal account sign-in on shared dev kits.

## File/config/launch integrity
- Enforce auth on config/upload/restore/delete/launch/stop/rescan endpoints.
- Allowlist command-line args; treat dashboard/config files as untrusted input.
- Canonicalize paths, validate archive contents, and isolate extraction targets.

## Protocol hardening
- Disable UPnP/SSDP if unused; patch and restrict if required.
- SSRF defenses: allowlist schemes/destinations, deny loopback/private/link-local/metadata as appropriate.
- Monitor for unexpected pairing, settings changes, uploads, restores, launches.

## Evidence from this campaign
- Confirmed: unauth control pairing (SPY-002), SSRF (SPY-007), settings mutation (SPY-011), file manifest leak (SPY-010), WDP info/user/device/package leaks (SPY-012/014/015), UPnP read-only SOAP query (SPY-013).
- Not proven: kernel/hypervisor/bootrom jailbreak or persistent unsigned escape.
