# WDP Anonymous Surface Map (read-only sweep)

Two batches of anonymous GETs against `https://10.0.0.23:11443`. Confirms the anonymous surface is small and stable; everything else 404.

## 200 OK (anonymous)
- `/api/os/info`, `/api/os/machinename`, `/api/os/devicefamily`
- `/ext/settings`, `/ext/xbox/info`, `/ext/xboxlive/sandbox`, `/ext/user`
- `/api/networking/ipconfig`
- `/api/app/packagemanager/state`, `/api/app/packagemanager/packages`
- `/ext/screenshot?download=true`
- `/api/filesystem/apps/files` (400 without params, 200 with valid knownfolderid)

## 404 (not anonymously exposed)
`/api/taskmanager/*`, `/api/filesystem/apps/file`, `/api/filesystem/apps/folder`, `/api/app/packagemanager`, `/api/app/packagemanager/package`, `/api/etw/*`, `/api/processes`, `/api/perf`, `/api/debug`, `/api/dump(s)`, `/api/telemetry`, `/api/system`, `/ext/xbox/*` (except info/sandbox), `/ext/app`, `/ext/xboxlive`, `/ext/network`, `/ext/users`, `/ext/remoteaddress`, `/ext/credentials`, `/ext/registry`, `/ext/services`, `/ext/processes`, `/ext/threads`, `/ext/devmode`, `/ext/developer`, `/ext/app/types`, `/ext/app/containers`, `/ext/interaction`, `/ext/power`, `/ext/system`.

## OPTIONS posture
- WDP mutation endpoints: `OPTIONS=403` (CSRF/auth required for non-GET when auth is on).
- Tiramisu dashboard mutation endpoints: `OPTIONS=204` (preflight accepted) — see `CORS-PREFLIGHT-POSTURE.md`.

## Evidence
- `SELF-AUDIT-QUICKCHECK.sh` reproduces the Tiramisu/WDP/UPnP subset.
- Full wordlist sweep captured in repo commit history (see research updates).
