# Safe Lab Scenarios (Authorized, Reversible)

These scenarios are for owned dev kits in isolated labs. They extend the lab test matrix with practical workflows.

## Scenario 1 — Management plane exposure audit
- **Goal:** map anonymous reads and missing auth.
- **Steps:** enumerate 9127/11443/2869 with GET/OPTIONS only; capture status codes and redacted field names.
- **Pass criteria:** no sensitive identifiers/settings exposed anonymously.
- **Evidence:** HTTP headers, redacted JSON keys, screenshots.

## Scenario 2 — Reversible config mutation proof
- **Goal:** confirm auth gap without harmful change.
- **Steps:** baseline GET settings; POST harmless cosmetic toggle; verify diff; restore original.
- **Guardrail:** restore immediately; no launch/upload/delete.
- **Evidence:** before/after/restore JSON.

## Scenario 3 — SSRF egress boundary test
- **Goal:** validate destination restrictions.
- **Steps:** attempt fetch to denied loopback/private/metadata targets and an approved test server; observe errors/results.
- **Guardrail:** no writes, no internal credentialed services.
- **Evidence:** request body, status, error diff, server logs.

## Scenario 4 — UPnP control query vs mutation
- **Goal:** separate read-only exposure from mutating control.
- **Steps:** send GetVolume/GetMute/GetTransportInfo only; record responses. Do not send SetAVTransportURI/SetVolume/Play without explicit approval.
- **Evidence:** SOAP request/response, redacted.

## Scenario 5 — Sideload workflow integrity
- **Goal:** test auth/CSRF/path validation on upload/config/launch.
- **Steps:** in disposable lab image, attempt unauthorized mutation; verify deny. Only with explicit authorization, test reversible benign upload.
- **Guardrail:** backup/snapshot, disposable content, no persistence.
- **Evidence:** HTTP traces, file system diffs, rollback proof.

## Scenario 6 — Disclosure packaging
- **Goal:** produce dev-friendly report.
- **Steps:** use `DISCLOSURE-PLAYBOOK.md` template; include 3-gate proof, redactions, remediation.
- **Guardrail:** no raw identifiers, no weaponized PoC.
