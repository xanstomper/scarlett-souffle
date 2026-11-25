# Quickstart — Owner Audit & Report Workflow

For devs/owners assessing their own Xbox dev-mode + tooling exposure. Read-only by default.

## 1. Scope & safety
- Only test assets you own or are explicitly authorized to assess.
- Start read-only: GET/OPTIONS/HEAD, no creds, no brute force, no mutation.
- Redact ConsoleId/DeviceId/SerialNumber/Devkit cert expiry, Email/Gamertag/XboxUserId/UserId, tokens.

## 2. Run the read-only self-audit
```bash
./SELF-AUDIT-QUICKCHECK.sh <xbox-ip>
```
Outputs HTTP status/size for common Tiramisu/WDP/UPnP endpoints. Treat any sensitive 200 as exposure.

## 3. Triage findings
Use 3-gate evidence:
- **Baseline:** expected behavior (auth required / no data).
- **Attack:** minimal authorized probe.
- **Diff:** measurable status/body/config change; rollback if state changed.

Classify with `PRIORITIZED-REMEDIATION.md`:
- P0: control-plane auth bypass, anonymous device/user identity leaks.
- P1: unauth mutation endpoints, SSRF, sensitive exports.
- P2: CORS *, UPnP exposure, token hygiene.

## 4. Map to known vectors
Cross-check with:
- `ATTACK-VECTORS.md` — confirmed findings.
- `ENDPOINT-INVENTORY.md` / `OBSERVED-HTTP-MATRIX.md` — surface map.
- `KNOWN-UNPROVEN-HYPOTHESES.md` — what needs lab proof before calling a finding.

## 5. Report responsibly
Use `DISCLOSURE-PLAYBOOK.md` and `DISCLOSURE-TEMPLATE.md`.
Include: affected build/surface, minimal repro, diff, cleanup, impact, remediation, redacted evidence. No weaponized PoCs, no raw identifiers.

## 6. Harden
Apply `DEV-KIT-HARDENING-BASELINE.md` and `UWP-SIDELOADING-PORTING-CHECKLIST.md`. Re-run self-audit after changes.
