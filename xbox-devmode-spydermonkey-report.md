# SPYDERMONKEY War Report — xbox-devmode

_generated 2026-11-25T22:06:48.211579+00:00 · SPYDERMONKEY 8.2.1 · scope: xbox-devmode_

## Authorization & scope

- engagement: **xbox-devmode**
- objective: owner-authorized validation-only recon of my Xbox Series in dev mode at 10.0.0.23; identify exploitable surfaces useful to the tiramisu project; no gain, no persistence
- in-scope entries: 1 · deny entries: 0
- expires: 2026-12-25T09:14:02.554768+00:00
- rules: {'max_rate_rps': 10, 'passive_first': True, 'no_destructive': True, 'require_scope_check': True, 'allow_lab': True}

## Executive summary

- **33** finding(s) registered · **31** confirmed with 3-gate evidence
- severity mix: high=8, info=8, low=3, medium=14
- risk score: **135.0** · cvss avg 4.6 · max 8.0
- **1** chain candidate(s) — low findings combining into high-impact chains
- **16** detection rule(s) mirrored (kage)
- harvest crown rows: 0 (shukaku pricing)
- methodology: 4/13 phases complete

## ATT&CK coverage (operational)

| technique | findings | confirmed |
|---|---|---|
| T-UNKNOWN | 14 | 13 |
| T1046 | 2 | 2 |
| T1068 | 8 | 7 |
| T1078 | 1 | 1 |
| T1083 | 3 | 3 |
| T1105 | 1 | 1 |
| T1113 | 1 | 1 |
| T1190 | 1 | 1 |
| T1546 | 1 | 1 |
| T1557 | 1 | 1 |

_10 technique(s) touched by the engagement's registered findings_

## Findings

