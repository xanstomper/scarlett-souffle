# Quick Command Card (Owner/Operator, Read-Only)

Run only against systems you own/are authorized to assess. **Read-only only** — no POST/PUT/DELETE mutation, no creds, no brute force.

## Tiramisu (9127)
```bash
curl -s http://$XBOX:9127/api/status | jq .
curl -s http://$XBOX:9127/games | jq .
curl -s http://$XBOX:9127/api/settings | jq .
curl -s http://$XBOX:9127/api/list-files?game=hello | jq .
curl -I http://$XBOX:9127/api/qr.svg
```
**Watch for:** `control_code` in status, unauth 200 on sensitive endpoints, CORS `*`.

## Windows Device Portal (11443)
```bash
curl -sk https://$XBOX:11443/api/os/info | jq .
curl -sk https://$XBOX:11443/api/os/devicefamily | jq .
curl -sk https://$XBOX:11443/ext/settings | jq .    # redact user identifiers
curl -sk https://$XBOX:11443/ext/xbox/info | jq .   # redact ConsoleId/DeviceId/SerialNumber/cert
curl -sk https://$XBOX:11443/ext/user | jq .        # redact Email/Gamertag/XboxUserId/UserId
```

## UPnP (2869/1900)
```bash
sudo nmap -sU -Pn -n -p 1900 --script upnp-info $XBOX
curl -s http://$XBOX:2869/upnphost/udhisapi.dll?content=uuid:<UUID> | head
```
**Do not** send mutating SOAP actions (SetAVTransportURI/SetVolume/Play) without explicit authorization.

## SMB/SSH
```bash
nmap -sV -Pn -n -p 22,445 --script smb-protocols $XBOX
```

## Redact before sharing
ConsoleId, DeviceId, SerialNumber, DevkitCertificateExpirationTime, EmailAddress, Gamertag, XboxUserId, UserId, tokens, control_code/session values.
