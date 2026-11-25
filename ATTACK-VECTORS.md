# Scarlett Soufflé — Attack Vectors & Dev-Community Notes

**Estate:** `10.0.0.23` (declared owner-authorized validation-only scope, `xbox-devmode`)  
**Identity observed (read-only):** MAC OUI `E4:2A:AC:D9:5F:1F` = Microsoft; UPnP `friendlyName XBOX`, `modelName Xbox One`, `manufacturer Microsoft Corporation`; Device Portal `/api/os/info` reports `Platform=Xbox Series S`, `OsEdition=SystemOS`, `OsVersion=26100.9662.amd64fre.xb_flt_2610ge.261104-2200`, `SandboxId=XDKS.1`.  
**Rules:** validation-only, NO-GAIN, no persistence, no third-party contact, no credential guessing/bruteforce, no destructive payloads. State-changing tests only when reversible and restored.

## Confirmed findings (ledger-backed, 3-gate)

| ID | Sev | Class | Asset | Summary |
|---|---:|---|---|---|
| SPY-001 | info | RECON | 10.0.0.23:445 | SMBv1 absent; MS17-010 not detected (negative clearance). |
| SPY-002 | **high 8.0** | AUTHZ | http://10.0.0.23:9127 | Unauth `/api/status` leaks `control_code` PIN; unauth `/api/controls/pair` returns Bearer token; `/api/controls/leave` revoked it. No input injected. |
| SPY-003 | medium 5.5 | DATAPROT | 9127 `/api/backup-saves`, `/api/debug-bundle` | Unauth ZIP exports returned 200; streamed to /dev/null, not retained. |
| SPY-004 | medium 5.5 | INFOLEAK | 9127 logs/settings/games/steam status | Unauth telemetry/settings/game inventory; CORS `*`, methods GET/POST/PUT/DELETE. |
| SPY-005/006 | — | — | 127.0.0.1:8851 | FALSE_POSITIVE dojo artifacts quarantined; not estate. |
| SPY-007 | medium 5.5 | SSRF | 9127 `/api/download-url` | Unauth POST arbitrary http(s) URL accepted (202); console fetch caused measurable `last_error` diff; no file written. |
| SPY-008 | info | HARDWARE | 2869/1900 UPnP | UPnP DeviceHost XML exposed unauth; SSDP 1900/udp open; MediaRenderer XBOX metadata. |
| SPY-009 | info | HARDWARE | 11443 | Windows Device Portal TLSv1.3 reachable; self-signed WDP cert issuer observed. |
| SPY-010 | medium 5.5 | INFOLEAK | 9127 `/api/list-files?game=hello` | Unauth file manifest disclosure with sizes including `.tiramisu/*` profiles/shims/imports and exe names. |
| SPY-011 | medium 5.5 | AUTHZ | 9127 `/api/settings` | Unauth POST changed `show_qr` true->false->true; reversible proof. |
| SPY-012 | **high** | INFOLEAK | 11443 `/api/os/info`, `/ext/settings` | Unauth Device Portal leaks OS build/platform/sandbox/dev settings and configured user identifier presence. Read-only. |

## Attack surface map (observed)

### Tiramisu dashboard — http://10.0.0.23:9127
**Observed unauth read:** `/`, `/games`, `/api/status`, `/api/settings`, `/api/logs`, `/api/steam/status`, `/api/steam/library`, `/api/steam/qr.svg`, `/api/qr.svg`, `/api/list-files?game=<n>`, `/api/cover/<name>`, `/controls`, `/api/backup-saves`, `/api/debug-bundle`, `/progress/<id>`.

**Observed unauth mutation/control (code-reviewed; not all actively tested):** `/api/controls/pair`, `/api/controls/input`, `/api/controls/leave`, `/api/settings` POST (CONFIRMED), `/api/stop`, `/api/rescan`, `/api/game/<n>` DELETE, `/api/delete/<n>`, `/api/config/<n>`, `/api/launch/<n>`, `/api/upload-file`, `/upload/<name>.zip`, `/api/upload-complete`, `/api/download-url` POST (SSRF CONFIRMED), `/api/restore-saves`, `/api/cover/<n>` PUT, `/api/steam/qr|refresh|signout|download/<appid>`.

**Impact model:** LAN attacker or any LAN web origin (CORS *) can read telemetry, game inventory, settings, save/debug exports, file manifests, and obtain control PIN. With state-changing endpoints unauth, worst case on a dev kit is game/config tampering, stop/rescan, upload/restore of content, and remote control pairing — all high impact for dev workflows. SPY-002 proves control session issuance.

