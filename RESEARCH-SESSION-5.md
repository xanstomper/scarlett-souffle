# Research Session 5 — full-port ceiling + CSRF posture

## Full TCP scan (verified)
`nmap -sS -Pn -p 1-65535 --max-rate 2000` → exactly 5 open ports: 22 (ssh), 445 (microsoft-ds), 2869 (icslap/UPnP), 9127 (dashboard), 11443 (WDP). MAC OUI E42AAC Microsoft. No hidden high ports — honest ceiling for TCP surface.

## TLS posture (corrected)
Initial version heuristic was faulty. Verbose handshake: WDP 11443 negotiates TLSv1.3 only, cipher TLS_AES_256_GCM_SHA384, self-signed cert `CN=10.0.0.23` issued by `CN=Microsoft Windows Web Management (Test) (XBOX)`, valid 2026-11-22→2029-11-21. Modern TLS — NOT a finding. Correction recorded honestly.

## NEW finding
- **SPY-020 (low)** anonymous WDP GETs (`/api/os/info`, `/ext/screenshot`, `/api/app/packagemanager/state`) each return a fresh `set-cookie: CSRF-Token=<value>` without auth — CSRF token minted for unauthenticated clients (CWE-1275). Token values not retained.

## Ledger
20 rows, 18 CONFIRMED, 1 chain, 16 detection rules. Report/export refreshed.

## Walls
Read-only GETs; no mutation, creds, third-party, persistence/gain.
