# Redacted Response Key Snapshots (read-only)

Key/type snapshots from anonymous read-only GETs on declared estate `10.0.0.23`. Sensitive values redacted; types shown where useful. Captured 2026-11-25.

## `GET http://10.0.0.23:9127/api/status`
```json
{
  "running": "bool",
  "guest_running": "bool",
  "running_game": "str",
  "url": "str",
  "last_upload": "str",
  "last_error": "str",
  "launch_pending": "bool",
  "launch_name": "str",
  "last_launch_result": "str",
  "last_launch_name": "str",
  "autopilot_game": "str",
  "autopilot_attempt": "int",
  "autopilot_result": "str",
  "control_code": "[REDACTED]",
  "upload_done": "int",
  "upload_total": "int"
}
```
**Risk:** `control_code` exposed unauth (SPY-002).

## `GET http://10.0.0.23:9127/games` (first item shape)
```json
{
  "name": "str",
  "exe": "str",
  "appid": "str",
  "args": "str",
  "input": "str",
  "arch": "str",
  "compat": "str",
  "compat_ok": "bool",
  "exes": ["str"]
}
```

## `GET http://10.0.0.23:9127/api/settings`
```json
{
  "default_input": "str",
  "mouse_speed": "int",
  "wheel_speed": "int",
  "pad_vibration": "bool",
  "os_major": "int",
  "os_minor": "int",
  "os_build": "int",
  "win11_personality": "bool",
  "write_watch": "bool",
  "steam_auth": "bool",
  "show_qr": "bool",
  "log_lines": "int"
}
```

## `GET https://10.0.0.23:11443/api/os/info`
```json
{
  "ComputerName": "str",
  "Language": "str",
  "OsEdition": "str",
  "OsEditionId": "int",
  "OsVersion": "str",
  "Platform": "str"
}
```

## `GET https://10.0.0.23:11443/ext/xbox/info`
```json
{
  "OsVersion": "str",
  "DevMode": "str",
  "OsEdition": "str",
  "ConsoleType": "str",
  "ConsoleId": "[REDACTED]",
  "DeviceId": "[REDACTED]",
  "SerialNumber": "[REDACTED]",
  "DevkitCertificateExpirationTime": "[REDACTED]"
}
```

## `GET https://10.0.0.23:11443/ext/user`
```json
{
  "Users": [
    {
      "UserId": "[REDACTED]",
      "EmailAddress": "[REDACTED]",
      "AgeGroup": "str",
      "AutoSignIn": "bool",
      "Gamertag": "[REDACTED]",
      "XboxUserId": "[REDACTED]",
      "SignedIn": "bool"
    }
  ]
}
```

## `GET https://10.0.0.23:11443/api/os/devicefamily`
```json
{
  "DeviceType": "str"
}
```

## Handling
Keys/shapes are useful for defenders and authorized testers. Raw sensitive values must never be published.
