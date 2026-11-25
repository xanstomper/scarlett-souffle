# Boot Chainload Hook & Registry Emulation (static review)

Source: `src/trt/bridge_kernel32.cpp` (~3051, 3290-3350), `src/trt/bridge_reg.cpp`, local dev dashboard tree. Read-only. Hypotheses only; no escape/exec proven.

## CreateProcessW paths (guest boundary)
1. **Harness-modeled child:** creates synthetic process object, logs "console would deny", returns TRUE with pid — no real child on console.
2. **Spawn hook failure:** returns ERROR_ACCESS_DENIED (access denied).
3. **Optional in-process host chainload hook** (`trt_boot_chainload_hook`, function pointer at :3051): when set and target nonempty, resolves the target PE through `trt_vfs_resolve_utf16`, stats it (regular file >64 bytes), then calls the hook `(host_path, cmdline, &child_rc, &ok)`. On ok, synthesizes process handle/pid and returns TRUE.

## Trust-boundary observations (documented, not exploited)
- The chainload hook is a **function pointer optional path** — on the console build it may be unset (fail-visible child denial remains default). Presence/configuration of this hook in the shipping Xbox build was not verified live.
- Target path passes through VFS resolution (mount-target confinement, `\\?\` prefix stripping) before host `fopen`/hook — same canonicalization boundary as `CreateFileW`.
- Registry emulation (`bridge_reg.cpp`): flat text hive on guest `C:` rewritten after each write; 5 fixed HKEY roots; handle table. This is a host-controlled file integrity surface.
- No proof that a guest can set `trt_boot_chainload_hook`, no proof of host exec, no persistence installed.

## Porting/dev relevance
- Devs can use the chainload hook to run child exes *in-process* on desktop/dev harness builds; understand it is not a general child-process facility on console.
- Registry hive (`C:\registry.hiv`) should be ACL'd/backed up; treat as guest-visible persistent state.

## Lab-only next steps (require authorization)
- Determine whether the shipping dev-mode build sets `trt_boot_chainload_hook`; if so, what host-side code backs it.
- Fuzz VFS target resolution for confinement bypass; any exec claim needs 3-gate proof on owned device.

## Walls
Static review only. No exec, no persistence, no decryption, no game dumping, no third-party.
