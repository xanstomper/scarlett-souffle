# Research Session 1 — 5-hour push (R1 sweep)

Timer: 2026-11-25T11:45:25Z → 16:45:25Z. Scope: declared estate 10.0.0.23. Vendor-neutral language.

## Read-only endpoint sweep (verified output)
Tiramisu dashboard 9127 — all 200 with no auth:
```
/api/status      200 375B   /games       200 1159B  /api/settings 200 222B
/api/logs        200 16226B /api/steam/* 200 127/408B  /api/qr.svg 200 4346B
/controls        200 6252B
```
WDP 11443 — all 200 anonymous:
```
/api/os/info 187B  /api/os/devicefamily 31B  /ext/settings 10493B
/ext/xbox/info 310B  /ext/user 182B  /api/networking/ipconfig 1894B
/api/app/packagemanager/packages 49799B
```
UPnP: 1900/udp open, `Server: Microsoft-Windows/10.0 UPnP/1.0 UPnP-Device-Host/1.0`, device XML location exposed, MAC OUI E42AAC (Microsoft).

## Live log analysis
`/api/logs` 96 lines, 9 normalized-unique: watchdog memory ticks, `[tid=4556] gap: trace seq=689540`, `webxfer: GAP-HTTP-ACCEPT workers=0`, `webxfer: GAP-HTTP-WORKERSTART`. No secrets/tokens in unauth log tail. Confirms active web server + guest telemetry exposure.

## Deductions (evidence-backed)
- Dashboard + WDP + UPnP remain unauthenticated and LAN-reachable — matches confirmed ledger (SPY-002/003/004/007/010/011/012/013/014/015).
- No new endpoints beyond inventory; attack surface is stable, not expanding.
- Log tail carries no sensitive values beyond what is already documented.

## Walls held
Read-only GETs only; no mutation, no third-party, no creds, no persistence/gain. Identifiers redacted.
