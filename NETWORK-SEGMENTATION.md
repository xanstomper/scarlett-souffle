# Dev Kit Network Segmentation (evidence-grounded)

Observed exposed services on declared estate `10.0.0.23` (read-only recon). Use this to segment dev kits away from untrusted LANs.

## Observed services

| Port/Proto | Service | Observed | Risk | Recommended boundary |
|---|---|---|---|---|
| 22/tcp | OpenSSH for Windows 9.5 | open | credentialed remote admin; brute-force target if exposed | mgmt VLAN only; key auth; disable if unused |
| 445/tcp | SMB2/3 (no SMBv1) | open | lateral movement/file exposure if misconfigured | mgmt VLAN only; block from user/Wi-Fi |
| 2869/tcp | UPnP DeviceHost / HTTPAPI | open | unauth device/SCPD/control query exposure (SPY-008/013) | block from untrusted LAN; disable SSDP/UPnP if unused |
| 1900/udp | SSDP/UPnP | open | discovery/amplification/control surface | block multicast/UDP 1900 from untrusted segments |
| 9127/tcp | dev dashboard dashboard | open | unauth control/info leak/SSRF/mutation surface (SPY-002/003/004/007/010/011) | localhost or trusted mgmt only; require auth+CSRF |
| 11443/tcp | Windows Device Portal HTTPS | open | unauth info/device/user/package leaks (SPY-009/012/014/015) | mgmt VLAN/VPN only; require auth |

## Segmentation baseline
- **Dev kit VLAN:** console + authorized dev workstation + required build/deploy hosts only.
- **Block by default:** user Wi-Fi, guest, IoT, untrusted lab peers.
- **Egress:** allow only required update/package endpoints; apply SSRF/egress controls on dashboard hosts.
- **Monitoring:** alert on new listeners, UPnP SOAP POSTs, WDP anonymous 200s, dev dashboard `/api/controls/pair`, `/api/download-url`.

## Quick firewall intent (example)
- Allow 22/11443/9127 from dev admin subnet only.
- Deny 2869/1900 from non-mgmt subnets.
- Deny 445 from non-mgmt subnets unless explicitly needed.

*Adjust for your environment; do not expose dev kits to public or shared networks.*
