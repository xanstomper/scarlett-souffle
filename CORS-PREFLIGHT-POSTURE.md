# CORS / Preflight Posture (read-only)

Observed on `http://10.0.0.23:9127` (Tiramisu dashboard).

## Findings
- Root dashboard responses carry `Access-Control-Allow-Origin: *` and `Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS` (SPY-004).
- Mutation endpoints (`/api/launch`, `/api/stop`, `/api/rescan`, `/api/upload-file`, `/api/restore-saves`, `/api/download-url`, `/api/settings`, `/api/controls/pair`, `/api/controls/input`) all return `OPTIONS 204` with no auth (SPY-021 CONFIRMED).
- Combined with wildcard origin, any website can preflight and attempt cross-origin mutation requests against the dev dashboard.

## Why it matters (dev-community)
Browser-based CSRF/CSRF-like cross-origin attacks become practical on LAN: malicious page can attempt settings changes, rescan, stop, upload, restore, launch, or download-url. Even if some endpoints reject the actual request, the posture is unsafe for a dev admin surface.

## Mitigation
- Remove `Access-Control-Allow-Origin: *`; allowlist trusted origins.
- Require CSRF tokens on all state-changing endpoints; validate Origin/Referer.
- Restrict mutation endpoints to authenticated sessions.
