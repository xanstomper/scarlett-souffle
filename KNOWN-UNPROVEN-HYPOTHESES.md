# Known / Unproven Hypotheses Register

Purpose: separate confirmed evidence from plausible but **unproven** hypotheses for authorized lab follow-up. Do not treat hypotheses as findings.

## Confirmed (evidence-backed)
- SPY-002: unauth Tiramisu PIN disclosure + control pairing token issuance (revoked).
- SPY-003/004/010/012/014/015: unauth info leaks (exports, telemetry, file manifests, WDP OS/settings/user/device/package).
- SPY-007: unauth SSRF via `/api/download-url`.
- SPY-011: unauth settings mutation (reversible).
- SPY-013: unauth UPnP read-only SOAP queries accepted.
- SPY-008/009: UPnP/WDP exposure surfaces.

## Unproven hypotheses (lab-only, explicit authorization required)

| ID | Hypothesis | Why plausible (evidence) | Not proven because | Safe next test |
|---|---|---|---|---|
| H-001 | Unauth `/api/controls/input` allows remote input injection after SPY-002 pairing | Token issuance proven; control JS references input endpoint | No input injected; state-changing | Owned lab only, benign input, immediate revoke |
| H-002 | Unauth config+launch chain leads to arbitrary app launch / arg tamper impact | `webxfer.cpp` writes args/exe/config without auth; main reads `tiramisu_args.txt` into bridge args | No launch executed | Disposable test app, snapshot, explicit approval |
| H-003 | Unauth upload/restore/delete endpoints allow content integrity compromise | Handlers present with no auth checks in source review | Destructive/state-impact; not tested | Lab backup, disposable files, reversible only |
| H-004 | UPnP mutating SOAP actions (SetAVTransportURI/SetVolume/Play) accepted unauth | SCPD advertises actions; read-only queries succeeded | Mutating calls not invoked | Benign SetVolume on owned device with restore |
| H-005 | SSRF can reach sensitive internal services | SSRF primitive confirmed; loopback limited probes showed 9127 404 / others failed | No internal service pivot proven | Controlled local listener tests in lab |
| H-006 | Cover-art remote JSON URL fetch can be abused in hostile network | `cover_art.cpp` fetches Steam URLs and remote JSON-derived image fields | No malicious URL injection path proven | Code audit + proxy/MITM lab simulation |
| H-007 | Steam client token persistence/logging exposes secrets | `steam_client.cpp` handles tokens/CM/WebSocket/HTTP APIs | No secret leak proven | Static audit for token storage/log redaction in lab build |
| H-008 | WDP/UPnP stack has memory/parser bugs | Complex XML/SOAP/HTTP surfaces exposed | No fuzzing/crash proof | Authorized fuzzing in isolated lab |

## Reporting rule
Any hypothesis promoted to finding must have: baseline, authorized minimal attack, measurable diff, cleanup, and scope proof. Without that, keep it as hypothesis.
