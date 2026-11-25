# Research Session 1 — 5-hour push (R1/R2)

Timer: 2026-11-25T11:45:25Z → 16:45:25Z. Scope: declared estate 10.0.0.23. Vendor-neutral language.

## R1 — read-only endpoint sweep (verified output)
Dashboard 9127 all 200 anon: `/api/status` 375B, `/games` 1159B, `/api/settings` 222B, `/api/logs` 16226B, `/api/steam/status` 127B, `/api/steam/library` 408B, `/api/qr.svg` 4346B, `/controls` 6252B.
WDP 11443 all 200 anon: `/api/os/info` 187B, `/api/os/devicefamily` 31B, `/ext/settings` 10493B, `/ext/xbox/info` 310B, `/ext/user` 182B, `/api/networking/ipconfig` 1894B, `/api/app/packagemanager/packages` 49799B.
UPnP: 1900/udp open, `Microsoft-Windows/10.0 UPnP/1.0 UPnP-Device-Host/1.0`, device XML location exposed, MAC OUI E42AAC (Microsoft).
Live logs: 96 lines/9 normalized-unique (watchdog, trace gap, webxfer GAP-HTTP-ACCEPT/WORKERSTART) — no secret values in unauth log tail.

## R2 — NEW findings (3-gate, read-only)
- **SPY-016 (medium)** unauth WDP `/ext/screenshot?download=true` → HTTP/2 200 PNG 1920x1080 15210B + fresh CSRF cookie. Live TV frame disclosure. Image not retained.
- **SPY-017 (low)** unauth WDP `/api/app/packagemanager/state` → 200 JSON install state.
- OPTIONS map: dashboard mutation endpoints return 204; WDP mutation endpoints OPTIONS=403 (CSRF/auth posture differs).

## Ledger state
17 rows, 15 CONFIRMED, 1 chain (CH-001), 13 KAGE detection rules. Report + redacted export refreshed.

## Walls held
Read-only GETs/OPTIONS only; no mutation/creds/third-party/persistence/gain. Identifiers redacted.