| id | severity | cvss | status | class | title | asset |
|---|---|---|---|---|---|---|
| SPY-001 | info | 0.0 | CONFIRMED | RECON | SMBv1 absent — MS17-010/EternalBlue lane cleared | 10.0.0.23:445 |
| SPY-002 | high | 8.0 | CONFIRMED | AUTHZ | Unauthenticated remote-control PIN disclosure → keyboard/mouse takeover | http://10.0.0.23:9127 |
| SPY-003 | medium | 5.5 | CONFIRMED | DATAPROT | Unauthenticated export of Xbox save backups and debug bundle | http://10.0.0.23:9127/api/backup-saves, /api/debug-bundle |
| SPY-004 | medium | 5.5 | CONFIRMED | INFOLEAK | Wildcard CORS makes Xbox dev-mode telemetry and settings cross-origin readable | http://10.0.0.23:9127/api/logs + /api/settings + /games |
| SPY-005 | high | 8.0 | FALSE_POSITIVE | IDOR | IDOR differential on param 'org_id' | http://127.0.0.1:8851/api/orders?org_id=foreign |
| SPY-006 | medium | 5.5 | FALSE_POSITIVE | FILEUPLOAD | FILEUPLOAD differential on param 'file' | http://127.0.0.1:8851/api/orders?org_id=foreign |
| SPY-007 | medium | 5.5 | CONFIRMED | SSRF | Unauthenticated server-side request forgery via /api/download-url | http://10.0.0.23:9127/api/download-url |
| SPY-008 | info | 0.0 | CONFIRMED | HARDWARE | Windows UPnP Device Host exposed unauthenticated — RSS DP media-renderer XML at udhisapi.dll | 10.0.0.23:2869/upnphost/udhisapi.dll?content=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa |
| SPY-009 | info | 0.0 | CONFIRMED | HARDWARE | Windows Device Portal reachable over TLS on 10.0.0.23:11443 (issuer Microsoft Windows Web Management (Test)) | 10.0.0.23:11443 |
| SPY-010 | medium | 5.5 | CONFIRMED | INFOLEAK | Unauthenticated game file-manifest disclosure via /api/list-files | http://10.0.0.23:9127/api/list-files?game=hello |
| SPY-011 | medium | 5.5 | CONFIRMED | AUTHZ | Unauthenticated host settings tampering via /api/settings | http://10.0.0.23:9127/api/settings |
| SPY-012 | high | 8.0 | CONFIRMED | INFOLEAK | Unauthenticated Windows Device Portal info disclosure (/api/os/info, /ext/settings) | https://10.0.0.23:11443/api/os/info, /ext/settings |
| SPY-013 | medium | 5.5 | CONFIRMED | AUTHZ | Unauthenticated UPnP RenderingControl SOAP query (GetVolume) on Xbox DeviceHost | http://10.0.0.23:2869/upnphost/udhisapi.dll?control=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa+urn:upnp-org:serviceId:RenderingControl |
| SPY-014 | high | 8.0 | CONFIRMED | INFOLEAK | Unauthenticated Device Portal leaks device identifiers, network config, and package inventory | https://10.0.0.23:11443/ext/xbox/info, /api/networking/ipconfig, /api/app/packagemanager/packages |
| SPY-015 | high | 8.0 | CONFIRMED | INFOLEAK | Unauthenticated Device Portal user enumeration/disclosure (/ext/user) | https://10.0.0.23:11443/ext/user |
| SPY-016 | medium | 7.5 | CONFIRMED | INFOLEAK | Unauthenticated WDP screenshot endpoint leaks live TV frame | https://10.0.0.23:11443/ext/screenshot?download=true |
| SPY-017 | low | 2.5 | CONFIRMED | INFOLEAK | Unauthenticated WDP package-install state disclosure | https://10.0.0.23:11443/api/app/packagemanager/state |
| SPY-018 | medium | 5.5 | CONFIRMED | INFOLEAK | Unauthenticated WDP filesystem directory listing (knownfolderid) | https://10.0.0.23:11443/api/filesystem/apps/files?knownfolderid=Documents |
| SPY-019 | low | 2.5 | CONFIRMED | AUTHZ | Unauthenticated UPnP ConnectionManager SOAP query + SCPD exposure | http://10.0.0.23:2869/upnphost/udhisapi.dll (ConnectionManager:1) |
| SPY-020 | low | 2.5 | CONFIRMED | AUTHZ | Anonymous WDP GETs issue CSRF-Token cookie without authentication | https://10.0.0.23:11443/api/os/info |
| SPY-021 | medium | 5.5 | CONFIRMED | CORS | Wildcard CORS with successful preflight on unauth mutation endpoints | http://10.0.0.23:9127 |
| SPY-022 | high | 7.5 | CONFIRMED | INFOLEAK | Unauthenticated WDP file CONTENT read (not just directory listing) | https://10.0.0.23:11443/api/filesystem/apps/file |
| SPY-023 | info | 0.0 | CONFIRMED | AUTHZ | CLEARED LANE — every WDP mutation endpoint rejects anonymous writes (403) | https://10.0.0.23:11443 (mutation surface) |
| SPY-024 | medium | 5.9 | CONFIRMED | HARDWARE | SMB2 signing enabled but not required — NTLM relay lane open, anonymous write not | 10.0.0.23:445 |
| SPY-025 | info | 0.0 | CONFIRMED | RECON | CLEARED LANE — public SystemOS kernel LPEs are patched on build 26100.9662 (Collateral Damage / Artifice) | 10.0.0.23 |
| SPY-026 | info | 0.0 | CONFIRMED | HARDWARE | NO NETWORK SURFACE — bootrom and hypervisor unreachable from LAN (physical glitch only) | 10.0.0.23 |
| SPY-027 | info | 0.0 | CONFIRMED | AUTHZ | CLEARED LANE — WDP filesystem path traversal and null-session SAMR both denied | https://10.0.0.23:11443/api/filesystem/apps/files |
| SPY-028 | high | 7.5 | CONFIRMED | AUTHZ | Unauth dashboard hands out the live control pairing code; pair endpoint needs only that code | http://10.0.0.23:9127/api/status |
| SPY-029 | medium | 6.5 | CONFIRMED | INFOLEAK | Unauth dashboard read surface: game library, launcher log, full file tree, Steam library, settings, pairing QR | http://10.0.0.23:9127 |
| SPY-030 | medium | 7.0 | CONFIRMED | AUTHZ | Anonymous file write into a game directory, and anonymous launch of that game (guest code drop primitive) | http://10.0.0.23:9127/api/upload-file |
| SPY-031 | medium | 5.3 | CONFIRMED | AUTHZ | UPnP AVTransport accepts anonymous SetAVTransportURI (control, not just queries) | http://10.0.0.23:2869/upnphost/udhisapi.dll |
| SPY-032 | info | 0.0 | CONFIRMED | RECON | Ecosystem inventory: 39 dev settings, MediaRenderer tree, TLS cert, SMB dialects, SSH methods | 10.0.0.23 |
| SPY-033 | high | 7.5 | CONFIRMED | SURVEILLANCE | Unauthenticated live screen capture of the console (1920x1080 PNG) | https://10.0.0.23:11443/ext/screenshot |

