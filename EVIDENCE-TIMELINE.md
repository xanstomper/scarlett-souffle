# Evidence Timeline / Change Log

## Ledger findings (redacted export)

- 2026-11-25T09:25:45.854474+00:00 SPY-001 [CONFIRMED/info] SMBv1 absent — MS17-010/EternalBlue lane cleared @ 10.0.0.23:445
- 2026-11-25T09:34:58.150751+00:00 SPY-002 [CONFIRMED/high] Unauthenticated remote-control PIN disclosure → keyboard/mouse takeover @ http://10.0.0.23:9127
- 2026-11-25T09:34:58.152872+00:00 SPY-003 [CONFIRMED/medium] Unauthenticated export of Xbox save backups and debug bundle @ http://10.0.0.23:9127/api/backup-saves, /api/debug-bundle
- 2026-11-25T09:35:09.515177+00:00 SPY-004 [CONFIRMED/medium] Wildcard CORS makes Xbox dev-mode telemetry and settings cross-origin readable @ http://10.0.0.23:9127/api/logs + /api/settings + /games
- 2026-11-25T09:37:10.344582+00:00 SPY-005 [FALSE_POSITIVE/high] IDOR differential on param 'org_id' @ http://127.0.0.1:8851/api/orders?org_id=foreign
- 2026-11-25T09:37:10.346261+00:00 SPY-006 [FALSE_POSITIVE/medium] FILEUPLOAD differential on param 'file' @ http://127.0.0.1:8851/api/orders?org_id=foreign
- 2026-11-25T09:47:35.439622+00:00 SPY-007 [CONFIRMED/medium] Unauthenticated server-side request forgery via /api/download-url @ http://10.0.0.23:9127/api/download-url
- 2026-11-25T09:54:17.224091+00:00 SPY-008 [CONFIRMED/info] Windows UPnP Device Host exposed unauthenticated — RSS DP media-renderer XML at udhisapi.dll @ 10.0.0.23:2869/upnphost/udhisapi.dll?content=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa
- 2026-11-25T10:00:22.947798+00:00 SPY-009 [CONFIRMED/info] Windows Device Portal reachable over TLS on 10.0.0.23:11443 (issuer Microsoft Windows Web Management (Test)) @ 10.0.0.23:11443
- 2026-11-25T10:44:32.230782+00:00 SPY-010 [CONFIRMED/medium] Unauthenticated game file-manifest disclosure via /api/list-files @ http://10.0.0.23:9127/api/list-files?game=hello
- 2026-11-25T10:49:25.202517+00:00 SPY-011 [CONFIRMED/medium] Unauthenticated host settings tampering via /api/settings @ http://10.0.0.23:9127/api/settings
- 2026-11-25T10:52:26.260656+00:00 SPY-012 [CONFIRMED/high] Unauthenticated Windows Device Portal info disclosure (/api/os/info, /ext/settings) @ https://10.0.0.23:11443/api/os/info, /ext/settings
- 2026-11-25T10:53:59.640202+00:00 SPY-013 [CONFIRMED/medium] Unauthenticated UPnP RenderingControl SOAP query (GetVolume) on Xbox DeviceHost @ http://10.0.0.23:2869/upnphost/udhisapi.dll?control=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa+urn:upnp-org:serviceId:RenderingControl
- 2026-11-25T10:55:49.764538+00:00 SPY-014 [CONFIRMED/high] Unauthenticated Device Portal leaks device identifiers, network config, and package inventory @ https://10.0.0.23:11443/ext/xbox/info, /api/networking/ipconfig, /api/app/packagemanager/packages
- 2026-11-25T10:59:17.750586+00:00 SPY-015 [CONFIRMED/high] Unauthenticated Device Portal user enumeration/disclosure (/ext/user) @ https://10.0.0.23:11443/ext/user

## Repo commits (recent)

- 2026-11-25 06:20:50 -0500 2bc1c42 Add glossary for dev-mode/UWP/porting/security terms
- 2026-11-25 06:19:58 -0500 4809647 Add red-team/dev-team handoff summary
- 2026-11-25 06:19:16 -0500 2703b75 Add evidence-grounded dev kit network segmentation baseline
- 2026-11-25 06:18:18 -0500 684ab6d Add evidence integrity checklist for dev-community reports
- 2026-11-25 06:17:33 -0500 7903cc2 Add redacted WDP software/package surface summary
- 2026-11-25 06:16:05 -0500 f89e604 Add quickstart owner audit and report workflow
- 2026-11-25 06:15:06 -0500 4633cb0 Add redacted response key/type snapshots for anonymous endpoints
- 2026-11-25 06:13:52 -0500 a8fc891 Index dev-community FAQ in README
- 2026-11-25 06:13:02 -0500 7111cc6 Add dev-community FAQ mapping myths to observed evidence
- 2026-11-25 06:12:12 -0500 f76b734 Add read-only self-audit script and observed HTTP matrix
- 2026-11-25 06:11:19 -0500 fd94662 Add prioritized P0-P3 remediation memo
- 2026-11-25 06:10:23 -0500 3a54ffa Add WDP field dictionary and consolidated report pack index
- 2026-11-25 06:09:25 -0500 69549d4 Add host module static review (steam_client/ui/swapchain)
- 2026-11-25 06:08:27 -0500 5eb46e2 Add known/unproven hypotheses register for lab follow-up
- 2026-11-25 06:07:19 -0500 38b0f1a Add dev-kit hardening baseline and safe lab scenarios
- 2026-11-25 06:06:16 -0500 46ac912 Index disclosure playbook and UWP/sideloading checklist
- 2026-11-25 06:06:03 -0500 80bcca2 Add disclosure playbook and UWP/sideloading/porting checklist
- 2026-11-25 06:04:57 -0500 a23ff7c Add lab test matrix and cover_art trust-boundary note
- 2026-11-25 06:03:51 -0500 24e72b6 Index guest/bridge review and disclosure template
- 2026-11-25 06:03:32 -0500 6bef01a Add guest/bridge static review and responsible disclosure template
- 2026-11-25 06:02:25 -0500 e1f943b Add Device Portal anonymous exposure summary; update README index
- 2026-11-25 06:01:55 -0500 3986bbe Add extended source review and UWP/porting/sideloading hardening docs
- 2026-11-25 06:00:28 -0500 320c18a Refresh redacted findings export (15 rows, 13 confirmed)
- 2026-11-25 06:00:07 -0500 17d3879 Update README counts; add OBSERVED-PLATFORM sanitized summary
- 2026-11-25 05:59:44 -0500 b8243ad Add SPY-015 WDP user leak (redacted) and webxfer source-review evidence
- 2026-11-25 05:58:15 -0500 a050a0c Add CHAIN-ANALYSIS.md with evidence-grounded attack chains
- 2026-11-25 05:57:53 -0500 68883d7 Refresh README with index and confirmed finding summary
- 2026-11-25 05:57:34 -0500 bd893c8 Add REPRODUCTION.md with sanitized, reversible repro steps
- 2026-11-25 05:56:57 -0500 48f954a Add redacted machine-readable findings export
- 2026-11-25 05:56:36 -0500 7372b0f Add ENDPOINT-INVENTORY.md observed surface map
