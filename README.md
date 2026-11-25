# Scarlett Soufflé

Evidence-backed documentation of an owner-authorized, validation-only assessment of an Xbox dev-mode estate (`10.0.0.23`) on a LAN. Focus: exposed surfaces, auth gaps, info leaks, and dev-community relevant UWP/porting/research notes.

> **Scope/walls:** declared estate only; validation-only; NO-GAIN; no persistence; no third-party contact; no credential guessing/bruteforce; no destructive payloads. Reversible tests restored immediately. Sensitive identifiers redacted in public artifacts.

## Key confirmed findings (13 confirmed / 15 rows)

- **SPY-002 HIGH 8.0** — Unauth Tiramisu control PIN disclosure -> Bearer pairing -> control session (revoked, no input injected).
- **SPY-012 HIGH** — Unauth WDP `/api/os/info` + `/ext/settings` leak OS build/platform/sandbox/dev settings/user presence.
- **SPY-014 HIGH** — Unauth WDP leaks device identifiers (redacted), network config, 74 installed packages.
- **SPY-015 HIGH** — Unauth WDP `/ext/user` user enumeration/profile fields (identifiers redacted).
- **SPY-014 HIGH** — Unauth WDP leaks device identifiers (redacted), network config, 74 installed packages.
- **SPY-007 MEDIUM** — Unauth SSRF via `/api/download-url` (console fetch diff, no file written).
- **SPY-010 MEDIUM** — Unauth file-manifest disclosure via `/api/list-files`.
- **SPY-011 MEDIUM** — Unauth settings mutation via POST `/api/settings` (reversible).
- **SPY-013 MEDIUM** — Unauth UPnP SOAP read-only queries (GetVolume/GetMute/GetTransportInfo).
- **SPY-003/004 MEDIUM** — Unauth save/debug export; unauth telemetry/CORS wildcard.
- **SPY-008/009 INFO** — UPnP DeviceHost/WDP TLS surface exposure.
- **SPY-001 INFO** — SMBv1/MS17-010 negative clearance.

## Repo index

- [`ATTACK-VECTORS.md`](ATTACK-VECTORS.md) — finding table, surface map, chains, mitigations.
- [`DEV-COMMUNITY-FAQ.md`](DEV-COMMUNITY-FAQ.md) — myths vs evidence, dev/porting/jailbreak framing.
- [`DEV-COMMUNITY-NOTES.md`](DEV-COMMUNITY-NOTES.md) — dev-kit risk model, UWP/porting notes, responsible jailbreak framing.
- [`ENDPOINT-INVENTORY.md`](ENDPOINT-INVENTORY.md) — observed endpoints and auth status.
- [`REPRODUCTION.md`](REPRODUCTION.md) — sanitized, reversible repro commands.
- [`RESEARCH-UPDATE-2026-11-25.md`](RESEARCH-UPDATE-2026-11-25.md) — live observation log.
- [`xbox-devmode-spydermonkey-report.md`](xbox-devmode-spydermonkey-report.md) — regenerated war report.
- [`SOURCE-REVIEW-FINDINGS.md`](SOURCE-REVIEW-FINDINGS.md) — webxfer auth-gap line evidence.
- [`SOURCE-REVIEW-EXTENDED.md`](SOURCE-REVIEW-EXTENDED.md) — extended static review and chains.
- [`UWP-PORTING-SIDELOADING-HARDENING.md`](UWP-PORTING-SIDELOADING-HARDENING.md) — dev-mode/UWP/porting hardening.
- [`OBSERVED-PLATFORM.md`](OBSERVED-PLATFORM.md) — sanitized platform facts.
- [`DEVICE-PORTAL-ANON-EXPOSURE.md`](DEVICE-PORTAL-ANON-EXPOSURE.md) — redacted anonymous WDP endpoint/data map.
- [`HOST-MODULE-REVIEW.md`](HOST-MODULE-REVIEW.md) — steam_client/ui/swapchain static review.
- [`GUEST-BRIDGE-REVIEW.md`](GUEST-BRIDGE-REVIEW.md) — guest/bridge trust-boundary static review.
- [`EVIDENCE-INTEGRITY-CHECKLIST.md`](EVIDENCE-INTEGRITY-CHECKLIST.md) — 3-gate evidence/redaction/publication checklist.
- [`DISCLOSURE-TEMPLATE.md`](DISCLOSURE-TEMPLATE.md) — responsible disclosure template.
- [`DISCLOSURE-PLAYBOOK.md`](DISCLOSURE-PLAYBOOK.md) — disclosure triage/playbook.
- [`UWP-SIDELOADING-PORTING-CHECKLIST.md`](UWP-SIDELOADING-PORTING-CHECKLIST.md) — UWP/sideloading/porting hardening checklist.
- [`PRIORITIZED-REMEDIATION.md`](PRIORITIZED-REMEDIATION.md) — P0-P3 remediation priorities.
- [`NETWORK-SEGMENTATION.md`](NETWORK-SEGMENTATION.md) — observed ports/services and segmentation baseline.
- [`DEV-KIT-HARDENING-BASELINE.md`](DEV-KIT-HARDENING-BASELINE.md) — actionable dev kit hardening baseline.
- [`KNOWN-UNPROVEN-HYPOTHESES.md`](KNOWN-UNPROVEN-HYPOTHESES.md) — confirmed vs unproven hypothesis register.
- [`SAFE-LAB-SCENARIOS.md`](SAFE-LAB-SCENARIOS.md) — authorized reversible lab scenarios.
- [`LAB-TEST-MATRIX.md`](LAB-TEST-MATRIX.md) — safe-to-lab test prioritization.
- [`RESPONSE-KEY-SNAPSHOTS.md`](RESPONSE-KEY-SNAPSHOTS.md) — redacted anonymous response key/type snapshots.
- [`OBSERVED-HTTP-MATRIX.md`](OBSERVED-HTTP-MATRIX.md) — redacted observed HTTP response matrix.
- [`SELF-AUDIT-QUICKCHECK.sh`](SELF-AUDIT-QUICKCHECK.sh) — owner read-only self-audit script.
- [`WDP-SOFTWARE-SURFACE.md`](WDP-SOFTWARE-SURFACE.md) — redacted anonymous package/software surface summary.
- [`WDP-FIELD-DICTIONARY.md`](WDP-FIELD-DICTIONARY.md) — redacted WDP field-level data dictionary.
- [`QUICKSTART-AUDIT-REPORT.md`](QUICKSTART-AUDIT-REPORT.md) — owner read-only audit and reporting workflow.
- [`REDTEAM-DEVTEAM-HANDOFF.md`](REDTEAM-DEVTEAM-HANDOFF.md) — findings-to-fixes handoff.
- [`REPORT-PACK-INDEX.md`](REPORT-PACK-INDEX.md) — consolidated report pack index.
- [`findings-redacted.json`](findings-redacted.json) — machine-readable redacted export.
- `EVIDENCE.md`, `FINDINGS.md` — earlier archive.

## Method

Read-only recon, source review of local Tiramisu `webxfer.cpp`, and minimal reversible 3-gate proofs. No destructive endpoint testing (launch/delete/restore/upload) performed. UPnP mutating SOAP actions not invoked.