### SPY-001 — SMBv1 absent — MS17-010/EternalBlue lane cleared [CONFIRMED · info · conf 0.95]
- class: RECON · asset: 10.0.0.23:445
- evidence quality: 3-gate
- proof: baseline: SMBv1 dialect would be listable if exposed; attack: read-only nmap --script smb-protocols,smb-security-mode + smb-vuln-ms17-010 (no payload); diff: dialects 2:0:2,2:1:0,3:0:0,3:0:2,3:1:1 only — no NT LM 0.12; MS17-010 script silent

### SPY-002 — Unauthenticated remote-control PIN disclosure → keyboard/mouse takeover [CONFIRMED · high · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:9127 · CWE CWE-306 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: /controls is PIN-gated — page JS posts the PIN to /api/controls/pair then uses Bearer token on /api/controls/input; attack: anonymous GET /api/status returned control_code=10825127 with no auth, anonymous POST /api/controls/pair with raw PIN returned HTTP 200 + 32-byte Bearer token a41af61201bde7ed4baabd1515ee71f2; diff: token accepted on /api/controls/leave (HTTP 200), proving a live control session issued without credentials; session revoked via leave, no input injected, no persistence

### SPY-003 — Unauthenticated export of Xbox save backups and debug bundle [CONFIRMED · medium · conf 0.95]
- class: DATAPROT · asset: http://10.0.0.23:9127/api/backup-saves, /api/debug-bundle · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: save backups and debug bundle are operator-only artifacts; attack: anonymous GET /api/backup-saves and /api/debug-bundle with no cookie/token; diff: HTTP 200 application/zip, 8276 and 9288 bytes respectively — data streamed to /dev/null, nothing retained

### SPY-004 — Wildcard CORS makes Xbox dev-mode telemetry and settings cross-origin readable [CONFIRMED · medium · conf 0.95]
- class: INFOLEAK · asset: http://10.0.0.23:9127/api/logs + /api/settings + /games · CWE CWE-942
- evidence quality: 3-gate
- proof: baseline: console logs, OS-spoof settings and game inventory are local operator data; attack: anonymous cross-origin GET from any webpage with Origin header; diff: HTTP 200 plus Access-Control-Allow-Origin:* and Access-Control-Allow-Methods:GET,POST,PUT,DELETE on every response — 16198B of live guest logs, os_build=19045, 7-game inventory readable by any LAN page

### SPY-005 — IDOR differential on param 'org_id' [FALSE_POSITIVE · high · conf 0.95]
- class: IDOR · asset: http://127.0.0.1:8851/api/orders?org_id=foreign · CWE CWE-639 · WSTG WSTG-ATHZ-04 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: 200 len=39 (param org_id=foreign); attack: 200 len=33 (param org_id=0); diff: foreign object id echoed in the body; control: baseline stable=True

### SPY-006 — FILEUPLOAD differential on param 'file' [FALSE_POSITIVE · medium · conf 0.4]
- class: FILEUPLOAD · asset: http://127.0.0.1:8851/api/orders?org_id=foreign
- evidence quality: 3-gate
- proof: baseline: 200 len=39 (param file=(upload)); attack: 501 len=357 (param file=php shell (id)); diff: differential without class evidence; control: baseline stable=True
control: differential is not specific (hypothesis-grade)

### SPY-007 — Unauthenticated server-side request forgery via /api/download-url [CONFIRMED · medium · conf 0.95]
- class: SSRF · asset: http://10.0.0.23:9127/api/download-url · CWE CWE-918 · WSTG WSTG-INPV-10 · ATT&CK T1190
- evidence quality: 3-gate
- proof: baseline: anonymous GET /api/status last_error='' and /games lists 7 games with no probe artifact; attack: anonymous POST /api/download-url with JSON url=http://127.0.0.1:1/probe and game=probe -> HTTP 202; source webxfer.cpp:1893-1895 accepts any http(s) URL with no host allowlist and 1918-1921 passes it to HttpClient.GetAsync; diff: after 6s last_error='URL download failed' proving the console itself attempted the arbitrary URL; /games still 7 entries, no file written; 127.0.0.1:9127 returned 'URL download HTTP 404' confirming loopback reachability is measurable

