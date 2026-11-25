# Defender Detection Rules (mapped to observed artifacts)

Defensive signals for dev kits running Tiramisu/WDP/UPnP on LAN. Tune to your environment; validate in lab.

## Network/HTTP signals

| Signal | Why | Source finding | Suggested detection |
|---|---|---|---|
| GET `/api/status` from non-admin hosts | Leaks `control_code` PIN (SPY-002) | SPY-002 | Alert on unauth reads to `/api/status`; remove field |
| POST `/api/controls/pair` | Control session issuance | SPY-002 | Alert any pair request; require auth+rate limit+audit |
| POST `/api/controls/input` | Remote input injection path | H-001 (unproven) | Block/alert; should never be unauth |
| POST `/api/download-url` | SSRF primitive | SPY-007 | Alert on any request; inspect destination URL; deny private/loopback |
| POST `/api/settings` from unexpected origin | Unauth config mutation | SPY-011 | Alert + require auth/CSRF; log before/after diff |
| GET `/api/list-files?game=` | File manifest disclosure | SPY-010 | Alert bulk enumeration; auth-gate |
| GET `/api/backup-saves` or `/api/debug-bundle` | Sensitive export | SPY-003 | High-severity alert; auth-gate; DLP scan |
| Anonymous GET `/ext/xbox/info`, `/ext/user`, `/api/networking/ipconfig`, `/api/app/packagemanager/packages` on 11443 | WDP identity/inventory leak | SPY-012/014/015 | Alert anonymous 200; require auth |
| SOAP POST to UPnP control URLs with `GetVolume`/`SetVolume`/`SetAVTransportURI` | UPnP control surface | SPY-013, H-004 | Alert SOAPAction headers; block mutating actions from untrusted hosts |
| CORS `Access-Control-Allow-Origin: *` on management endpoints | Browser-origin abuse | SPY-004 | Config audit; alert on wildcard CORS |

## Host/log signals

- Tiramisu logs showing unexpected `POST /api/controls/pair`, `download-url`, `settings saved from web dashboard`, upload/restore/delete/launch.
- WDP audit logs for anonymous access to `/ext/*` and package manager endpoints.
- New outbound connections from console/dev kit to unusual internal/external URLs after `download-url` requests.

## Response playbook
1. Isolate dev kit from untrusted network.
2. Capture volatile evidence (logs, PCAP, config snapshot) with redaction.
3. Rotate tokens/credentials; invalidate paired control sessions.
4. Patch P0/P1 from `PRIORITIZED-REMEDIATION.md`.
5. Re-run `SELF-AUDIT-QUICKCHECK.sh` from trusted admin host.

## False-positive notes
- Legitimate admin use may hit status/settings; baseline known admin IPs.
- Read-only UPnP discovery may be normal in media setups; mutating SOAP actions are higher signal.
