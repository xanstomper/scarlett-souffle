# SPYDERMONKEY War Report — xbox-devmode

_generated 2026-11-25T10:59:43.974727+00:00 · SPYDERMONKEY 8.2.1 · scope: xbox-devmode_

## Authorization & scope

- engagement: **xbox-devmode**
- objective: owner-authorized validation-only recon of my Xbox Series in dev mode at 10.0.0.23; identify exploitable surfaces useful to the tiramisu project; no gain, no persistence
- in-scope entries: 1 · deny entries: 0
- expires: 2026-12-25T09:14:02.554768+00:00
- rules: {'max_rate_rps': 10, 'passive_first': True, 'no_destructive': True, 'require_scope_check': True, 'allow_lab': True}

## Executive summary

- **15** finding(s) registered · **13** confirmed with 3-gate evidence
- severity mix: high=5, info=3, medium=7
- risk score: **65.0** · cvss avg 5.23 · max 8.0
- **0** chain candidate(s) — low findings combining into high-impact chains
- **0** detection rule(s) mirrored (kage)
- harvest crown rows: 0 (shukaku pricing)
- methodology: 4/13 phases complete

## ATT&CK coverage (operational)

| technique | findings | confirmed |
|---|---|---|
| T-UNKNOWN | 9 | 8 |
| T1046 | 1 | 1 |
| T1068 | 4 | 3 |
| T1190 | 1 | 1 |

_4 technique(s) touched by the engagement's registered findings_

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

- ledger rows: 15 · signed: 15 · unsigned: 0
- integrity errors: 0

## Closeout

- validation-only: every confirmed action is one decisive proof, reversible.
- NO-GAIN: nothing of value was retained; no persistence was installed.
- scope: every live probe was checked against the declaration at the top.