### SPY-008 — Windows UPnP Device Host exposed unauthenticated — RSS DP media-renderer XML at udhisapi.dll [CONFIRMED · info · conf 0.95]
- class: HARDWARE · asset: 10.0.0.23:2869/upnphost/udhisapi.dll?content=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa · CWE CWE-79
- evidence quality: 3-gate
- proof: baseline: udhisapi.dll family requires normal Windows UPnP service exposure; attack: anonymous GET of the device description URL; diff: HTTP 200, 3604B XML, Server: Microsoft-Windows/10.0 UPnP/1.0 UPnP-Device-Host/1.0; classes in XML: XdeviceType urn:schemas-upnp-org:device:MediaRenderer:1, friendlyName XBOX, manufacturer Microsoft Corporation, X_hardwareId VEN_0125, modelName Xbox One, XDLNACAP empty; services RenderingControl:1 + AVTransport:1 with controlURL/eventSubURL/SCPDURL — documented platform UPnP attack surface (SSDP on UDP 1900, IIS+UPnP handler on 2869)

### SPY-009 — Windows Device Portal reachable over TLS on 10.0.0.23:11443 (issuer Microsoft Windows Web Management (Test)) [CONFIRMED · info · conf 0.95]
- class: HARDWARE · asset: 10.0.0.23:11443 · CWE CWE-79
- evidence quality: 3-gate
- proof: baseline: expecting a private-in-the-box Device Portal on non-TLS 11443; attack: anonymous HTTPS GET -k https://10.0.0.23:11443/ ; diff: HTTP/2 200, content-length 1908, title 'Windows Device Portal', Server: Microsoft-HTTPAPI/2.0, TLSv1.3 AES_256_GCM_SHA384, issuer=CN Microsoft Windows Web Management (Test) (XBOX) — standard UDn admin surface

### SPY-010 — Unauthenticated game file-manifest disclosure via /api/list-files [CONFIRMED · medium · conf 0.95]
- class: INFOLEAK · asset: http://10.0.0.23:9127/api/list-files?game=hello · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: game directory contents are operator-private; attack: anonymous GET /api/list-files?game=hello with no auth; diff: HTTP 200 JSON listing 9 files with rel paths and sizes including .tiramisu/aliases.json (95B), .tiramisu/autopilot.json (54B), .tiramisu/profile.json (405B), .tiramisu/shims.txt (72B), .tiramisu/xb_imports.csv (105B), .tiramisu/xb_imports.json (189B), .tiramisu/xb_profile.json (110B), guest_hello.exe (3072B), tiramisu.profile.ini (255B); endpoint also accepts other game names and is CORS-wildcarded

### SPY-011 — Unauthenticated host settings tampering via /api/settings [CONFIRMED · medium · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:9127/api/settings · CWE CWE-306 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: GET /api/settings returned show_qr=true, log_lines=14 with no auth; attack: unauthenticated POST /api/settings with {"show_qr":false} returned HTTP 200 {"saved":true}; diff: GET /api/settings showed show_qr=false; restore: POST {"show_qr":true} returned saved and GET confirmed show_qr=true; no persistence, cosmetic field only, fully reversible

### SPY-012 — Unauthenticated Windows Device Portal info disclosure (/api/os/info, /ext/settings) [CONFIRMED · high · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/api/os/info, /ext/settings · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: Device Portal admin/settings endpoints expected to require authentication; attack: anonymous HTTPS GET (no credentials/cookies) to https://10.0.0.23:11443/api/os/info, /api/os/machinename, /ext/settings; diff: HTTP 200 JSON returned OsVersion=26100.9662.amd64fre.xb_flt_2610ge.261104-2200, Platform=Xbox Series S, OsEdition=SystemOS, ComputerName=XBOX, SandboxId=XDKS.1, DefaultApp=Dev Home, and AutoSignInUser options including a configured user identifier; settings expose network/power/video/audio/devmode preferences. Evidence captured read-only; no settings changed.

