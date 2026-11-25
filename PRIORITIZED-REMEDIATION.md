# Prioritized Remediation Memo (Dev Kit / UWP Tooling)

Priority-ordered fixes based on confirmed Scarlett Soufflé findings. Goal: reduce highest-impact LAN exposure first.

## P0 — Immediate (same day)
1. **Remove control PIN leak and require auth on controls (SPY-002, HIGH 8.0).**
   - Do not return `control_code` in unauth `/api/status`.
   - Require strong auth/session for `/api/controls/pair` and `/api/controls/input`; CSRF token for browser flows.
   - Short token TTL, one-time pairing, audit logs.

2. **Lock down Windows Device Portal anonymous exposure (SPY-012/014/015, HIGH).**
   - Disable or restrict anonymous WDP endpoints; require auth for `/api/os/*`, `/ext/settings`, `/ext/xbox/info`, `/ext/user`, `/api/networking/ipconfig`, `/api/app/packagemanager/packages`.
   - Firewall 11443 to trusted management VLAN/VPN only.
   - Rotate any exposed dev credentials/sessions; review account presence on shared kits.

## P1 — High (24-72 hours)
3. **AuthZ + CSRF on all dev dashboard mutation endpoints (SPY-011, code-reviewed surface).**
   - Require auth on `/api/settings`, `/api/config`, `/api/launch`, `/api/stop`, `/api/rescan`, `/api/upload-file`, `/upload/*.zip`, `/api/upload-complete`, `/api/restore-saves`, `/api/delete`, `/api/game/<n>` DELETE, `/api/cover` PUT.
   - Add CSRF tokens/origin checks for browser UI.

4. **SSRF egress controls (SPY-007).**
   - Allowlist schemes/hosts/ports; block loopback, RFC1918, link-local, metadata, and unexpected redirects.
   - Remove raw fetch error details from unauth status if not needed.

5. **Sensitive data export controls (SPY-003/010).**
   - Require auth for `/api/backup-saves`, `/api/debug-bundle`, `/api/list-files`.
   - Redact secrets/PII from debug bundles; document bundle contents.

## P2 — Medium (week)
6. **CORS and info disclosure minimization (SPY-004).**
   - Replace `Access-Control-Allow-Origin: *` with strict allowlist.
   - Minimize unauth status/logs/settings/game inventory responses.

7. **UPnP/SSDP hardening (SPY-008/013).**
   - Disable UPnP/SSDP if unused. If required, restrict to trusted LAN and patch OS/components.
   - Monitor for unauth SOAP control attempts; block mutating actions from untrusted clients.

8. **Token/secret hygiene (HOST-MODULE-REVIEW).**
   - Protect `steam.token`/credential stores with ACLs; avoid tokens in URL query params; scrub logs/exports.

## P3 — Process & lab validation
9. **Regression tests.** Add automated checks: unauth GETs to sensitive endpoints return 401/403; CORS not wildcard; SSRF destinations denied.
10. **Authorized lab follow-up.** Use `LAB-TEST-MATRIX.md` and `KNOWN-UNPROVEN-HYPOTHESES.md`; only reversible, owner-authorized tests; no persistence/gain.
