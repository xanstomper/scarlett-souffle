# Research Session 2 — 5-hour push (anon endpoint expansion)

Timer ongoing: ends 2026-11-25T16:45:25Z. Vendor-neutral. Read-only.

## WDP extended GET sweep (verified)
200 anonymous: `/api/os/info`, `/api/os/machinename`, `/api/os/devicefamily`, `/ext/settings`, `/ext/xbox/info`, `/ext/user`, `/api/networking/ipconfig`, `/api/app/packagemanager/state`, `/api/app/packagemanager/packages`, `/ext/screenshot?download=true`, `/api/filesystem/apps/files?knownfolderid=<id>`.
404/400/403: taskmanager/list, eventlog, etw, perf, processes, dump, device/name, ext/devmode, ext/developer, networking/wlan|status, filesystem without params.

## NEW confirmed findings
- **SPY-016** unauth WDP screenshot → 200 PNG 1920x1080 15210B (not retained).
- **SPY-017** unauth WDP install-state → 200 JSON.
- **SPY-018** unauth WDP filesystem listing via knownfolderid (Documents/Downloads/Pictures/Music/Videos) → 200 JSON with FullPath + Items (names, sizes, timestamps); no contents fetched.

## Posture map
Dashboard mutation endpoints OPTIONS=204; WDP mutation endpoints OPTIONS=403 (CSRF token required for non-GET when auth is on). Alternate WDP ports 80/8080/10080 closed.

## Ledger
18 rows, 16 CONFIRMED, 1 chain, 13 detection rules. Report/export to be refreshed.

## Walls
Read-only GET/OPTIONS; no mutation/creds/third-party/persistence/gain; identifiers redacted.