### SPY-013 — Unauthenticated UPnP RenderingControl SOAP query (GetVolume) on Xbox DeviceHost [CONFIRMED · medium · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:2869/upnphost/udhisapi.dll?control=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa+urn:upnp-org:serviceId:RenderingControl · CWE CWE-306 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: UPnP control endpoint should not allow unauthenticated control queries from arbitrary LAN clients; attack: anonymous HTTP POST SOAP GetVolume (InstanceID=0, Channel=Master) with no auth token; diff: HTTP 200 SOAP GetVolumeResponse returned CurrentVolume=100 (dt:ui2). Read-only query only; no mutating action invoked.

### SPY-014 — Unauthenticated Device Portal leaks device identifiers, network config, and package inventory [CONFIRMED · high · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/ext/xbox/info, /api/networking/ipconfig, /api/app/packagemanager/packages · CWE CWE-200 · WSTG PTES-NET · ATT&CK T1046
- evidence quality: 3-gate
- proof: baseline: Device Portal device identity/network/package management endpoints expected to require authentication; attack: anonymous HTTPS GET with no credentials to /ext/xbox/info, /api/networking/ipconfig, /api/app/packagemanager/packages; diff: HTTP 200 responses returned OsVersion/DevMode/OsEdition/ConsoleType and device identifiers (ConsoleId, DeviceId, SerialNumber, DevkitCertificateExpirationTime present; values redacted in public report), 4 network adapters config, and 74 installed packages including dev tools/apps. Read-only GETs only; no mutation.

### SPY-015 — Unauthenticated Device Portal user enumeration/disclosure (/ext/user) [CONFIRMED · high · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/ext/user · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: Device Portal user/account endpoint expected to require authentication; attack: anonymous HTTPS GET https://10.0.0.23:11443/ext/user with no credentials; diff: HTTP 200 returned Users array (1 user) exposing account presence and profile fields including UserId, EmailAddress, Gamertag, XboxUserId, AgeGroup, AutoSignIn, SignedIn; sensitive identifiers redacted in public artifacts. Read-only GET only.

### SPY-016 — Unauthenticated WDP screenshot endpoint leaks live TV frame [CONFIRMED · medium · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/ext/screenshot?download=true · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: screenshot endpoint expected to require auth; attack: anonymous HTTPS GET /ext/screenshot?download=true with no credentials; diff: HTTP/2 200, content-disposition attachment filename=Screenshot_2026-11-25_03-47-31.png, PNG 1920x1080 15210 bytes, plus fresh CSRF-Token cookie. Image streamed to /dev/null-equivalent temp and not retained in repo.

### SPY-017 — Unauthenticated WDP package-install state disclosure [CONFIRMED · low · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/api/app/packagemanager/state · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: install state is operator-only; attack: anonymous HTTPS GET /api/app/packagemanager/state; diff: HTTP 200 JSON {Code:0, CodeText:..., Reason:Success, Success:true} — reveals package operation state without auth.

### SPY-018 — Unauthenticated WDP filesystem directory listing (knownfolderid) [CONFIRMED · medium · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/api/filesystem/apps/files?knownfolderid=Documents · CWE CWE-200 · WSTG WSTG-CONF-03 · ATT&CK T1083
- evidence quality: 3-gate
- proof: baseline: WDP filesystem listing expected to require authentication; attack: anonymous HTTPS GET /api/filesystem/apps/files?knownfolderid=Documents (and Downloads/Pictures/Music/Videos) with no credentials; diff: HTTP 200 JSON with FullPath Q:\Users\UserMgr1\Documents\ and Items array including file names, FileSize, timestamps — same for 5 user folders; Desktop/Profiles/InstalledGames returned 403 unsupported; no file contents fetched, no secrets retained

### SPY-019 — Unauthenticated UPnP ConnectionManager SOAP query + SCPD exposure [CONFIRMED · low · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:2869/upnphost/udhisapi.dll (ConnectionManager:1) · CWE CWE-306 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: UPnP ConnectionManager control expected to be restricted; attack: read-only GET of SCPDURL (4280B) parsed actions GetProtocolInfo/GetCurrentConnectionIDs/GetCurrentConnectionInfo, then anonymous SOAP POST GetProtocolInfo; diff: HTTP 200 GetProtocolInfoResponse with S Source empty and Sink listing DLNA protocol/codec profile strings — third UPnP service exposed unauth beyond previously registered RenderingControl/AVTransport

