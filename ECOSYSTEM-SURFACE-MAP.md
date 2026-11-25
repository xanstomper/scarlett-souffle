# Ecosystem Surface Map — Xbox dev-mode estate `10.0.0.23`

_2026-11-25 · Series S · SystemOS `26100.9662.amd64fre.xb_flt_2610ge.261104-2200` · read-only probes unless noted_
_scope: declared estate only · validation-only · no persistence · no credential guessing_

This is the widest map of the estate so far: every listener, every WDP endpoint that answered, the 9127 dashboard's
route table with its real auth posture, the UPnP device tree, TLS/SSH/SMB posture, and the dev-settings inventory.
Identifiers (console id, serial, UUID, e-mail, control code) are redacted by policy.

## 1. Listening services

| port | proto | service | auth on observation | notes |
|---|---|---|---|---|
| 22 | TCP | `OpenSSH_for_Windows_9.5` | publickey, password, keyboard-interactive | no anonymous path; host key rotated since a prior session |
| 445 | TCP | SMB2 | null session authenticates, all trees `ACCESS_DENIED` | signing **enabled, not required** → relay lane (SPY-024) |
| 2869 | TCP | UPnP Device Host 1.0 | none | MediaRenderer control surface (SPY-013, SPY-031) |
| 9127 | TCP | Tiramisu LAN dashboard | **none on reads/launch/upload**; 401 only on `/api/controls/*` | SPY-028/029/030 |
| 11443 | TCP | Windows Device Portal (WDP) | **none on read endpoints** | SPY-012/014/015/018/022/033 |
| 1900 | UDP | SSDP | none | root device + 3 services advertised |
| 5353/3702/… | UDP | not observed | — | top-20 UDP scan found nothing else open |
| 730, 731, 4118, 27000-05, 29800-10, 50000 | TCP | debug / KD | **filtered** | no kernel debug surface reachable |

## 2. WDP `11443` — unauthenticated endpoint map

**Answers 200 anonymously**

| endpoint | body | leaks |
|---|---|---|
| `/api/os/info` | 187B | build, edition `SystemOS`, console type, language |
| `/api/os/machinename` | 25B | `ComputerName` |
| `/api/os/devicefamily` | 31B | `Windows.Xbox` |
| `/api/networking/ipconfig` | 1,894B | adapters, MACs, DNS/DHCP state |
| `/api/app/packagemanager/packages` | 50,466B | 75 packages, versions, publishers, registered users |
| `/api/app/packagemanager/state` | 110B | deployment state |
| `/api/power/state` | 34B | low-power capability |
| `/ext/settings` | 10,493B | 39 settings incl. sandbox, hostname, boot/sign-in |
| `/ext/user` | 182B | account presence + profile fields (PII, redacted) |
| `/ext/xbox/info` | 310B | OS version, dev-mode state, sandbox |
| `/ext/screenshot` | ~2.1MB | **live 1920×1080 screen capture** (SPY-033) |
| `/api/filesystem/apps/files` | varies | known-folder + per-package listings |
| `/api/filesystem/apps/file` | varies | **file contents** (SPY-022) |

**Answers 404** (route absent on this build; recorded so the map is bounded):
`/api/os/{machineinfo,battery,powerstate,processperformance,settings,format,reboot}`,
`/api/networking/{wifiinterfaces,wifiprofiles}`, `/api/resource/*`, `/api/tasks*`,
`/api/controls/{reboot,shutdown,restart}`, `/api/etw/*`, `/api/user`, `/api/devmode/*`,
`/ext/{smb,smbdrivemapping,network/*,wifi/*,device/*,errorreport/*,fiddler/*,httpmonitor/*,perf/*,remoteinput/*,rendering/*,usb/*,xboxlive/*,devmode/*}`.

**Answers 400** (route exists, parameter required): `/api/filesystem/apps/{files,file}` without `knownfolderid`.

**Anonymous writes** → 403 on every mutation tried: `packagemanager/package`, `filesystem/apps/file`,
`os/restart`, `os/shutdown`, `controls/reboot`, `devmode/unattendedsetup-apply`, `filesystem` DELETE (SPY-023).

### Known-folder matrix

| folder id | anonymous | note |
|---|---|---|
| Documents, Downloads, Pictures, Music, Videos | 200 | browsable, contents readable |
| DevelopmentFiles | 200 | the porting/game tree |
| CameraRoll | 200 | captures |
| SystemRoot, Windows, InstalledGames, Public, Temp | 403 | unsupported by the endpoint |
| LocalAppData | 200 **with `packagefullname`** | private package state; system packages refused, **developer packages not** (SPY-022) |

## 3. Tiramisu dashboard `9127` — route table and auth

| route | method | auth | observed |
|---|---|---|---|
| `/` | GET | none | 23,355B dashboard UI |
| `/games` | GET | none | game name, exe, appid, arch, compat |
| `/api/status` | GET | none | running state **+ live `control_code`** (SPY-028) |
| `/api/logs` | GET | none | 16,367B host launcher log, guest handle/park internals |
| `/api/list-files?game=` | GET | none | 62,166B / 813 files with sizes, incl. `.tiramisu/profile.json` |
| `/api/settings` | GET | none | input/OS settings |
| `/api/steam/{status,library}` | GET | none | Steam link state + library |
| `/api/qr.svg` | GET | none | 4,346B SVG QR (Steam sign-in) |
| `/api/steam/qr.svg` | GET | none | same class |
| `/api/controls/pair`, `/api/controls/leave` | POST | **401** | the only gated routes |
| `/api/launch/<name>` | POST | **none** | 404 on unknown name proves handler executes (SPY-030) |
| `/api/upload-file?game=&rel=` | POST | **none** | 200 `{"ok":true,"size":0}` on a zero-byte body (SPY-030) |
| `/api/upload-complete`, `/api/download-url` | POST | none | URL fetch → guest (SPY-007 class) |
| `/api/{stop,rescan}`, `/api/delete/*`, `/api/config/*`, `/api/settings` | POST | none | state-changing; not exercised |
| `/api/backup-saves`, `/api/debug-bundle` | GET | none | **build a zip of `drive_c`+`profiles`+`settings.ini` and serve it** (SPY-003 class) |

