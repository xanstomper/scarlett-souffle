# Device Portal Tooling Map (static review of local dev tools)

Source: `tools/devportal.py`, `tools/deploy.sh` (local tree). Read-only. Documents the dev deployment surface useful to devs/porters. No creds used, no live mutation.

## WDP client (`devportal.py`)
- Stdlib HTTPS client to `https://<console>:11443` with `ssl._create_unverified_context()` (self-signed cert accepted).
- Auth: Basic from `--user/--password`; first GET `/api/os/info` sets `CSRF-Token` cookie; all non-GET add `X-CSRF-Token` header (URL-unquoted cookie).
- Endpoints implemented: `/api/os/info`, `/api/app/packagemanager/packages`, `POST /api/app/packagemanager/package?package=X` (multipart msix+deps+cer), `/api/app/packagemanager/state`, `POST /api/taskmanager/app?appid=&package=` (launch), `DELETE /api/taskmanager/app?package=` (stop), `/ext/screenshot?download=true`, `/api/filesystem/apps/files?knownfolderid=LocalAppData`, POST folder/file (upload), GET file (download).
- Comment notes: "Require authentication" is optional on the portal; basic auth is the Dev Home account.

## deploy.sh
- Env `DP_HOST/DP_USER/DP_PASS/DP_PORT`; `curl -sk` with `-c` cookie jar; CSRF token from jar; base64 taskmanager params.
- Docs note: `/api/etw/*` does NOT exist on Xbox Dev Mode; use dumps + app log files.
- Commands: install/launch/kill/state/ps/info/screenshot/dumps/uninstall/info-file.

## Trust-boundary / dev notes
- **Auth posture:** WDP "Require authentication" can be off (the estate showed anonymous 200s on multiple endpoints — confirmed SPY-012/014/015). With auth on, `X-CSRF-Token` is required for mutations; without it, mutation endpoints may be reachable if the portal is unauthenticated.
- **TLS:** `_create_unverified_context()` / `curl -sk` accept self-signed certs — acceptable on trusted LAN, but MITM risk on shared networks.
- **Secrets:** `DP_PASS` from env, never printed; token file at rest (`steam.token`) must be ACL'd.
- **Package install:** msix + cert upload is the sideload path; devs should sign packages and restrict WDP to trusted network.
- **ETW absence:** Xbox Dev Mode lacks `/api/etw/*`; rely on dumps + logs — relevant for incident response on dev kits.

## Walls
Static review only. No creds used, no install/launch/screenshot performed against the estate, no persistence.
