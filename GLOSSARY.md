# Glossary (Dev Mode / UWP / Porting / Security)

| Term | Practical meaning | Scarlett Soufflé note |
|---|---|---|
| Dev Mode | Supported developer configuration on Xbox for deploying/testing apps. | Observed via WDP `DevMode=Universal Windows App Devkit`; not a jailbreak. |
| WDP (Windows Device Portal) | HTTPS management plane for dev kits. | Anonymous info leaks confirmed (SPY-012/014/015). |
| UWP | Universal Windows Platform app model/packaging. | Dev kits host UWP/dev tooling; exposure is management-plane risk. |
| Sideloading | Installing app packages outside normal store flow (authorized dev workflow). | Unauth mutation endpoints in dashboard raise integrity risk; destructive tests not executed. |
| Porting | Adapting software to run on target platform/runtime. | dev dashboard manifests/shims/compat labels observed; protect as sensitive build artifacts. |
| Auth bypass | Accessing capability without required auth. | SPY-002 control pairing, SPY-011 settings mutation, SPY-013 UPnP read-only SOAP query. |
| SSRF | Server-side request forgery; server makes attacker-influenced request. | SPY-007 confirmed with loopback fetch diff, no file written. |
| Info leak | Disclosure of sensitive/internal data. | SPY-003/004/010/012/014/015. |
| 3-gate proof | Baseline, attack, measurable diff; cleanup for state changes. | Required before promoting hypothesis to finding. |
| Jailbreak | Unauthorized persistent bypass of platform security boundaries. | **Not proven** here. Do not claim without direct evidence. |
| RCE | Remote code execution. | **Not proven** here. Control-plane/SSRF/config tamper proven, code exec not. |
| NO-GAIN / validation-only | Prove impact minimally; no persistence, no data theft, no destructive payload. | All tests followed this rule. |
