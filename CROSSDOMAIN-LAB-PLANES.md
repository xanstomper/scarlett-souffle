# Crossdomain / ATT&CK Lab Planes (KAIRO, read-only)

Generated with family engines against `xbox-devmode` campaign. Plans are PROBED in the plane ledger only — **never auto-CONFIRMED, never distributed**; lab-first, owned devices.

## KAIRO crossdomain web→hardware (6 transposed plans)
| Web class | Hardware plane | Plan (documented) |
|---|---|---|
| BOUNDARY | HWFLASH | scope-id trust on update/extract path: device trusts source id/slot |
| REPLAY | HDRADIO | pairing/replay window on radio plane: capture then replay pairing/ack frames |
| STATEBYPASS | HWFLASH | out-of-order OTA/bootloader stages: stage N+2 before N+1 (owned device) |
| MATH | HDRADIO | precision drift in radio counters |
| ENTITLEMENT | HWFLASH | entitlement flags in firmware config: reorder provisioning flow |
| AUTHBYPASS | HDRADIO | key/entropy gaps in pairing material: estimate effective bits |

## ATT&CK corpus map
- `spydermonkey attack --json`: total_files 139222, mapped 80517, coverage 57.8%, 32 techniques (T1190, T1552, T1610, T1611, T1557, T1550, T1592, T1110, ...).
- Campaign-confirmed techniques (from KAGE): T1592, T1550, T1083, T1098, T1190, T1552.

## Relevance to this estate
- Web→hardware transpose is a **hypothesis generator** for owned-device lab work (boot/update trust, pairing replay, entitlement flags). None proven here.
- Maps to known-unproven register H-004..H-008; promote only with 3-gate lab proof.
- Entitlement plane is explicitly bounded: no license/decryption bypass performed (see `GAME-DUMP-ENTITLEMENT-DEFENSIVE.md`).

## Walls
Lab-first, owned devices, no auto-distribution, NO-GAIN, no persistence, no third-party.
