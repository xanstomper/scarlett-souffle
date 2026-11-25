# Remaining Host Module Review (static, read-only)

Final pass over local Tiramisu host modules not yet reviewed. No runtime testing.

## Files reviewed
- `audio.cpp`, `boot_anim.cpp`, `console_detect.cpp`, `crash_report.cpp`, `host_log.cpp`, `host_autopilot.h`, `swapchain.cpp`, `settings.cpp`, `steam_client.cpp`, `ui.cpp`, `webxfer.cpp`, `cover_art.cpp`, `main.cpp`.

## Observations
- `console_detect.cpp`: reads files (`fopen p.c_str()`) for console detection; no network/auth surface observed by pattern grep.
- `crash_report.cpp`: writes/removes report files under local state; no network/exec patterns.
- `host_log.cpp`: file rotation (`remove`/`rename`/`fopen` append) under local state; no exec/network/auth.
- `audio.cpp`: binds dsound sink (`trt_dsound_bind_sink`); no network/auth/exec.
- `boot_anim.cpp`: reads animation file (`fopen tanim_path`); no network/exec.
- `swapchain.cpp`: graphics bind/present (d3d9/gl/vk); no network/auth/exec.
- `steam_client.cpp`: outbound HTTPS to Steam APIs, token persistence in `steam.token`, token-in-URL query params, hardcoded Steam endpoints. Trust-boundary notes in `HOST-MODULE-REVIEW.md`.
- `cover_art.cpp`: outbound HTTPS to Steam store/images; remote-JSON-derived image URLs; writes under `g_covers_dir` with sanitized keys. Trust-boundary note in `SOURCE-REVIEW-EXTENDED.md`.
- `main.cpp`: system DLL binding via `system_bind`; ISO/disc-image handling; VFS mounts; registry hive at `C:\registry.hiv`; args from `tiramisu_args.txt`/profile; steam_auth flag. No direct network listener in main.

## Conclusion
No additional unauth network/auth/exec surfaces found by simple static grep in these modules. Dominant risk remains the webxfer dashboard (9127) and WDP (11443) management planes. This is a limited pattern-based review, not a full security audit.

## Walls
Static review only. No runtime testing, no mutation, no creds, no third-party.
