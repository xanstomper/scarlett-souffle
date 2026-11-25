# Extended Source Review — Tiramisu (read-only, local)

Scope: static review of local workspace `/home/jewboy420/tiramisu/src` (not executed against target beyond already-documented read-only/reversible tests). Purpose: dev-community hardening and vuln-class mapping.

## 1) Unauth config -> launch-args chain (code-observed, not actively exploited)

**Evidence:**
- `src/host/webxfer.cpp:2528+` handles `POST /api/config/<name>` with no auth check; validates `exe` via `sanitize_rel_path`, writes `tiramisu_exe.txt`, `steam_appid.txt`, `tiramisu_args.txt`, `tiramisu_input.txt` (2544-2578 shown).
- Args write: CR/LF replaced by space, then written directly to `tiramisu_args.txt` (2563-2566). No allowlist/quoting policy.
- `src/host/main.cpp:1918-1944` reads `tiramisu_args.txt` and passes to `trt_bridge_set_cmd_args`; if absent, falls back to profile `launch_args`.
- `src/host/settings.cpp:157-165` stores `launch_args` (max 512 chars) from settings.

**Impact class:** unauth config tamper can influence guest process command line on next launch. Combined with unauth launch endpoint (code-reviewed, not tested) this is a high-risk workflow compromise. **No launch/exec performed in this assessment.**

## 2) Unauth mutation surface (code-observed)

`webxfer.cpp` handlers with no nearby auth/token checks: cover PUT, upload-complete, download-url (SSRF confirmed), restore-saves, launch, stop, rescan, delete/game, config, upload-file, upload zip, settings POST (confirmed). See `SOURCE-REVIEW-FINDINGS.md` for line table.

## 3) Path sanitization (positive control)

`sanitize_game_name` and `sanitize_rel_path` reject dot segments, traversal tokens, control chars, and separators/colon as appropriate. Live encoded traversal probes on cover endpoint returned 404. This reduces path traversal risk, but does not address missing authorization.

## 4) Dangerous API grep (limited)

Simple grep in `webxfer.cpp` for `system/popen/CreateProcess/ShellExecute/WinExec/cmd /c/eval/strcpy/sprintf` found no direct command-exec calls. This is **not** comprehensive proof of memory safety or absence of exec paths in other components.

## 5) UPnP/Device Portal exposure (observed)

UPnP SCPDs/control endpoints exposed; read-only SOAP queries succeeded unauth (SPY-013). WDP anonymous endpoints leaked OS/device/user/package info (SPY-012/014/015). These are management-plane exposures, not code-exec proofs.

## 6) Recommended dev hardening

- Require auth token/cookie for all mutation/control endpoints; bind to localhost by default.
- CSRF protection for browser-accessible POST/PUT/DELETE.
- Remove `control_code` from unauth status; rotate PIN per session.
- Allowlist download-url destinations/schemes/ports; block loopback/link-local/metadata unless explicitly required.
- Treat args/config as untrusted input; enforce strict allowlist or signed config.
- Disable UPnP/SSDP and restrict WDP on untrusted LANs.
