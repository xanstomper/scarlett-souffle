# Endpoint Inventory (observed, read-only unless noted)

## 10.0.0.23:9127 — dev dashboard Dashboard (HTTP, CORS *)
| Endpoint | Method(s) observed | Auth | Notes |
|---|---|---|---|
| `/` | GET | none | Dashboard HTML |
| `/api/status` | GET | none | Leaks `control_code` PIN, running game, upload/error state (SPY-002/004) |
| `/games` | GET | none | Game inventory/compat/exe/appid/args |
| `/api/settings` | GET, POST | none | POST mutation CONFIRMED reversible (SPY-011) |
| `/api/logs` | GET | none | Live guest logs |
| `/api/steam/status` | GET | none | Steam sign-in state |
| `/api/steam/library` | GET | none | Installed titles/appids |
| `/api/qr.svg` | GET | none | QR SVG |
| `/api/list-files?game=` | GET | none | File manifest+sizes disclosure (SPY-010) |
| `/api/cover/<name>` | GET, PUT | none | GET observed; PUT not tested |
| `/api/backup-saves` | GET | none | ZIP export (SPY-003) |
| `/api/debug-bundle` | GET | none | ZIP export (SPY-003) |
| `/controls` | GET | none | Control UI, reveals pair/input/leave API names |
| `/api/controls/pair` | POST | PIN in body | Pairing returns Bearer token (SPY-002), revoked after proof |
| `/api/controls/input` | POST | Bearer | Not exercised |
| `/api/controls/leave` | POST | Bearer | Used for revocation |
| `/api/download-url` | POST | none | SSRF CONFIRMED (SPY-007) |
| `/api/stop` | POST | none | Code-reviewed; not tested |
| `/api/rescan` | POST | none | Code-reviewed; not tested |
| `/api/game/<n>` DELETE | DELETE/POST | none | Code-reviewed; destructive not tested |
| `/api/config/<n>` | POST | none | Code-reviewed; not tested |
| `/api/launch/<n>` | POST | none | Code-reviewed; not tested |
| `/api/upload-file` | PUT/POST | none | Code-reviewed; not tested |
| `/upload/<name>.zip` | PUT/POST | none | Code-reviewed; not tested |
| `/api/upload-complete` | POST | none | Code-reviewed; not tested |
| `/api/restore-saves` | POST/PUT | none | Code-reviewed; not tested |
| `/api/steam/qr/refresh/signout/download` | POST | none | Code-reviewed; not tested |

## 10.0.0.23:11443 — Windows Device Portal (HTTPS TLS 1.3, CORS *)
| Endpoint | Method | Auth observed | Notes |
|---|---|---|---|
| `/` | GET | anonymous 200 | WDP HTML |
| `/api/os/info` | GET | anonymous 200 | OS/platform/sandbox leak (SPY-012) |
| `/api/os/machinename` | GET | anonymous 200 | ComputerName |
| `/api/os/devicefamily` | GET | anonymous 200 | `Windows.Xbox` |
| `/ext/settings` | GET | anonymous 200 | Dev settings, user identifier presence redacted (SPY-012) |
| `/ext/xbox/info` | GET | anonymous 200 | OsVersion/DevMode/ConsoleType + device IDs redacted (SPY-014) |
| `/api/networking/ipconfig` | GET | anonymous 200 | 4 adapters (SPY-014) |
| `/api/app/packagemanager/packages` | GET | anonymous 200 | 74 installed packages (SPY-014) |
| `/api`, `/debug`, `/deploy`, `/header`, `/info`, `/resources` | GET | 404 | Not exposed anonymously |
| `/ext/app`, `/ext/xboxlive`, `/ext/network`, `/ext/users`, `/ext/remoteaddress`, `/api/settings/developer`, `/ext/devices` | GET | 404 | Not exposed anonymously |

## 10.0.0.23:2869/1900 — UPnP DeviceHost
| Endpoint | Proto | Auth | Notes |
|---|---|---|---|
| `1900/udp` SSDP | UDP | none | upnp-info exposed server/location |
| `/upnphost/udhisapi.dll?content=uuid:...` | HTTP GET | none | Device/SCPD XML (SPY-008) |
| RenderingControl controlURL | SOAP POST | none | GetVolume/GetMute responded (SPY-013); SetVolume/SetMute not invoked |
| AVTransport controlURL | SOAP POST | none | GetTransportInfo responded; SetAVTransportURI/Play/Stop not invoked |
| eventSubURL | HTTP | unknown | Not tested |

## 10.0.0.23:22,445
- SSH: OpenSSH for Windows 9.5, password+keyboard-interactive+pubkey, modern algos. No creds.
- SMB: SMB2/3 only, SMBv1 absent, MS17-010 not detected, anonymous login allowed, no shares, SAMR/SRVSVC denied.