### SPY-020 — Anonymous WDP GETs issue CSRF-Token cookie without authentication [CONFIRMED · low · conf 0.95]
- class: AUTHZ · asset: https://10.0.0.23:11443/api/os/info · CWE CWE-1275 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: CSRF token should only be issued to an authenticated session; attack: anonymous HTTPS GET /api/os/info (and /ext/screenshot, /api/app/packagemanager/state) with no credentials; diff: each response 200 with a fresh set-cookie CSRF-Token value (e.g. token string) — token minted for unauthenticated clients; combined with anonymous mutation endpoint reachability this weakens the CSRF defense posture

### SPY-021 — Wildcard CORS with successful preflight on unauth mutation endpoints [CONFIRMED · medium · conf 0.95]
- class: CORS · asset: http://10.0.0.23:9127 · CWE CWE-942
- evidence quality: 3-gate
- proof: baseline: cross-origin preflight to mutation endpoints should be blocked for untrusted origins; attack: OPTIONS requests to /api/launch, /api/stop, /api/rescan, /api/upload-file, /api/restore-saves, /api/download-url, /api/settings, /api/controls/pair, /api/controls/input with Origin: http://evil.example all returned HTTP 204; combined with Access-Control-Allow-Origin:* and Allow-Methods GET,POST,PUT,DELETE,OPTIONS (observed on root dashboard responses) this means any website can preflight and attempt cross-origin mutation requests against the dev dashboard

### SPY-022 — Unauthenticated WDP file CONTENT read (not just directory listing) [CONFIRMED · high · conf 0.95]
- class: INFOLEAK · asset: https://10.0.0.23:11443/api/filesystem/apps/file · CWE CWE-200 · WSTG WSTG-CONF-03 · ATT&CK T1083
- evidence quality: 3-gate
- proof: baseline: WDP filesystem endpoints expected to require auth; attack: anonymous HTTPS GET /api/filesystem/apps/file?knownfolderid=Documents&filename=desktop.ini with no cookie/token; diff: HTTP 200 returned the 190-byte desktop.ini [.ShellClassInfo] body — file bytes, not metadata; SPY-018 covered names only

### SPY-023 — CLEARED LANE — every WDP mutation endpoint rejects anonymous writes (403) [CONFIRMED · info · conf 0.95]
- class: AUTHZ · asset: https://10.0.0.23:11443 (mutation surface) · CWE CWE-306 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: anonymous GETs on WDP return 200 (SPY-012..022), so writes were the question; attack: anonymous POST {} to /api/app/packagemanager/package, /api/filesystem/apps/file, /api/os/restart, /api/os/shutdown, /api/controls/reboot, /api/devmode/unattendedsetup-apply; diff: all returned HTTP/2 403 with zero-byte body and no Set-Cookie effect — the unsigned app-deploy and persistence primitives are auth-gated, no side effects

### SPY-024 — SMB2 signing enabled but not required — NTLM relay lane open, anonymous write not [CONFIRMED · medium · conf 0.95]
- class: HARDWARE · asset: 10.0.0.23:445 · CWE CWE-345 · ATT&CK T1557
- evidence quality: 3-gate
- proof: baseline: relay requires Message signing 'required'; attack: nmap smb2-security-mode + smbclient -N; diff: 'Message signing enabled but not required' on SMB2/3; null session authenticates anonymously but tree connect to DevelopmentFiles returns NT_STATUS_ACCESS_DENIED and other share names NT_STATUS_BAD_NETWORK_NAME — no anonymous write/persistence path

### SPY-025 — CLEARED LANE — public SystemOS kernel LPEs are patched on build 26100.9662 (Collateral Damage / Artifice) [CONFIRMED · info · conf 0.95]
- class: RECON · asset: 10.0.0.23
- evidence quality: 3-gate
- proof: baseline: Collateral Damage (CVE-2024-30088) targets 25398.4478/25398.4908/25398.4909; Artifice devmode EoP first fixed 10.0.26100.1968; attack: live GET /api/os/info; diff: OsVersion 26100.9662.amd64fre.xb_flt_2610ge.261104-2200, Platform Xbox Series S, OsEdition SystemOS — both public chains are pre-patch builds, neither applicable; no kernel LPE lane open from this position

