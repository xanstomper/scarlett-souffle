# Bridge Path Canonicalization (static review, read-only)

Source: `src/trt/vfs.cpp` + `src/trt/bridge_kernel32.cpp`, local dev dashboard tree. For UWP/Win32 porters and authorized research. No exploit executed.

## Virtual drive model
- `C:\` -> writable host dir (game installs, saves, registry file: `C:\registry.hiv`).
- `Z:\` -> package install dir, read-only (game's own files); writes redirected to `C:\_z_write` with whiteouts.
- Disc images -> read-only; materialized to host cache; writes refused upstream.

## Resolver (`trt_vfs_resolve_utf16_rw`, vfs.cpp:719+)
- Converts guest UTF-16 path to UTF-8, strips Win32 extended/NT prefixes (`\\?\`, `\??\`, `\\.\`).
- `normalize_guest_locked` splits drive (`drv`) + relative (`rest`); unknown drive -> -1.
- `join_norm(m->target, "", rest)` maps guest relative path under the mount target; case-insensitive resolution on Linux host.
- Z: writes -> overlay `C:\_z_write/<rest>`; reads check whiteouts + overlay before falling back to `Z:` target.
- Long-path `fopen` retry uses `\\?\` prefix with '/'->'\\' conversion (vfs.cpp:73-120).

## Trust-boundary observations (documented, not exploited)
- Path canonicalization is centralized in `normalize_guest_locked`/`join_norm`; prefix stripping is explicit. **No traversal bypass proven** by static read; a fuzz lab test is needed for assurance.
- Z: read-only semantics rely on `for_write` flag; copy-on-write on Z: modification; whiteout logic is the integrity boundary.
- Guest `CreateFileW` (bridge_kernel32.cpp ~1960-2170) calls `trt_vfs_resolve_utf16_rw` then host `fopen`/`CreateFile2` for directory handles; disc-image writes blocked before resolve.
- `build_guest_vpath` records normalized virtual path for logging/diagnostics.

## Porting/defensive guidance
- Keep prefix stripping + mount-target confinement; never pass raw guest path to host filesystem.
- Preserve Z: read-only and whiteout semantics; audit case-insensitive resolution for symlink/TOCTOU issues in lab.
- Treat `C:\registry.hiv`, `_z_write`, and save dirs as integrity-sensitive; ACL and back up.
- Any bypass proof requires 3-gate lab testing; none claimed here.
