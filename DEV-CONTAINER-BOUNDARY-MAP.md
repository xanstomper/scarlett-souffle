# Dev Container Boundary Map (static review + observed evidence)

## Host/guest boundary (observed code)
- `src/trt/bridge_kernel32.cpp`: host provides kernel32/ntdll/ws2_32/bcrypt bridging; CreateProcessW and ShellExecuteExW are fail-visible; registry emulated via flat `C:\registry.hiv`.
- `src/trt/vfs.cpp`: guest `C:\` -> writable host `drive_c`; `Z:\` -> package install (read-only, writes redirected to `C:\_z_write` with whiteouts); disc images materialized read-only.
- `src/host/webxfer.cpp`: dashboard HTTP server on 9127; sanitizes game names/rel paths; writes config/args exe/appid/input files per game dir.
- `src/host/main.cpp`: loads args from `tiramisu_args.txt`/profile launch_args into `trt_bridge_set_cmd_args`; registry hive at `C:\registry.hiv`; binds system DLLs via `system_bind`.
- `src/guest/tiramisu_host.def`: only 2 exports (`TiramisuHostQueryBuild`, `TiramisuHostLogU32`) — narrow host API.

## Observed runtime boundaries (from WDP)
- Platform: Xbox Series S/SystemOS, DevMode "Universal Windows App Devkit", SandboxId `XDKS.1`, DefaultApp "Dev Home".
- Container: guest runs as UWP dev app with fail-visible process/shell APIs; no cert store (crypt32 open verbs NULL); wininet cannot connect; no child processes.
- Fail-visible thunks: `CreateProcessW`, `ShellExecuteExW`.

## Attack-surface summary (what was proven)
- Auth bypass/info leaks/SSRF/mutation primitives on Tiramisu dashboard and WDP (SPY-002/003/004/007/010/011/012/014/015/016/017/018/020/021).
- UPnP DeviceHost exposure + read-only SOAP control queries (SPY-008/013/019).
- No kernel/hypervisor/bootrom escape, no RCE, no persistent unsigned jailbreak proven.

## Dev porting guidance
- Preserve fail-visible thunks; document which Win32 APIs are shimmed vs blocked.
- Treat config/args/exe files as untrusted input; canonicalize paths; ACL registry hive and save dirs.
- Keep dev dashboards bound to trusted interfaces with auth+CSRF; disable UPnP/SSDP where possible.
