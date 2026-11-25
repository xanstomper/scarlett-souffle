# Lab Test Matrix (authorized, isolated lab only)

Purpose: prioritize high-value tests for dev community/UWP/porting/exploit research **without** crossing legal/safety walls. All state-changing tests require explicit owner authorization and rollback plan.

## A. Safe now (read-only, already proven safe in this estate)
| Test | Method | Expected evidence | Status |
|---|---|---|---|
| Service/port inventory | nmap TCP/UDP, banner grabs | open ports, versions | Done |
| WDP anonymous GET map | curl GET only | 200/404 matrix, redacted data | Done |
| UPnP description/SCPD fetch | GET XML | device/services/actions | Done |
| UPnP read-only SOAP query | GetVolume/GetMute/GetTransportInfo | SOAP response | Done (SPY-013) |
| Tiramisu unauth GET map | status/games/settings/logs/list-files/cover/qr | info exposure evidence | Done |
| Static source review | grep/read | auth/path/args trust boundaries | Done (webxfer/main/guest/trt/cover_art) |

## B. Reversible, low-risk (needs explicit per-action go-ahead)
| Test | Risk | Rollback | Value |
|---|---|---|---|
| `POST /api/settings` harmless toggle | low | restore original value | auth-gap confirmation (done once) |
| `POST /api/rescan` | low/medium | none needed; idempotent-ish | unauth mutation proof |
| `POST /api/stop` while idle/noncritical | medium | relaunch manually | unauth control proof |
| UPnP Get* SOAP queries (other read-only) | low | none | control surface confirmation |

## C. High-impact state-changing (explicit authorization + isolated dev kit only)
| Test | Risk | Guardrails | Value |
|---|---|---|---|
| `/api/controls/input` after pairing | high | revoke token, no destructive input | control-plane impact proof |
| `/api/config` + `/api/launch` chain | high | test app only, snapshot/backup | command-line/config-to-launch chain |
| Upload/restore/delete endpoints | high/destructive | backup first, disposable content | integrity compromise proof |
| UPnP SetAVTransportURI/SetVolume/Play | medium/high | benign local URI/value, restore | unauth mutating UPnP control |
| SSRF broader internal map | medium | closed ports only, no writes | internal reachability |

## D. Lab-only exploit research (owned hardware, isolated network)
- Fuzz UPnP SOAP/XML parsing (udhisapi.dll surface) for crashes/memory corruption.
- Fuzz Tiramisu zip upload/extract, JSON config parsing, URL fetch handling.
- Audit guest/host bridge for argument injection, path canonicalization, memory safety.
- Evaluate WDP auth boundaries and CSRF on authenticated sessions (with test creds).

## Never
- No persistence, no credential brute force, no third-party pivot, no data exfil/retention, no destructive payloads, no public release of raw device identifiers or weaponized PoCs.
