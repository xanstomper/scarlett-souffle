# Source Review Findings — dev dashboard `webxfer.cpp`

**Scope:** local static review of `/home/jewboy420/dev dashboard/src/host/webxfer.cpp` (read-only). No destructive endpoint testing performed. Line numbers from current workspace copy.

## Auth-gap observations (code review)

The following handlers were observed with `strcmp(method,...)`/`url_path` checks and no nearby auth/token/bearer check in the inspected window:

| Line | Handler | Risk | Actively tested |
|---:|---|---|---|
| 1807/1837 | `/api/cover/<name>` GET/PUT | info leak / content tamper | GET observed |
| 1866 | `/api/upload-complete` POST | state/workflow tamper | no |
| 1887 | `/api/download-url` POST | SSRF | **CONFIRMED SPY-007** |
| 2299 | `/api/restore-saves` POST/PUT | destructive restore | no |
| 2442 | `/launch/<name>`, `/api/launch/<name>` POST | arbitrary app launch | no |
| 2486 | `/api/stop` POST | availability/state tamper | no |
| 2494 | `/api/rescan` POST | state tamper | no |
| 2503 | `/api/game/<name>` DELETE / `/api/delete/<name>` POST | destructive deletion | no |
| 2528 | `/api/config/<name>` POST | config tamper | no |
| 2581 | `/api/upload-file` PUT/POST | arbitrary file upload | no |
| 2647 | `/upload/<name>.zip` PUT/POST | archive upload/extract path | no |
| 2740/2767 | `/api/settings` GET/POST | info leak / config tamper | **POST CONFIRMED SPY-011** |

## Path sanitization observations

- `sanitize_game_name` rejects empty/>160, `.`, `..`, `..` substring, control chars, `/\:*?"<>|` (webxfer.cpp ~582-594).
- `sanitize_rel_path` splits on `/\`, rejects `.`/`..` segments and `..` substring, rejects control chars and `:`, normalizes to sep (webxfer.cpp ~596-624).
- Encoded traversal probes against `/api/cover/...` returned 404 in live read-only tests. No traversal bypass confirmed.

## Dangerous pattern grep

`grep -nE 'system\(|popen\(|CreateProcess|ShellExecute|WinExec|cmd /c|eval|strcpy\(|sprintf\(' src/host/webxfer.cpp` returned no dangerous command-exec API calls in webxfer.cpp; matches were limited to benign evaluation helper names. This is not a full security proof.

## Dev-community implications

- Missing auth on management/dashboard endpoints is the dominant risk class. On dev kits, LAN exposure makes this high impact.
- Even with good path sanitization, unauth upload/launch/config/restore still create severe workflow compromise.
- SSRF and CORS * widen remote browser/LAN attack surface.
