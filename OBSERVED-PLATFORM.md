# Observed Platform (anonymous, read-only)

> Sensitive identifiers (ConsoleId, DeviceId, SerialNumber, Devkit cert expiry, Email/Gamertag/XboxUserId/UserId) redacted.

## Device Portal `/api/os/info`
- `ComputerName`: `XBOX`
- `Language`: `en-US`
- `OsEdition`: `SystemOS`
- `OsEditionId`: `192`
- `OsVersion`: `26100.9662.amd64fre.xb_flt_2610ge.261104-2200`
- `Platform`: `Xbox Series S`

## Device Portal `/ext/xbox/info`
- `OsVersion`: `10.0.26100.9662 (xb_flt_2610ge.261104-2200)`
- `DevMode`: `Universal Windows App Devkit`
- `OsEdition`: `October 2026`
- `ConsoleType`: `Lockhart`
- Device identifiers: present, redacted

## Device Portal `/ext/settings` highlights
- `SandboxId`: `XDKS.1`
- `DefaultApp`: `Dev Home`
- `DefaultUWPContentTypeToGame`: `true`
- `AutoAcceptConsentPrompts`: `true`
- `AllowXboxAppConnections`: `true`
- `PreferredLanguages`: `en-US`
- `AutoSignInUser`: configured user presence (identifier redacted)

## Device Portal `/ext/user` (redacted)
- 1 user, `SignedIn=true`, `AgeGroup=Adult`, `AutoSignIn=false`; identifiers redacted.

## UPnP / network services
- `1900/udp` SSDP open; `2869/tcp` UPnP DeviceHost.
- Device XML: `MediaRenderer:1`, `friendlyName XBOX`, `modelName Xbox One`, `manufacturer Microsoft Corporation`, `X_hardwareId VEN_0125&DEV_0002&REV_0001`.
- TLS 11443: `TLSv1.3 TLS_AES_256_GCM_SHA384`, issuer `CN=Microsoft Windows Web Management (Test) (XBOX)`.

## dev dashboard runtime observed
- `http://10.0.0.23:9127` dashboard up; games include x64 D3D11 Ready, x64 Windows Ready, x86 32-bit (JIT) compat labels.
- Per-game `.dev dashboard` manifests/profiles/shims/import mappings observed via unauth list-files.