Source cross-check (`tiramisu/src/host/webxfer.cpp`): `sanitize_rel_path()` rejects `..`, `:` and control
characters, `sanitize_game_name()` bounds the game segment, and only `handle_controls()` inspects
`Authorization`. Traversal probes against WDP and the dashboard both returned 400.

## 4. UPnP / SSDP

```
M-SEARCH → 200 OK ×4          rootdevice, MediaRenderer:1, AVTransport:1, RenderingControl:1
Server: Microsoft-Windows/10.0 UPnP/1.0 UPnP-Device-Host/1.0
device:  MediaRenderer:1 · friendlyName "XBOX" · manufacturer Microsoft · modelName "Xbox One"
UDN:     uuid:<redacted>
services: RenderingControl · AVTransport · ConnectionManager  (all on /upnphost/udhisapi.dll)
```

- Read-only SOAP (`GetVolume`, `GetMute`, `GetTransportInfo`) works anonymously — SPY-013.
- **`SetAVTransportURI` returns a valid response envelope anonymously** — state-changing renderer control,
  not just queries (SPY-031). No media was set.
- `serialNumber` is absent from the description; the UDN is the stable device handle.

## 5. TLS / SSH / SMB posture

- **Cert:** `CN=10.0.0.23`, issuer `CN=Microsoft Windows Web Management (Test) (XBOX)` (self-signed test cert),
  SAN `DNS:XBOX, DNS:localhost, IP:10.0.0.23`, valid `2026-11-22 → 2029-11-21` (3-year test lifetime).
  A self-signed 3-year cert means no pinning and no revocation story: any LAN MITM is invisible to a browser.
- **SSH:** `OpenSSH_for_Windows_9.5`, methods `publickey,password,keyboard-interactive`.
- **SMB:** SMB2/3 negotiation, **signing enabled but not required** → NTLM relay lane open (SPY-024);
  anonymous session authenticates but every tree and SAMR call is `ACCESS_DENIED`.

## 6. Dev-settings inventory (names only, values withheld)

39 keys across `Audio, Identity, Localization, Network, Power, Preferences, User, Video`:

```
Allow4K AllowALLM AllowDolbyVision AllowDolbyVisionGaming AllowHDR AllowPassthrough AllowVRR
AllowXboxAppConnections AllowYCC AlwaysOn AutoAcceptConsentPrompts AutoBoot AutoSignInUser
AutoSignInUserControllerPairing ColorDepth ColorSpace CurrentPreferredLocalUDPMultiplayerPortState
DefaultApp DefaultUWPContentTypeToGame DesiredPreferredLocalUDPMultiplayerPort DimTimeout
DisplayConnection GeographicRegion HDMIAudio HeadlessXUser HeadsetFormat Hostname
IsHDAudioMutedWithHeadset MonoOutput MuteNavigations MuteNotifications OpticalAudio PowerMode
PreferredLanguages SandboxId ShutdownTimeout TVResolution TimeZone WirelessRadioSettings
```

`AutoBoot`, `AutoSignInUser`, `DefaultApp`, `SandboxId` and `WirelessRadioSettings` are the operator-relevant
ones: they describe the boot target, the auto-signed-in account and the sandbox identity of this console.

## 7. Chains that actually compose

1. **Read → watch (SPY-033 + SPY-022).** Any LAN host screenshots the console and reads developer-package state
   without credentials; the screenshot is live, so it is surveillance of whatever is on screen.
2. **Read the pairing secret → control (SPY-028).** `/api/status` publishes `control_code`; `/api/controls/*`
   only checks that code. Publishing the secret on the same unauthenticated interface reduces 401 to a formality.
   Not exercised: no pair session, no input injected.
3. **Drop → launch (SPY-030).** Anonymous `upload-file` writes into a game directory and anonymous
   `launch/<name>` runs that game. That is the unsigned-code primitive — still inside the guest, not SystemOS.
4. **Renderer hijack (SPY-031).** Anonymous `SetAVTransportURI` on a MediaRenderer is the classic DMR takeover;
   with a URL it is also a console-side fetch.

## 8. Fixes, in order of value

1. Bind WDP (11443) and the dashboard (9127) off the LAN, or require the WDP credentials the port already supports.
2. In the dashboard, require the control token for `/api/status` (drop `control_code`), `/api/logs`,
   `/api/list-files`, `/api/upload-file` and `/api/launch/*`; serve `/api/qr.svg` only post-auth.
3. Require SMB signing; disable the guest/anonymous SMB path used by dev mode when not transferring.
4. Block 2869/1900 from the LAN if the console is not being used as a media renderer.
5. Replace the WDP test cert with one you control if you ever expose 11443 beyond the LAN.

## 9. Session side effects (disclosed)

- A zero-byte `probe.txt` was written into `DevelopmentFiles/Cuphead/` to prove the anonymous upload path
  (SPY-030). It is 0 bytes and inert. WDP `DELETE` is 403 anonymously, so removing it needs the operator's
  credentials or the dashboard's own file manager.
- That same write triggered the dashboard's rescan/autopilot, which stopped the running guest (`Cuphead`).
  No game was launched afterwards.
- No persistence, no deploy, no restart, no input injection, no credential attempt, no data retained
  beyond the sizes, status codes and field names quoted here.