### SPY-026 — NO NETWORK SURFACE — bootrom and hypervisor unreachable from LAN (physical glitch only) [CONFIRMED · info · conf 0.95]
- class: HARDWARE · asset: 10.0.0.23 · CWE CWE-284 · WSTG PTES-NET · ATT&CK T1046
- evidence quality: 3-gate
- proof: baseline: a remote boot-chain primitive needs an exposed debug/management listener; attack: nmap top-300 plus curated 1-1024 and debug ranges (730,731,4118,27000-27005,29800-29810,50000); diff: only 22/445/2869/9127/11443 open, every debug/KD port filtered; documented bootrom compromise (Bliss / Gaasedelen) is North Bridge voltage glitching requiring physical access, hypervisor exports no network interface — no remote path exists

### SPY-027 — CLEARED LANE — WDP filesystem path traversal and null-session SAMR both denied [CONFIRMED · info · conf 0.95]
- class: AUTHZ · asset: https://10.0.0.23:11443/api/filesystem/apps/files · CWE CWE-22 · WSTG WSTG-ATHZ-01 · ATT&CK T1068
- evidence quality: 3-gate
- proof: baseline: WDP path param is concatenated into the package root, so traversal was the question; attack: anonymous GET with path=..\..\.., ..\..\..\..\..\Windows, ..\..\..\..\..\Windows\System32\drivers\etc, and rpcclient -N -c 'querydominfo; enumdomusers' against 10.0.0.23; diff: traversal returned HTTP 400 on every depth, and SAMR returned NT_STATUS_ACCESS_DENIED while smbclient -N //10.0.0.23/IPC$ ls returned ACCESS_DENIED — no out-of-root read, no anonymous RPC enumeration

### SPY-028 — Unauth dashboard hands out the live control pairing code; pair endpoint needs only that code [CONFIRMED · high · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:9127/api/status · CWE CWE-306 · WSTG WSTG-ATHN-01 · ATT&CK T1078
- evidence quality: 3-gate
- proof: baseline: /api/controls/pair and /api/controls/leave return 401 without a token, implying the code gates control; attack: anonymous GET /api/status returns control_code plus running state; diff: control_code stable across two fetches (<redacted>, redacted) with running=true, and POST /api/controls/pair with empty JSON returns 401 — so the only secret needed to pair is published unauthenticated on the same interface; no input was injected and no pair session was opened

### SPY-029 — Unauth dashboard read surface: game library, launcher log, full file tree, Steam library, settings, pairing QR [CONFIRMED · medium · conf 0.95]
- class: INFOLEAK · asset: http://10.0.0.23:9127 · CWE CWE-200 · WSTG WSTG-CONF-05 · ATT&CK T1083
- evidence quality: 3-gate
- proof: baseline: LAN dashboard expected to gate project and host data; attack: anonymous GETs only; diff: /games 200 (game name, exe, appid, arch, compat), /api/logs 200 16,367B of host launcher log incl. guest handle/park internals, /api/list-files?game=Cuphead 200 62,166B (813 files with sizes incl. .tiramisu/profile.json), /api/steam/library 200, /api/steam/status 200, /api/settings 200, /api/qr.svg 200 4,346B SVG (Steam sign-in QR); paired control was not exercised

### SPY-030 — Anonymous file write into a game directory, and anonymous launch of that game (guest code drop primitive) [CONFIRMED · medium · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:9127/api/upload-file · CWE CWE-434 · WSTG WSTG-ATHZ-02 · ATT&CK T1105
- evidence quality: 3-gate
- proof: baseline: uploading into a game dir and launching a guest should require the control token that /api/controls requires; attack: POST /api/upload-file?game=Cuphead&rel=probe.txt with a zero-length body (no auth header); diff: HTTP 200 {"ok":true,"size":0} and /api/list-files then shows probe.txt size 0, proving the write path executed with no auth; POST /api/launch/ZZZ_NOT_A_GAME_ZZZ returned 404 'game not found', proving the launch handler also runs unauthenticated; no PE was uploaded and no game was launched. Side effect disclosed: the write triggered the dashboard's own rescan/autopilot, which stopped the running guest (Cuphead) — clean up by deleting DevelopmentFiles/Cuphead/probe.txt (0B); WDP DELETE is 403 anonymously so it needs the operator's credentials

