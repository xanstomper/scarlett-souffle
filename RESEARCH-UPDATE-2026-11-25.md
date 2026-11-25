# Research Update — 2026-11-25 (read-only, Tiramisu utilized for observation only)

## Live Tiramisu read-only observations (http://10.0.0.23:9127)
- `/api/status`: running_game=hermes, control_code=10825127, last_error="URL download failed" (SSRF probe residue), guest_running=true.
- `/games`: 7 entries (Celeste, Sekiro, hello, hermes, opencode, pylauncher, ultrapool) with exe/appid/args/input/arch/compat metadata.
- `/api/settings`: os_major=10 os_minor=0 os_build=19045, win11_personality=false, write_watch=true, steam_auth=true, show_qr=true.
- `/api/steam/library`: 3 installed titles exposed unauthenticated (Sekiro appid 480, hermes 3536730, ultrapool 4195110).
- `/api/steam/status`: signed_in=false, steamid64=0, status "press Y to sign in with Steam QR".
- `/api/qr.svg`: 200 image/svg+xml, 4346 bytes, unauthenticated, wildcard CORS.
- `/api/list-files?game=hello`: unauthenticated file manifest disclosure — returns `.tiramisu/*.json`, `guest_hello.exe` (3072B), `tiramisu.profile.ini` (255B) with sizes.
- `/api/cover/hello`: 200 image/jpeg 61610 bytes, unauthenticated.
- `/controls`: 200, exposes `/api/controls/input`, `/api/controls/leave`, `/api/controls/pair` in JS.

## UPnP/DeviceHost (10.0.0.23:2869, 1900/udp)
- Device XML: friendlyName XBOX, modelName Xbox One, manufacturer Microsoft Corporation, hardwareId VEN_0125&DEV_0002&REV_0001.
- SCPD exposed read-only: AVTransport (SetAVTransportURI/Play/Pause/Seek/Stop/Next/Previous/SetNextAVTransportURI/Get*), RenderingControl (Get/SetMute, Get/SetVolume 0-100, List/SelectPreset).

## Device Portal (https://10.0.0.23:11443)
- TLSv1.3 TLS_AES_256_GCM_SHA384, issuer CN=Microsoft Windows Web Management (Test) (XBOX), HTTP/2 200 "Windows Device Portal". Login-gated paths 404 from anonymous.

## Walls/notes
- Tiramisu used read-only only. No upload/launch/download/control-pair/input injection executed.
- SSRF/controls findings already registered in campaign ledger; this update is evidence enrichment.
