# Crypto & Emulation Surface Map (read-only static review)

Source: local dev dashboard tree (`src/guest`, `src/host`, `src/trt`). Documentation for dev/UWP porting and authorized research. **No decryption of protected content, no game dumping, no key extraction performed** — NO-GAIN wall.

## Crypto / encryption surfaces (code-observed)

| Location | Observation | Dev relevance |
|---|---|---|
| `src/host/steam_client.cpp:457-500` | `bcrypt_aes256_decrypt_steam` — BCrypt AES-256 using ECB (key block) + CBC (body), 32-byte key, 16-byte IV | Steam depot/filename decryption implementation; review IV/key handling in lab |
| `src/host/steam_client.cpp:1255-1348` | Depot manifest `filenames_encrypted` flag; filename decrypt via same helper | Porting: encrypted filename support boundary |
| `src/host/steam_client.cpp:2137-2174` | Depot decryption key request (license proof) | Entitlement boundary; do not bypass |
| `src/host/steam_client.cpp:2321-2383` | Stream chunks: AES-decrypt, decompress, Adler-32 verify; manifest `sha` is CDN chunk id, not hash | Integrity model observation |
| `src/guest/guest_crypt32.c` | crypt32 bridge: no cert store on console; open verbs return NULL | UWP porting: cert-store absence must be handled by games |
| `src/host/settings.cpp` / `steam_client.cpp:181-212,1656-1694` | `steam.token` persists refresh/access tokens (JSON) | Secret-at-rest; protect with ACLs, redact from exports |

**No actual decryption executed.** These are implementation notes for defenders/porters.

## Emulation / UWP porting surface (code-observed)

| Location | Observation | Porting relevance |
|---|---|---|
| `src/trt/bridge_kernel32.cpp` | Large Win32->host bridge; `GetProcAddress` fallback for `WaitOnAddress/WakeByAddress`; CreateFileW/CreateFile2 handling incl. disc-image mounts and directory handles | Core of Win32 emulation on UWP host |
| `src/trt/bridge_kernel32.cpp:1739-1740` | "registry: UWP has none, games expect one" -> `trt_bridge_register_registry` | Registry shim boundary |
| `src/guest/guest_reg.c` | Guest exercises registry reads; missing key on fresh hive is normal | Porting: registry emulation needed |
| `src/guest/guest_libload.c` | `LoadLibraryW` + `GetProcAddress` round trip | DLL emulation boundary |
| `src/guest/kernel32.def`, `ntdll.def`, `shell32.def` | Def APIs (CreateProcessW, ShellExecuteExW, NtCreateFile, etc.) | Fail-visible thunks signal blocked classes |
| `src/guest/guest_ntdll.c` | NtCreateFile/NtWriteFile/NtReadFile round-trip on own file; `\\??\\C:\\` forms | Native API emulation boundary |
| `src/guest/guest_engine.c:169-189` | CreateProcessW must fail visibly (console blocks children) | Container child-process boundary |
| `src/guest/guest_shell.c:140-141` | ShellExecuteExW fails named | Shell escape boundary |

## Container/jailbreak-vector framing (documented, not proven)
- **Observed boundaries:** no host cert store, no child process/shell, registry/filesystem shims, limited host API exports (`dev dashboardHostQueryBuild/LogU32`), UWP app-container model.
- **Not proven:** no escape, no kernel/hypervisor bypass, no entitlement bypass, no persistence. Hypotheses are in `KNOWN-UNPROVEN-HYPOTHESES.md`.
- **Game dumping/value theft:** outside walls. This doc maps structure only; it does not extract or decrypt game content.

## Dev guidance
- Preserve fail-visible thunks; audit bridge path canonicalization and registry/file ACLs.
- Keep entitlement/decryption flows license-bound; do not ship dev keys.
- Treat debug bundles/logs as sensitive; Steam tokens and device IDs must be redacted.
