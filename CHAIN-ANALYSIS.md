# Chain Analysis (evidence-grounded)

All chains below are grounded in confirmed findings. Steps marked **not executed** were not performed.

## Chain A — Unauth console control plane (CONFIRMED to pairing)
1. **SPY-004/002:** Anonymous GET `/api/status` leaks `control_code` PIN.  
2. **SPY-002:** Anonymous POST `/api/controls/pair` with PIN returns Bearer token.  
3. **SPY-002:** POST `/api/controls/leave` revokes token (confirmed).  
4. **Not executed:** POST `/api/controls/input` with Bearer to inject keystrokes/mouse. High impact but state-changing; requires explicit authorization.

**Impact:** LAN attacker can obtain control session credential without auth. Full input injection not proven here, but API surface and token issuance are proven.

## Chain B — Unauth content/config tamper (PARTIALLY CONFIRMED)
1. **SPY-011:** Anonymous POST `/api/settings` mutates settings (reversible proof).  
2. **Code-reviewed, not tested:** `/api/config/<n>`, `/api/launch/<n>`, `/api/upload-file`, `/upload/<name>.zip`, `/api/upload-complete`, `/api/restore-saves`, `/api/delete/<n>`, `/api/game/<n>` DELETE, `/api/stop`, `/api/rescan`.  
3. **SPY-007:** `/api/download-url` SSRF confirmed (console fetch primitive).

**Impact:** Dev content integrity and runtime state at risk on untrusted LAN. Destructive tests intentionally not executed.

## Chain C — Recon to targeted attack planning (CONFIRMED)
1. **SPY-012/014:** WDP leaks OS build/platform/sandbox/dev mode, device identifiers (redacted), network config, 74 installed packages.  
2. **SPY-010/004/003:** Tiramisu leaks file manifests, game inventory, logs, settings, save/debug exports.  
3. **SPY-008/013:** UPnP exposes device metadata/SCPDs and accepts read-only SOAP queries unauth.

**Impact:** Lowers attacker uncertainty; enables targeted exploit development in lab. No social engineering/third-party action taken.

## Chain D — SSRF primitive (CONFIRMED, limited)
1. **SPY-007:** Console fetches arbitrary http(s) URL.  
2. **Observed:** loopback probes to 1/22/10080 returned connection-failure style errors; 9127 self returned HTTP 404.  
3. **Not executed:** broader internal mapping, credentialed internal service interaction, file-write via fetch target behavior beyond observed no-write case.

**Impact:** Confirmed SSRF primitive; escalation potential requires lab/explicit authorization.

## Defensive priority
1. Auth+CSRF on all 9127 mutation/control endpoints; remove PIN from status.  
2. Restrict WDP/UPnP/Tiramisu to trusted network/localhost.  
3. Disable CORS wildcard.  
4. Treat dev kits as admin assets, isolated VLAN.