### UPnP / DLNA — 1900/udp + 2869/tcp
- SSDP 1900/udp open; device description at `udhisapi.dll?content=uuid:...` returns MediaRenderer XBOX metadata.
- SCPDs exposed: AVTransport (SetAVTransportURI, Play, Pause, Seek, Stop, Next, Previous, SetNextAVTransportURI) and RenderingControl (SetVolume, SetMute, presets). 
- Control endpoints return `Allow: POST, M-POST` (GET 405). **Not invoked** in this pass; SOAP action invocation is active testing and requires explicit authorization.

**Dev/jailbreak relevance:** UPnP/DLNA control surfaces are common local attack surface; AVTransport URI handling has historically been a parser/SSRF/file-fetch risk class on media renderers. Only description exposure is confirmed here.

### Windows Device Portal — https://10.0.0.23:11443 (TLS 1.3)
- Anonymous 200: `/`, `/api/os/info`, `/api/os/machinename`, `/ext/settings`.
- 404/unknown from anonymous: `/api`, `/debug`, `/deploy`, `/header`, `/info`, `/resources`, `/ext/app`, `/ext/xboxlive`.
- Leaks OS build/platform/sandbox/dev settings and user identifier presence. Auth-gated areas not brute-forced.

**Dev relevance:** WDP is the official dev management plane; anonymous info leaks reduce attacker uncertainty and aid targeted phishing/social engineering *outside scope* — we do not act on that. For devs, disable/limit portal exposure on untrusted LANs.

### SMB/SSH
- 22/tcp OpenSSH for Windows 9.5, password+keyboard-interactive+publickey; modern algos. No weak crypto observed. No creds.
- 445/tcp SMB2/3 only, no SMBv1, MS17-010 not detected. Anonymous login allowed but no shares; SAMR/SRVSV C denied.

## UWP / sideloading / porting / dev-mode notes (evidence-grounded)

- **Dev Mode container reality:** Observed platform is Xbox Series S/SystemOS with WDP and dev settings (`SandboxId=XDKS.1`, `DefaultApp=Dev Home`). Dev Mode enables deployment/debug workflows; it also increases management-plane exposure when LAN-reachable.
- **Tiramisu packaging signal:** Games list shows x64/x86 UWP/Win32-compat entries (`compat` labels include "x64 D3D11 Ready", "x64 Windows Ready", "x86 32-bit (JIT)"), per-game `.tiramisu` manifests/profiles/shims/import mappings, and `tiramisu.profile.ini`. This confirms a translation/shim layer, not a native Xbox retail entitlement path.
- **Sideloading risk class:** Unauthenticated upload/restore/config/launch endpoints on 9127 (code-reviewed) mean any LAN actor could alter dev content if exercised. We did **not** exercise destructive/upload/launch endpoints. Devs should bind dashboard to localhost or require auth/token.
- **Porting/research value:** File manifests and compat metadata are useful for debugging packaging; same data is also recon for attackers. Treat dev dashboards as sensitive admin interfaces.
- **Jailbreak/escalation claim discipline:** No kernel/host escape/jailbreak was proven. SPY-002 is a control-plane auth bypass; SPY-007 is SSRF; SPY-011 is unauth settings mutation. These are serious dev-kit exposures, not proven bootrom/hypervisor escapes.

## High-value next tests (require explicit per-action authorization)

1. **UPnP SOAP action test (benign):** Send a harmless `GetTransportInfo`/`GetVolume` SOAP request; confirm unauth response. Avoid SetAVTransportURI/SetVolume/Play until separately authorized.
2. **Unauth `/api/rescan` or `/api/stop` reversible proof:** low-risk but state-changing; confirm and restore.
3. **SSRF internal-port map expansion:** already did small set; can expand carefully with closed-port targets only (no writes).
4. **Device Portal auth boundary map:** enumerate which `/ext/*` and `/api/*` are anonymous vs 401/403 without brute force.

## Evidence files
- `xbox-devmode-spydermonkey-report.md` — regenerated war report.
- `RESEARCH-UPDATE-2026-11-25.md` — live observation log.
- `FINDINGS.md`, `EVIDENCE.md` — earlier archive.

## Defender/dev mitigations
- Bind Tiramisu/dashboard to loopback or require strong auth + CSRF on all mutation endpoints.
- Disable UPnP/SSDP where not needed; firewall 2869/1900/9127/11443 from untrusted LANs.
- Treat Device Portal as admin plane; do not expose dev kits on shared networks.
- Rotate/revoke any dev credentials exposed in logs/settings; audit save/debug bundle contents before sharing.
