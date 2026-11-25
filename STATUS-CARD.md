# Estate Status Card

**Declared estate:** `10.0.0.23` (Xbox dev-mode device, owner-authorized, validation-only)
**Scope authority:** `~/.redteam/xbox-devmode-scope.json` (expires 2026-12-25)
**Identity (read-only):** MAC OUI E42AAC = Microsoft; UPnP friendlyName XBOX; Platform Xbox Series S; WDP OS 26100.9662
**Open ports (TCP):** 22 (SSH), 445 (SMB), 2869 (UPnP HTTPAPI), 9127 (Tiramisu dashboard), 11443 (Device Portal TLS)
**Open UDP:** 1900 (SSDP/UPnP)
**Ledger:** 21 rows, 19 CONFIRMED, 2 FALSE_POSITIVE quarantined, 1 chain (CH-001), 16 KAGE Sigma rules
**Report:** `xbox-devmode-spydermonkey-report.md` (regenerated each pass)
**Repo:** https://github.com/xanstomper/scarlett-souffle

## Walls held
- Validation-only; NO-GAIN; no persistence; no third-party contact; no credential guessing.
- Read-only GETs only this pass; no state-changing tests, no mutating UPnP SOAP, no launch/upload/delete/restore.
- Sensitive identifiers redacted in all public artifacts.

## Confirmed findings (19)
SPY-001 (info, SMBv1 clearance) · SPY-002 (HIGH 8.0, control PIN→pairing) · SPY-003 (medium, save/debug export) · SPY-004 (medium, CORS telemetry) · SPY-007 (medium, SSRF) · SPY-008 (info, UPnP DeviceHost) · SPY-009 (info, WDP TLS) · SPY-010 (medium, file manifest) · SPY-011 (medium, settings tamper) · SPY-012 (high, WDP OS/settings/user presence) · SPY-013 (medium, UPnP read-only SOAP) · SPY-014 (high, WDP device IDs/network/packages) · SPY-015 (high, WDP user enumeration) · SPY-016 (medium, WDP screenshot) · SPY-017 (low, WDP install state) · SPY-018 (medium, WDP FS listing) · SPY-019 (low, UPnP ConnectionManager) · SPY-020 (low, CSRF cookie minting) · SPY-021 (medium, CORS preflight acceptance)

## Quarantined (FALSE_POSITIVE)
SPY-005/006 (dojo lab artifacts at 127.0.0.1:8851, not estate)

## Chain
CH-001: info disclosure (SPY-003) → SSRF pivot (SPY-007), conf 0.75, not executed.
