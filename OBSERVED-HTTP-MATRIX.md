# Observed HTTP Response Matrix (redacted)

Read-only observations from Scarlett Soufflé campaign against declared estate `10.0.0.23`. Sensitive values redacted.

## dev dashboard `http://10.0.0.23:9127`
| Endpoint | Method | Auth | Observed | Notes |
|---|---|---|---:|---|
| `/api/status` | GET | none | 200 | Leaks `control_code`, running game, upload/error state |
| `/games` | GET | none | 200 | Inventory/compat/args metadata |
| `/api/settings` | GET | none | 200 | OS/mode settings exposed |
| `/api/settings` | POST | none | 200 | Reversible `show_qr` toggle confirmed (SPY-011) |
| `/api/logs` | GET | none | 200 | Live guest logs |
| `/api/steam/status` | GET | none | 200 | Steam state |
| `/api/steam/library` | GET | none | 200 | Installed titles/appids |
| `/api/qr.svg` | GET | none | 200 | SVG, CORS * |
| `/api/list-files?game=hello` | GET | none | 200 | File manifest disclosure (SPY-010) |
| `/api/backup-saves` | GET | none | 200 | ZIP export (SPY-003) |
| `/api/debug-bundle` | GET | none | 200 | ZIP export (SPY-003) |
| `/api/controls/pair` | POST | PIN body | 200 | Returned Bearer token (SPY-002), revoked |
| `/api/download-url` | POST | none | 202 | SSRF accepted (SPY-007) |

## Windows Device Portal `https://10.0.0.23:11443`
| Endpoint | Method | Auth | Observed | Notes |
|---|---|---|---:|---|
| `/` | GET | anon | 200 | WDP HTML |
| `/api/os/info` | GET | anon | 200 | OS/platform/sandbox leak (SPY-012) |
| `/api/os/machinename` | GET | anon | 200 | ComputerName |
| `/api/os/devicefamily` | GET | anon | 200 | `Windows.Xbox` |
| `/ext/settings` | GET | anon | 200 | Dev settings, user presence (SPY-012) |
| `/ext/xbox/info` | GET | anon | 200 | Device identifiers redacted (SPY-014) |
| `/ext/user` | GET | anon | 200 | User fields redacted (SPY-015) |
| `/api/networking/ipconfig` | GET | anon | 200 | 4 adapters (SPY-014) |
| `/api/app/packagemanager/packages` | GET | anon | 200 | 74 packages (SPY-014) |
| `/ext/xboxlive/sandbox` | GET | anon | 200 | `XDKS.1` |
| `/api/os/devicefamily` | GET | anon | 200 | confirmed |
| `/api`, `/debug`, `/deploy`, `/ext/app` | GET | anon | 404 | not exposed anonymously |

## UPnP `10.0.0.23:2869/1900`
| Endpoint | Method | Observed | Notes |
|---|---|---:|---|
| `1900/udp` SSDP | UDP | open | upnp-info exposed |
| device XML `udhisapi.dll?content=...` | GET | 200 | MediaRenderer XBOX metadata |
| RenderingControl controlURL | GET | 405 | Allow: POST, M-POST |
| RenderingControl GetVolume | SOAP POST | 200 | `CurrentVolume=100` (SPY-013) |
| RenderingControl GetMute | SOAP POST | 200 | `CurrentMute=0` |
| AVTransport GetTransportInfo | SOAP POST | 200 | `NO_MEDIA_PRESENT/OK` |
