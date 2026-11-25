# Xbox dev-mode — kernel / hypervisor / bootrom / persistence verdict

_target 10.0.0.23 · Xbox Series S · SystemOS 26100.9662.amd64fre.xb_flt_2610ge.261104-2200_
_campaign `xbox-devmode` · scope `~/.redteam/xbox-devmode-scope.json` (expires 2026-12-25) · validation-only · NO-GAIN · no persistence installed_

## Verdict

| lane | result | why |
|---|---|---|
| **Bootrom** | **NOT REACHABLE** | The only public boot-ROM compromise (Bliss, Gaasedelen — RE//verse 2026) is North Bridge **voltage glitching**: physical, bench-level. No network path exists. |
| **Hypervisor** | **NOT REACHABLE** | The hypervisor exports no network interface. Port sweep (top-300 + curated debug/KD ranges) found only 22/445/2869/9127/11443; every debug port (730, 731, 4118, 27000-27005, 29800-29810, 50000) is filtered. |
| **Kernel (SystemOS LPE)** | **PATCHED** | This build is 26100.9662. Collateral Damage (CVE-2024-30088) covers 25398.4478/4908/4909 only; Artifice was fixed at 10.0.26100.1968. Both are below this build. |
| **Unauthenticated RCE** | **NONE FOUND** | SMBv1/MS17-010 absent (SPY-001). WDP mutations all 403 (SPY-023). SSH requires auth. UPnP is SOAP query-only. |
| **Unsigned code exec** | **AUTHENTICATED ONLY** | WDP app-deploy + file upload are the sanctioned unsigned path and reject anonymous POSTs (403). The dashboard on 9127 can upload+launch, but only inside its own AppContainer. |
| **Persistence** | **PRIMITIVE EXISTS, AUTH-GATED, NOT INSTALLED** | Dev mode's `unattendedsetup-apply` boot script is the documented persistence primitive; anonymous POST → 403. No anonymous SMB write (share tree connect denied). |

## What this session actually proved (live, 2026-11-25)

- Build read live from `https://10.0.0.23:11443/api/os/info`: `26100.9662.amd64fre.xb_flt_2610ge.261104-2200`, `Xbox Series S`, `SystemOS`.
- **SPY-022 (high, new):** unauthenticated WDP **file content** read — `GET /api/filesystem/apps/file?knownfolderid=Documents&filename=desktop.ini` returned the 190-byte body. Prior finding SPY-018 only listed names; this is the bytes.
- **SPY-023 (info, new):** every WDP mutation endpoint (`packagemanager/package`, `filesystem/apps/file`, `os/restart`, `os/shutdown`, `devmode/unattendedsetup-apply`) returns **403** to an anonymous POST with `{}`. Clean, no side effects. Auth boundary holds.
- **DevelopmentFiles listing (deduped into SPY-018):** `knownfolderid=DevelopmentFiles` → `D:\DevelopmentFiles\` with the Tiramisu package tree, unauthenticated. `CameraRoll` also 200. `SystemRoot`, `Windows`, `InstalledGames`, `Public`, `Temp` → 403 unsupported.
- **SPY-024 (medium, new):** SMB2 `Message signing enabled but not required` → NTLM relay lane technically open (T1557), but null session authenticates anonymously while all share trees return `ACCESS_DENIED` / `BAD_NETWORK_NAME`. No anonymous write.
- **SSH:** `OpenSSH_for_Windows_9.5`, methods `publickey,password,keyboard-interactive`. Dev-mode SSH uses the `DevToolsUser`/VS-pairing-PIN pairing — not brute-forced (wall).
- **SPY-025 / SPY-026 (info, new):** the patched-kernel and no-network-boot-surface cleared lanes, registered with the build string as evidence.

## The honest ceiling

From the LAN, on this build, there is **no unsigned, persistent, kernel-level path**. The remaining routes are all gated on something other than a remote bug:

1. **Operator credentials** — WDP username/password or SSH pairing PIN gives SystemOS admin (dev mode feature, not a vuln).
2. **Physical access** — bootrom glitching (Bliss) or eMMC/flash work.
3. **A fresh Windows sandbox escape** — the console is Windows 11 26100-based; a new AppContainer→SYSTEM LPE would be the only software lane, and that is research, not recon.
4. **The 9127 dashboard** — unauthenticated upload+launch (SPY-002/003/007/010/011) is real, but executes inside the Tiramisu UWP's AppContainer. It is a LAN-exposed control plane, not a console escape.

## Walls applied

- No persistence installed; the `unattendedsetup` primitive was probed for existence/auth only.
- No writes to any device: upload, deploy, delete, restart, shutdown were never invoked with a valid body.
- No credential brute force on SSH or SMB.
- No game dumping, no decryption, no third-party contact.
- Report regenerated from the signed ledger: `Scarlett Soufflé/xbox-devmode-kernel-hypervisor-report.md` (26 findings, 24 confirmed).

## Ledger hygiene note

The campaign still carries SPY-005/SPY-006 as `FALSE_POSITIVE` records whose assets are `http://127.0.0.1:8851` — out of the declared estate (10.0.0.23). They should be purged so the campaign's risk score reflects only the console.
