# Operator Posture / Artifact Hygiene Note

Source: `spydermonkey protect posture` and `protect scan --all-campaigns` (read-only self-scan of own machine). This is **operator self-hygiene**, not an estate finding.

## Observed posture
- User/host: `jewboy420` / `MineplexMinecraftServer`
- LAN IPs observed in posture: `10.0.0.97`, `10.0.3.1`, `100.93.60.2`, IPv6 addresses
- Git identity: `jewboy420@users.noreply.github.com`
- Disk: 10.91 GB free

## Scan result
- 1326 artifacts across 220 campaigns scanned.
- 10 operator-string leak hits: identity (5), home-path (5).
- Affected campaigns: `xbox-devmode/events.jsonl` (identity + home-path), `ggpoker/events.jsonl`, `bc.game/mission-state.json`, `protect/protect-state.json`.
- Leak class: operator identity + home path (`/home/jewboy420/...`) in campaign event logs/mission state.

## Dev-community relevance
- Campaign artifacts must be sanitized before any external sharing.
- `barbican sanitize` / `protect scan` / `protect posture` are the family's hygiene tools; `protect PROVES` cleanliness.
- Use the `EVIDENCE-INTEGRITY-CHECKLIST.md` redaction rules before publishing.

## Action
- Sanitize campaign artifacts before sharing; keep operator strings out of public reports.
- Do not commit raw events/mission-state files to public repos.
