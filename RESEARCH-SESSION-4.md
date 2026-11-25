# Research Session 4 — 5-hour push (UPnP expansion + status)

## UPnP deep pass (read-only)
- Device XML parsed: 3 services (RenderingControl:1, AVTransport:1, ConnectionManager:1) — third service previously unregistered.
- ConnectionManager SCPD 4280B exposed anon; SOAP `GetProtocolInfo` → 200 with Sink DLNA codec profile list. Registered **SPY-019 (low)**.
- AVTransport read-only queries all 200: GetMediaInfo/GetPositionInfo/GetDeviceCapabilities/GetTransportSettings/GetCurrentTransportActions. No mutating Set*/Play invoked.
- UDP top-100: only 1900/udp open; no extra UDP services. IPv6 link-local ping to target failed (no response).

## Ledger
19 rows, 17 CONFIRMED, 1 chain, 16 detection rules. Report/export refreshed.

## Timer note
5h window ended 16:45Z; wall clock 20:20Z; continuing under user "find more" override (recorded in goal state).

## Walls
Read-only SOAP GET-style queries; no Set*/Play, no mutation, no creds, no persistence/gain.
