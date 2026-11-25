# Dev Community FAQ (evidence-grounded)

Short answers for Xbox Dev Mode / UWP / porting / exploit-research discussions. Grounded in Scarlett Soufflé observed evidence; not speculation.

## Is Dev Mode the same as a jailbreak?
**No.** Dev Mode is a supported developer feature. This assessment confirmed management-plane exposures (unauth control pairing, info leaks, SSRF, config mutation, UPnP read-only SOAP queries) but **no** kernel/hypervisor/bootrom escape, no persistent unsigned retail jailbreak, and no platform-security bypass proof.

## What's the most serious confirmed issue here?
**SPY-002 (HIGH 8.0):** unauth Tiramisu `/api/status` leaked `control_code`; unauth `/api/controls/pair` issued a Bearer token; token was revoked after proof. No input injected. This is a control-plane auth failure.

## Is the Tiramisu dashboard safe on a LAN?
**Not by default in this observed state.** Unauth reads exposed status/games/settings/logs/file manifests/QR/steam state/backup-debug exports. Source review showed unauth mutation handlers for config/launch/upload/restore/delete/stop/rescan. Only safe reversible proofs were performed (settings toggle); destructive endpoints not tested.

## Did you prove remote code execution?
**No.** We proved control-plane credential issuance, SSRF, config mutation, and multiple info leaks. We did **not** execute arbitrary code, did not inject control input, and did not launch/upload/delete/restore through mutation endpoints.

## Is Windows Device Portal harmless if "it's just dev mode"?
**No.** Anonymous read-only WDP endpoints leaked OS/platform/build/sandbox, dev settings, user presence/profile fields (redacted), device identifiers (redacted), network config, and installed package inventory. Treat WDP as admin plane.

## Is UPnP/DLNA just media convenience?
**It is attack surface.** Device description/SCPDs were exposed unauth; read-only SOAP GetVolume/GetMute/GetTransportInfo succeeded unauth. Mutating actions (SetAVTransportURI/Play/SetVolume/SetMute) were **not** invoked.

## Can path sanitization make an unauth dashboard safe?
**No.** Path sanitization helps against traversal, but missing auth on mutation endpoints still allows integrity compromise. Both controls are needed.

## What should devs do first?
1. Firewall/isolate 9127/11443/2869/1900 to trusted network.
2. Add auth+CSRF to all mutation/control endpoints; remove PIN/token from unauth status.
3. Disable CORS `*`; restrict origins.
4. Block SSRF to loopback/private/link-local/metadata.
5. Redact secrets/PII from debug/save exports.

## What should exploit researchers do responsibly?
Use owned hardware, isolated lab, reversible proofs, no persistence/gain, no third-party pivot, no raw identifier dumps. Promote hypotheses to findings only with 3-gate evidence.
