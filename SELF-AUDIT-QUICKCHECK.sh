#!/usr/bin/env bash
# Scarlett Soufflé — owner self-audit quick check (READ-ONLY)
# Use ONLY on systems you own or are explicitly authorized to assess.
# No mutation, no credentials, no brute force, no exploitation.

set -euo pipefail
TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "usage: $0 <xbox-ip>" >&2
  exit 2
fi

echo "== Scarlett Soufflé self-audit (read-only) =="
echo "target=$TARGET date=$(date -u +%FT%TZ)"
echo

check_http() {
  local url="$1"; local label="$2"
  local code size
  code=$(curl -ksS -m 8 -o /tmp/ss_audit_body -w '%{http_code}' "$url" || true)
  size=$(wc -c < /tmp/ss_audit_body 2>/dev/null || echo 0)
  printf '%-55s %s bytes=%s\n' "$label" "$code" "$size"
}

echo "[Tiramisu 9127]"
for p in / /api/status /games /api/settings /api/logs /api/list-files?game=hello /api/steam/library /api/qr.svg; do
  check_http "http://$TARGET:9127$p" "GET $p"
done

echo
echo "[Device Portal 11443]"
for p in / /api/os/info /api/os/machinename /api/os/devicefamily /ext/settings /ext/xbox/info /ext/user /api/networking/ipconfig /api/app/packagemanager/packages; do
  check_http "https://$TARGET:11443$p" "GET $p"
done

echo
echo "[UPnP 2869]"
check_http "http://$TARGET:2869/upnphost/udhisapi.dll?content=uuid:b0b712e4-7a75-436b-9373-b24e61bb0daa" "GET device xml"

echo
echo "Notes:"
echo "- 200 on sensitive endpoints means exposure; restrict to trusted network and require auth."
echo "- Redact ConsoleId/DeviceId/SerialNumber/cert expiry/email/gamertag/XboxUserId/UserId before sharing."
echo "- Do not run mutation tests without explicit authorization and rollback plan."
