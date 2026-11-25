# KAGE Detection Export (real Sigma rules from confirmed findings)

Generated with the family's KAGE mirror mandate against the `xbox-devmode` campaign (no new target contact; consumes confirmed ledger state).

## Command evidence
```bash
kage.py mirror --target xbox-devmode      # 13 detection rule(s) mirrored
kage.py export --target xbox-devmode --dir detection-rules --format sigma
kage.py coverage --target xbox-devmode     # 6 techniques, 13 rules
kage.py validate --target xbox-devmode     # 0/13 live telemetry, 13 rule-only
```

## Results
- 13 Sigma rules exported to `detection-rules/kage-*.yml`.
- ATT&CK coverage: T1592 (7), T1550 (2), T1083/T1098/T1190/T1552 (1 each).
- Notable: KAGE-009 & KAGE-011 are `critical` auth-bypass rules (SPY-011 settings, SPY-013 UPnP SOAP); KAGE-005 covers SSRF (SPY-007); KAGE-008 covers file-listing recon (SPY-010); KAGE-013 covers WDP user disclosure (SPY-015).
- Honest validation: **0/13 rules backed by live telemetry** — they are rule-only deliverables to defenders, not refire-proven detections. Real-world deployment needs log sources (app/api/web/egress/auth logs) wired in.

## Example rule (KAGE-009)
```yaml
title: "Protected route with empty credential material"
id: "ec65df8f-92b4-4a96-af50-3fb6259320b7"
status: "experimental"
logsource: {service: "auth"}
detection:
  uri_re: "/(api|admin|account)/"
  cred_empty: true
  status: 200
  condition: "sel"
falsepositives: ["health endpoints", "public marketing routes"]
level: "critical"
tags: ["attack.t1550"]
```

## Dev-community value
Converts offense into defense: devs can deploy these Sigma rules on their own SIEM/log stack to detect the same classes the campaign confirmed. Keep `status: experimental` until validated against live telemetry.