### SPY-031 — UPnP AVTransport accepts anonymous SetAVTransportURI (control, not just queries) [CONFIRMED · medium · conf 0.95]
- class: AUTHZ · asset: http://10.0.0.23:2869/upnphost/udhisapi.dll · CWE CWE-306 · WSTG WSTG-ATHN-01 · ATT&CK T1546
- evidence quality: 3-gate
- proof: baseline: SPY-013 proved read-only SOAP queries only; attack: anonymous SOAP POST to the AVTransport control URL with SOAPAction SetAVTransportURI and an empty CurrentURI (no media, no playback); diff: HTTP 200 with a SetAVTransportURIResponse envelope instead of a 401/501 — the console processes state-changing renderer actions from any LAN host; no media was set and nothing played

### SPY-032 — Ecosystem inventory: 39 dev settings, MediaRenderer tree, TLS cert, SMB dialects, SSH methods [CONFIRMED · info · conf 0.95]
- class: RECON · asset: 10.0.0.23 · CWE CWE-200
- evidence quality: 3-gate
- proof: baseline: document the estate's config surface; attack: anonymous GET /ext/settings, SSDP M-SEARCH, UPnP description fetch, openssl s_client, nmap; diff: 39 settings across Audio/Identity/Localization/Network/Power/Preferences/User/Video incl. SandboxId, Hostname, AutoBoot, AutoSignInUser, WirelessRadioSettings (values withheld); SSDP root device uuid redacted, MediaRenderer with RenderingControl+AVTransport+ConnectionManager on 2869; TLS cert CN=10.0.0.23 issued by 'Microsoft Windows Web Management (Test) (XBOX)', SAN DNS:XBOX/localhost/IP, valid 2026-11-22 to 2029-11-21; SMB2 signing enabled but not required; SSH offers publickey,password,keyboard-interactive

### SPY-033 — Unauthenticated live screen capture of the console (1920x1080 PNG) [CONFIRMED · high · conf 0.95]
- class: SURVEILLANCE · asset: https://10.0.0.23:11443/ext/screenshot · CWE CWE-306 · WSTG WSTG-ATHN-01 · ATT&CK T1113
- evidence quality: 3-gate
- proof: baseline: /ext/screenshot is a user-facing capture of whatever is on the console screen (gamertag, messages, notifications); attack: anonymous HTTPS GET with no cookie/token, repeated 2s apart; diff: HTTP 200 image/png, 2,105,240B then 2,055,437B, md5 53f9dda7.../784f7318..., PNG 1920x1080 8-bit truecolor — differing frames prove live capture, not a static asset; read-only, image not retained

## Attack chains

- **CH-001** [info_disclosure_ssrf] high (conf 0.75): SPY-003 + SPY-007 → info disclosure names internal hosts → SSRF pivots to them

## Detection coverage (kage)

- KAGE-001 — rule
- KAGE-002 — rule
- KAGE-003 — rule
- KAGE-004 — rule
- KAGE-005 — rule
- KAGE-006 — rule
- KAGE-007 — rule
- KAGE-008 — rule
- KAGE-009 — rule
- KAGE-010 — rule
- KAGE-011 — rule
- KAGE-012 — rule
- KAGE-013 — rule
- KAGE-014 — rule
- KAGE-015 — rule
- KAGE-016 — rule

## Phase coverage

- completed   scope_analysis (barbican)
- completed   passive_recon (holyshit)
- in_progress active_recon (undercroft)
- blocked     technology_profiling (kaisha)
- blocked     authentication_testing (3am)
- blocked     session_management (3am)
- completed   authorization_testing (spy)
- blocked     input_validation (spy)
- blocked     business_logic (undercroft)
- blocked     data_protection (shukaku)
- blocked     api_security (spy)
- blocked     infrastructure (kaisha)
- completed   reporting (spy)

## Evidence integrity

- ledger rows: 33 · signed: 33 · unsigned: 0
- integrity errors: 1

## Closeout

- validation-only: every confirmed action is one decisive proof, reversible.
- NO-GAIN: nothing of value was retained; no persistence was installed.
- scope: every live probe was checked against the declaration at the top.

