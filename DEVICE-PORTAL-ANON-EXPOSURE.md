# Windows Device Portal — Anonymous Exposure (redacted)

Read-only anonymous HTTPS GETs observed against `https://10.0.0.23:11443`. Sensitive identifiers redacted.

## 200 OK (anonymous)

| Endpoint | Observed fields/data | Risk |
|---|---|---|
| `/api/os/info` | ComputerName, Language, OsEdition, OsEditionId, OsVersion, Platform | fingerprinting |
| `/api/os/machinename` | ComputerName | fingerprinting |
| `/api/os/devicefamily` | `Windows.Xbox` | fingerprinting |
| `/ext/settings` | dev/power/audio/video/network/user settings; SandboxId, DefaultApp, AutoSignInUser presence | config/user presence leak |
| `/ext/xbox/info` | OsVersion, DevMode, OsEdition, ConsoleType; ConsoleId/DeviceId/SerialNumber/DevkitCertificateExpirationTime present (redacted) | device identity leak |
| `/ext/xboxlive/sandbox` | Sandbox XDKS.1 | environment fingerprinting |
| `/ext/user` | user count/profile fields; Email/Gamertag/XboxUserId/UserId redacted | PII/account leak |
| `/api/networking/ipconfig` | 4 adapters/config | network recon |
| `/api/app/packagemanager/packages` | 74 installed packages | software inventory |

## 404 / not anonymously exposed (observed)

`/api`, `/debug`, `/deploy`, `/header`, `/info`, `/resources`, `/ext/app`, `/ext/xboxlive`, `/ext/network`, `/ext/users`, `/ext/remoteaddress`, `/api/settings/developer`, `/ext/devices`

## Notes

- Do not brute-force or probe destructively. 
- Treat all WDP data as sensitive; redact before sharing.
- Restrict WDP to trusted networks/VPN/localhost.
