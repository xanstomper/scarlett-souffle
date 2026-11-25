# WDP Anonymous Field Dictionary (redacted)

Field-level map from read-only anonymous `GET` responses on `https://10.0.0.23:11443`. Values redacted where sensitive.

## `/api/os/info` (200)
| Field | Example/Type | Sensitivity |
|---|---|---|
| ComputerName | `XBOX` | low |
| Language | `en-US` | low |
| OsEdition | `SystemOS` | medium |
| OsEditionId | `192` | medium |
| OsVersion | `26100.9662.amd64fre.xb_flt_2610ge.261104-2200` | medium |
| Platform | `Xbox Series S` | medium |

## `/api/os/devicefamily` (200)
| Field | Value | Sensitivity |
|---|---|---|
| DeviceType | `Windows.Xbox` | low |

## `/ext/xbox/info` (200)
| Field | Value/Type | Sensitivity |
|---|---|---|
| OsVersion | `10.0.26100.9662 (xb_flt_2610ge.261104-2200)` | medium |
| DevMode | `Universal Windows App Devkit` | medium |
| OsEdition | `October 2026` | medium |
| ConsoleType | `Lockhart` | medium |
| ConsoleId | `[REDACTED]` | high |
| DeviceId | `[REDACTED]` | high |
| SerialNumber | `[REDACTED]` | high |
| DevkitCertificateExpirationTime | `[REDACTED]` | high |

## `/ext/user` (200)
| Field | Example/Type | Sensitivity |
|---|---|---|
| Users[].UserId | `[REDACTED]` | high |
| Users[].EmailAddress | `[REDACTED]` | high |
| Users[].Gamertag | `[REDACTED]` | high |
| Users[].XboxUserId | `[REDACTED]` | high |
| Users[].AgeGroup | `Adult` | medium |
| Users[].AutoSignIn | `false` | medium |
| Users[].SignedIn | `true` | medium |

## `/ext/settings` (200, highlights)
| Field | Example | Sensitivity |
|---|---|---|
| SandboxId | `XDKS.1` | medium |
| DefaultApp | `Dev Home` | medium |
| DefaultUWPContentTypeToGame | `true` | medium |
| AllowXboxAppConnections | `true` | medium |
| AutoAcceptConsentPrompts | `true` | medium |
| AutoSignInUser options | includes configured user identifier `[REDACTED]` | high |
| PowerMode | `Energy Saving` | low |
| TVResolution | `1080p` | low |
| Network/Audio/Video settings | various | low/medium |

## `/api/networking/ipconfig` (200)
- 4 adapters; fields include adapter descriptions, DNS/DHCP/IP config. Treat as network recon; redact before sharing externally.

## `/api/app/packagemanager/packages` (200)
- 74 installed packages; includes package names/metadata. Treat as software inventory; redact as needed.

## Handling rule
Never publish raw ConsoleId/DeviceId/SerialNumber/Devkit cert expiry, email, gamertag, XboxUserId, or user tokens. Keep raw captures local and access-controlled.
