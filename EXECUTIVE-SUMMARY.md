# Executive Summary — Scarlett Soufflé

**Assessment:** owner-authorized, validation-only, read-only/reversible where state changed.  
**Estate:** Xbox dev-mode device on LAN (`10.0.0.23`).  
**Date:** 2026-11-25.  
**Result:** 15 ledger rows, 13 CONFIRMED, 2 FALSE_POSITIVE quarantined.

## What matters

The dev kit exposed multiple management surfaces without effective access controls. The most serious confirmed issue was an unauthenticated Tiramisu control-plane flow: a PIN was exposed in status data and could be exchanged for a control token (SPY-002, HIGH 8.0). The token was revoked immediately; no input was injected.

Additional confirmed exposures included anonymous Device Portal leaks of OS/device/user/package data (SPY-012/014/015, HIGH), unauthenticated SSRF (SPY-007), unauthenticated settings mutation (SPY-011, reversible), unauthenticated file-manifest and export disclosure (SPY-010/003/004), and unauthenticated UPnP read-only control queries (SPY-013).

## What was not proven

No kernel/hypervisor/bootrom jailbreak, no persistent unsigned escape, and no remote code execution were proven. Hypotheses requiring state-changing or lab-only testing remain documented but unconfirmed.

## Business/dev impact

- **Confidentiality:** device identity, user presence, network config, package inventory, logs, and file manifests exposed.
- **Integrity:** unauth config/mutation surface present; destructive endpoints not tested but code-reviewed.
- **Availability/Control:** control-plane credential issuance proven; input injection not executed.

## Immediate actions

1. Isolate dev kits to trusted mgmt network; firewall 9127/11443/2869/1900.
2. Add auth+CSRF to all dashboard/controls/mutation endpoints; remove PIN/token from unauth status.
3. Lock down WDP anonymous endpoints; disable CORS wildcard.
4. Add SSRF destination allowlist; block loopback/private/link-local/metadata.
5. Re-run `SELF-AUDIT-QUICKCHECK.sh` after fixes.

## Evidence

See `REPORT-PACK-INDEX.md`, `xbox-devmode-spydermonkey-report.md`, `findings-redacted.json`, and `REPRODUCTION.md`. Sensitive identifiers redacted.
