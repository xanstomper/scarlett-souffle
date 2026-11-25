# Guest/Bridge Static Review (read-only)

Scope: local static review of `/home/jewboy420/tiramisu/src/guest`, `/src/trt`, and related host paths. No exploit execution, no launch, no persistence.

## Observed sandbox/containment signals (guest shim)

- `src/guest/guest_shell.c:140-141` — `ShellExecuteExW(0)` expected to fail (named no-shell behavior).
- `src/guest/guest_engine.c:169-189` — `CreateProcessW` test expects failure; console blocks children.
- `src/guest/guest_wininet.c` — wininet flow designed for honest "cannot connect/no network" behavior.
- `src/guest/kernel32.def` / `tiramisu_host.def` expose limited surfaces; `tiramisu_host.def` exports only `TiramisuHostQueryBuild`, `TiramisuHostLogU32`.

These are **defensive/compatibility signals**, not proof of escape. Absence of a bypass in grep/static read is not proof of absence.

## Trust boundaries observed

1. **Dashboard config -> host files -> guest command line**
   - webxfer `POST /api/config/<name>` writes `tiramisu_args.txt` with CR/LF normalization only (`webxfer.cpp:2563-2566`), no auth check at handler.
   - host reads args and passes to `trt_bridge_set_cmd_args` (`main.cpp:1918-1944`).
   - bridge returns args through `GetCommandLineA/W` (`trt/bridge_kernel32.cpp:3995+`).
   - *Risk class:* unauth config tamper influences guest command line on next launch. **Not exploited.**

2. **Registry hive path**
   - host sets guest registry hive path to `C:\registry.hiv` (`main.cpp` around registry hive setup; static observation).
   - *Risk class:* host-controlled persistence/config surface inside guest environment; integrity depends on host file protections.

3. **Guest network/tooling assumptions**
   - `src/guest/hermes.c` contains hardcoded endpoint `http://10.0.0.97:8790/v1/chat/completions` and `C:\hermes` root (static strings). Treat as dev artifact; validate before shipping.

## Not proven

- No guest-to-host escape, kernel escalation, bootrom/hypervisor breakout, or unsigned persistent jailbreak.
- No command injection execution proof. Args are written/passed, but no launch/exec test performed.
- No memory corruption exploit proof in bridge/guest.

## Review leads (lab-only, authorized)

- Fuzz SOAP/XML/UPnP handlers and Tiramisu upload/zip/config parsers in isolated lab.
- Audit all `trt_bridge_set_cmd_args` consumers for unsafe command-line parsing.
- Validate ACLs/ownership of `tiramisu_*.txt`, `steam_appid.txt`, registry hive, and game dirs.
- Confirm whether any unauth endpoint can trigger launch after config tamper; requires explicit reversible authorization.
