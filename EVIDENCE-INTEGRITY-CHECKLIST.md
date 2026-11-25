# Evidence Integrity Checklist

Use this before publishing or sharing dev-kit/UWP/porting/exploit-research findings.

## 1. Scope & authorization
- [ ] Target is owned or explicitly authorized.
- [ ] Scope boundaries recorded (IPs/domains/ports/features).
- [ ] No third-party systems contacted or pivoted.

## 2. 3-gate proof
- [ ] **Baseline:** captured expected behavior/state.
- [ ] **Attack:** minimal, authorized probe documented.
- [ ] **Diff:** measurable change (status/body/size/header/config) recorded.
- [ ] Any state change rolled back and post-restore verified.

## 3. Evidence handling
- [ ] Raw requests/responses/logs saved locally with timestamps (UTC).
- [ ] Hashes recorded for key artifacts if needed.
- [ ] Screenshots/terminal output include context (target, time, command).
- [ ] No secrets/tokens/passwords retained unnecessarily.

## 4. Redaction
- [ ] Redact ConsoleId, DeviceId, SerialNumber, Devkit cert expiry.
- [ ] Redact Email, Gamertag, XboxUserId, UserId, tokens, cookies, session codes.
- [ ] Review debug/save bundles for PII/secrets before sharing.
- [ ] Sanitize package inventories if private/custom apps are present.

## 5. Claim discipline
- [ ] Confirmed findings have evidence; hypotheses labeled as unproven.
- [ ] No "jailbreak/RCE/escape" claim without direct proof.
- [ ] Destructive/not-tested endpoints clearly marked.
- [ ] Remediation is actionable and proportionate.

## 6. Publication
- [ ] Weaponized PoCs not published.
- [ ] Repro steps are minimal and reversible.
- [ ] Disclosure timeline/coordinated channel documented.
