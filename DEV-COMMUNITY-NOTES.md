# Dev Community Notes — Xbox Dev Mode / UWP / Porting / Research

> Evidence-grounded notes from the Scarlett Soufflé campaign (declared owner estate, validation-only). No jailbreak/bootrom/hypervisor escape was proven. Confirmed items are in the ledger/report.

## What was proven

- **Unauth control-plane takeover (SPY-002, HIGH 8.0):** dev dashboard dashboard leaked `control_code` in `/api/status`; `/api/controls/pair` issued a Bearer token without auth. Token revoked after proof. No input injected.
- **Unauth SSRF (SPY-007):** `/api/download-url` accepted arbitrary http(s) URL; console fetched it; measurable `last_error` diff. No file written.
- **Unauth config mutation (SPY-011):** `/api/settings` POST changed `show_qr` reversibly. Source shows no auth on many mutation endpoints.
- **Unauth info leaks:** file manifests (SPY-010), save/debug exports (SPY-003), telemetry/CORS (SPY-004), Device Portal OS/settings (SPY-012), UPnP metadata/SCPDs (SPY-008), UPnP read-only SOAP queries (SPY-013).
- **Platform fingerprint:** Xbox Series S/SystemOS build `26100.9662.amd64fre.xb_flt_2610ge.261104-2200`, Sandbox `XDKS.1`, Dev Home default, WDP TLS 1.3, UPnP MediaRenderer XBOX.

## Attack chains (dev-kit risk model)

1. **LAN foothold → console control:** unauth status leaks PIN → pair → control token (SPY-002). If input injection were authorized, attacker could drive UI. *Not executed beyond pair/revoke.*
2. **LAN foothold → content/config tampering:** unauth settings mutation proven (SPY-011); source-reviewed unauth launch/upload/restore/delete/config endpoints present. *Destructive endpoints not actively tested.*
3. **LAN foothold → recon:** Device Portal leaks OS/sandbox/user presence (SPY-012); dev dashboard leaks game inventory, file layout, logs, steam state, QR URL (SPY-004/010). 
4. **SSRF primitive:** console can be induced to fetch arbitrary URLs (SPY-007). Loopback/internal probing gave limited results; still a primitive for metadata/internal reachability research in lab.
5. **UPnP control surface:** SCPDs advertise SetAVTransportURI/Play/SetVolume/SetMute etc.; read-only GetVolume/GetMute/GetTransportInfo succeeded unauth (SPY-013). Mutating actions not invoked.

## UWP / porting notes

- dev dashboard games list exposes per-title `arch`, `compat`, `exe`, `appid`, `args`, `input`. Observed compat labels: `x64 D3D11 Ready`, `x64 Windows Ready`, `x86 32-bit (JIT)`.
- Per-game `.dev dashboard` manifests seen in file listings: `aliases.json`, `autopilot.json`, `profile.json`, `shims.txt`, `xb_imports.csv/json`, `xb_profile.json`, `native-crt` dir. Useful for understanding packaging/shim layers; also sensitive recon.
- Dev Mode/UWP deployment is managed by WDP and dev settings. Anonymous exposure of these planes is a deployment hygiene issue.

## Jailbreak / exploit research (responsible framing)

- **Proven:** auth bypasses, info leaks, SSRF, unauth control query, missing auth on mutation endpoints. These are real vulns.
- **Not proven:** kernel escape, hypervisor breakout, bootrom exploit, retail-to-dev conversion, unsigned code execution outside intended dev workflows, persistence.
- **Research path (lab only):** reproduce dev dashboard/webxfer and UPnP stacks in an isolated lab VM/device you own; fuzz SOAP/XML handlers, upload parsers, zip extraction, URL fetchers, and control APIs with authorization. Do not weaponize; report responsibly.
- **Do not confuse "dev mode" with "jailbreak".** Dev Mode is a supported developer feature; exposures here are misconfigurations/missing auth in tooling and management surfaces.

## Hardening checklist for devs

- Do not expose 9127/11443/2869/1900 to untrusted LAN/Wi-Fi; firewall them.
- Add auth + CSRF to all dashboard mutation endpoints; remove PIN leak from status.
- Disable CORS wildcard or restrict origins.
- Disable UPnP/SSDP if unused.
- Treat debug/save bundle exports as sensitive; require auth and audit contents.
- Keep dev kits on isolated VLANs; avoid signing in personal accounts on shared dev kits.
