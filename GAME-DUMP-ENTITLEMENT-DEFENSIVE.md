# Game Dumping / Entitlement — Defensive Notes (no value retained)

Walls: NO-GAIN, no value theft, no persistence. **No game dumping or decryption of protected content was performed.** This doc explains the boundary for devs/researchers.

## Observed structure (code-observed only)
- Steam depot content in `steam_client.cpp` uses BCrypt AES-256 decrypt (ECB key block + CBC body), filename encryption flag, Adler-32/chunk verification, and a depot decryption key gated on license proof (`2137-2174`).
- Tiramisu mounts disc images read-only and materializes them to a host cache for guest reads (`vfs.cpp`, `bridge_kernel32.cpp`).
- Saves/backups export via WDP/Tiramisu endpoints (SPY-003) — sensitive, auth-gated in hardened builds.

## Why dumping is outside the gate
- Copying/decrypting game content = value theft (NO-GAIN violation), possible copyright/ToS breach, and third-party harm.
- The objective's "game dumping" asks for capability mapping, not execution. We map the *protection model* so devs can defend it.

## Defensive guidance for devs
- Keep depot keys license-bound; never ship dev keys/tokens.
- Treat exported bundles, debug logs, and manifests as sensitive; require auth and redact PII.
- Preserve read-only disc-image semantics; audit `_z_write`/whiteout integrity.
- Use lab-only, owned content if testing content-pipeline integrity; verify no value is retained after test.

## Research framing
- Encryption/entitlement bypass claims require direct 3-gate proof in an authorized lab. None is claimed here.
