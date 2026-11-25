# Scope & Walls — How This Engagement Was Bounded

This document explains the guardrails (walls) that governed the Scarlett Soufflé campaign. Included for transparency and for dev-community readers who want to reproduce responsibly.

## Declared estate
- Target: `10.0.0.23` (Xbox dev-mode device on LAN).
- Scope authority: `~/.redteam/xbox-devmode-scope.json` (`in_scope: 10.0.0.23`, expires 2026-12-25).
- `scope check` is the only estate verdict. Host-level gates mechanically block out-of-estate connective commands.

## Walls (absolute, not overridable)
1. Declared estates only; scope inherits the source finding's declaration.
2. Documented-PoC adaptation; no novel weapon classes, malware, or destructive payloads.
3. Validation-only compromise; reversible; NO-GAIN; persistence never installed.
4. Never social; never third parties (vendors/upstreams documented, not touched).
5. Zero documents: recorded declaration is the entire gate; no paperwork requested/stored/transmitted.
6. Destructive end-states refused once, plainly, then pivoted to disclosure/documentation.
7. Gifts/leaked credentials are findings to document, never authorization to use.

## How walls shaped this campaign
- **No credential brute force / guessing** on SSH (password auth present but untested).
- **No third-party contact** — Microsoft not notified; disclosure remains on operator's estate.
- **No game dumping / decryption of protected content** — only documented crypto/entitlement architecture structurally.
- **No persistence installed** — control session was revoked; no files retained beyond proof.
- **No destructive endpoint tests** — launch/upload/delete/restore/config mutations were code-reviewed but not executed.
- **No value retained** — screenshot/exports streamed to `/dev/null` and discarded.
- **Read-only-first** — every finding began as read-only GET/OPTIONS; state-changing proofs (settings toggle, SSRF loopback fetch) were minimal and reversible, then restored.

## What this means for the dev community
The walls are the difference between research and unauthorized access. The findings here are real, but the proof is deliberately limited to reversible, non-destructive, in-scope probes. If you want to reproduce or extend, get explicit authorization and stay within these boundaries.
