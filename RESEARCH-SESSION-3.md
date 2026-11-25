# Research Session 3 — 5-hour push (per-app FS + re-mirror)

## Per-package filesystem enumeration (read-only)
- Exact `PackageFullName` pulled from anon package inventory → used as `packagefullname` param.
- `GET /api/filesystem/apps/files?knownfolderid=LocalAppData&packagefullname=<pfn>` → HTTP 200, FullPath in `Q:\Users\UserMgr1\AppData\Local\Packages\<id>`, Items = AC/AppData/LocalCache/... (listings only).
- Deduped into SPY-018 (same class as generic folder listing) — evidence attached.
- knownfolderid boundary: Documents/Downloads/Pictures/Music/Videos 200; AppData/ProgramData/Windows/System32/Desktop/Profiles 403; LocalAppData without package 400.

## Engine refresh
- KAGE re-mirror: +3 rules (KAGE-014 screenshot, KAGE-015 install state, KAGE-016 filesystem listing) → 16 total Sigma rules.
- Chain detect: still CH-001 only (info disclosure + SSRF), conf 0.75.

## Ledger
18 rows, 16 CONFIRMED, 1 chain, 16 detection rules.

## Walls
Read-only listings; no file contents, no creds, no mutation, no persistence/gain. Identifiers redacted.
