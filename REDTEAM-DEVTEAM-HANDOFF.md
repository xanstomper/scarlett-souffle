# Red Team / Dev Team Handoff

Evidence-grounded handoff for the Scarlett Soufflé campaign (declared owner estate, validation-only). Use to convert findings into fixes.

## Confirmed findings (fix now)

| ID | Sev | Finding | Owner action | Evidence |
|---|---:|---|---|---|
| SPY-002 | 8.0 | Unauth dev dashboard control PIN leak + pairing token issuance | Remove PIN from `/api/status`; auth+CSRF for controls; short-lived tokens | `REPRODUCTION.md`, `ATTACK-VECTORS.md` |
| SPY-012 | High | Unauth WDP OS/settings/user-presence leak | Auth-gate WDP `/api/os/*`, `/ext/settings`; isolate 11443 | `DEVICE-PORTAL-ANON-EXPOSURE.md` |
| SPY-014 | High | Unauth WDP device IDs/network/package inventory leak | Auth-gate `/ext/xbox/info`, `/api/networking/ipconfig`, `/api/app/packagemanager/packages`; redact exports | `WDP-FIELD-DICTIONARY.md` |
| SPY-015 | High | Unauth WDP `/ext/user` profile disclosure | Auth-gate `/ext/user`; disable anonymous WDP | `RESEARCH-UPDATE-2026-11-25.md` |
| SPY-007 | 5.5 | Unauth SSRF `/api/download-url` | Destination allowlist; block loopback/private/link-local/metadata; auth | `REPRODUCTION.md` |
| SPY-010 | 5.5 | Unauth file manifest disclosure | Auth-gate `/api/list-files`; minimize metadata | `ATTACK-VECTORS.md` |
| SPY-011 | 5.5 | Unauth settings mutation | Auth+CSRF on `/api/settings`; audit config changes | `REPRODUCTION.md` |
| SPY-013 | 5.5 | Unauth UPnP SOAP read-only queries | Disable UPnP/SSDP or restrict; patch/filter SOAP control | `ATTACK-VECTORS.md` |
| SPY-003/004 | 5.5 | Unauth save/debug export, telemetry CORS * | Auth-gate exports; CORS allowlist; minimize status/logs | `ATTACK-VECTORS.md` |

## Code-observed, not actively exploited

- Unauth mutation handlers in `webxfer.cpp`: launch/stop/rescan/delete/config/upload/restore/cover (see `SOURCE-REVIEW-FINDINGS.md`).
- Config->args chain: unauth config writes `dev dashboard_args.txt`, host passes to bridge args; launch not executed (`SOURCE-REVIEW-EXTENDED.md`).

## Unproven hypotheses (lab only)

Track in `KNOWN-UNPROVEN-HYPOTHESES.md`. Do not promote without 3-gate evidence: baseline, authorized minimal attack, measurable diff, cleanup.

## Handoff checklist
- [ ] Owners patch P0/P1 items per `PRIORITIZED-REMEDIATION.md`.
- [ ] Devs add regression tests for unauth 401/403, CORS allowlist, SSRF denylist.
- [ ] Researchers use `LAB-TEST-MATRIX.md` and `SELF-AUDIT-QUICKCHECK.sh` read-only first.
- [ ] Reports use `DISCLOSURE-TEMPLATE.md` and `EVIDENCE-INTEGRITY-CHECKLIST.md`; redact identifiers.
