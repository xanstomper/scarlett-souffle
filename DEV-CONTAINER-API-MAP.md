# Dev Container API Surface Map (read-only static review)

Source: `src/guest/*.def` export lists in local Tiramisu tree. Maps the Win32 emulation boundary exposed to guest games on the UWP host — useful for porting/devs and for documenting container-escape hypotheses (none proven).

## Shims present by module (exports)

| Module | Exports (abridged) | Porting role |
|---|---|---|
| `kernel32.def` | HeapAlloc, CreateFileW, WriteFile, LoadLibraryW, GetProcAddress, VirtualProtect, RtlCaptureContext, CreateProcessW, job-object APIs | Core Win32 file/memory/module boundary; CreateProcessW is fail-visible (blocked children) |
| `ntdll.def` | NtCreateFile, NtReadFile, NtWriteFile, NtClose, NtCreateEvent, RtlGetVersion | Native API boundary; own-file round trips |
| `advapi32.def` | RegOpenKeyExW, RegQueryValueExW, RegCreateKeyExW, OpenProcessToken, GetTokenInformation, ConvertStringSecurityDescriptorToSecurityDescriptorW | Registry + token/sid emulation |
| `shell32.def` | SHGetFolderPathW/A, SHGetKnownFolderPath, ShellExecuteExW, ShellExecuteW | Shell paths; ShellExecute fail-visible |
| `crypt32.def` | CertOpenSystemStoreW/A, CertOpenStore, CertGetCertificateChain, CertVerifyCertificateChainPolicy | No cert store on console (open verbs NULL) |
| `iphlpapi.def` | GetAdaptersInfo, GetAdaptersAddresses, GetIfTable, IcmpCreateFile/SendEcho | Network info emulation |
| `psapi.def` | K32EnumProcessModules, EnumProcesses, GetProcessMemoryInfo | Process enumeration shim |
| `dbghelp.def` | SymInitialize, SymFromAddr, MiniDumpWriteModule | Debug symbol/minidump boundary |
| `api-ms-win-core-synch-l1-2-0.def` | WaitOnAddress, WakeByAddress(All) | Synchronization via GetProcAddress fallback |
| `d3d9/ddraw/d3d8/dxgi/d3d12.def` | Direct3DCreate9/Ex, DirectDrawCreate*, CreateDXGIFactory*, D3D12CreateDevice | Graphics emulation |
| `d3dx9/d3dcompiler_47.def` | D3DX math/texture helpers, D3DCompile | Shader/assets helpers |
| `opengl32/openal32.def` | wgl*/gl*, alc*/al* | GL/audio translation layers |
| `dsound/msacm/msvfw.def` | DirectSound*, acmStream*, ICOpen | Audio/video codec shims |
| `ole32/oleaut32/comctl32/imm32/gdi32.def` | COM init, BSTR, common controls, IME, GDI primitives | General Windows subsystem shims |
| `api-ms-win-core-winrt-l1-1-0.def` | WindowsCreateString, WindowsDeleteString | WinRT string boundary |
| `guest_lib32.def` / `guest_delay32.def` | Lib32Add, Delay32Fn | Test/delay helpers |

## Boundary notes (documented, not exploited)
- **Fail-visible blocks:** `CreateProcessW`, `ShellExecuteExW` expected to fail (console blocks children/shell). These are container boundaries, not proven escapes.
- **Emulation gaps:** crypt32 no cert store; registry via host hive (`C:\registry.hiv`); GetProcAddress fallback to kernel32/api-sets.
- **Porting guidance:** preserve fail-visible thunks; validate path canonicalization in CreateFileW/ntdll bridges; document which APIs are shimmed vs blocked for each game.
- **Research:** container-escape/jailbreak vectors remain hypotheses (`KNOWN-UNPROVEN-HYPOTHESES.md`); no bypass proven.

## Walls
Static review only. No game dumping, no decryption of protected content, no persistence, no third-party contact.
