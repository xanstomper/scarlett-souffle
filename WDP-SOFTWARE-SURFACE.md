# WDP Software Surface Summary (redacted)

Read-only anonymous observation from `GET https://10.0.0.23:11443/api/app/packagemanager/packages` on declared estate `10.0.0.23`. Full package inventory is sensitive; this doc provides a sanitized summary.

## Observed inventory
- **Total installed packages:** 74
- **Exposure:** anonymous HTTP 200 (SPY-014)
- **Risk:** software inventory aids targeted recon; may reveal dev tools, sideloaded apps, or environment details.

## Sanitized category summary
| Category | Count (approx) | Public/benign examples observed |
|---|---:|---|
| Identity/system sign-in | 7 | Sign In |
| Browser/web tooling | 2 | Microsoft Edge, Remote Tools for Microsoft Edge |
| Dev tools | 1 | (dev tooling present) |
| Media | 1 | Dolby Vision |
| Game/app | 2 | RetroArch |
| Other/system | 61 | File Explorer, DefaultApp, App Resolver, Credential Dialog, NetworkTroubleshooter, Xbox Setup |

*Counts are rough keyword categorization over observed names; not authoritative.*

## Why it matters
- Confirms dev kit has sideloaded/dev tooling surface.
- Package inventory can reveal attack surface, installed frameworks, and user behavior.
- Should require authentication and be excluded/redacted from shared debug artifacts.

## Handling
Do not publish full raw package inventory from third-party/dev kits without owner review. Redact custom/private app names where needed.
