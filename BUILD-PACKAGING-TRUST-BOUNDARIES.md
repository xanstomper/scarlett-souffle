# Build / Packaging / Deploy Trust Boundaries (static review)

Read-only static review of local dev dashboard build/deploy scripts. Observations are devops/supply-chain hygiene notes, not confirmed runtime exploits.

## Observed

| File | Observation | Risk class | Note |
|---|---|---|---|
| `tools/deploy.sh` | Uses `curl -sk` to Device Portal; `DP_PASS` from env; CSRF token from cookie jar | TLS verification disabled | Acceptable for self-signed WDP on trusted LAN, but `-sk` suppresses cert validation; pin/capture cert in hardened setups. |
| `tools/build-hermes.sh` | Default relay URL `http://10.0.0.97:8790/v1/chat/completions`; token from `HERMES_TOKEN` env | cleartext/local relay trust | Ensure relay is trusted/local; avoid leaking token in logs/CI. |
| `third_party/mono-uwp/build-mono-uwp.sh` | Downloads tarball via `curl -sSL --fail` from `https://download.mono-project.com/...` | supply-chain/download integrity | HTTPS helps; verify checksums/signatures and pin versions for reproducibility. |
| `third_party/fna/build-fna.sh` | Uses `eval "$mcs_cmd"` | command injection if inputs controlled | Ensure build inputs/vars are trusted; avoid eval where possible. |
| third-party `curl`/`wget`/HTTP URLs in vendored libs | some vendored upstream scripts include download URLs | supply chain | Review vendored build scripts before use in CI; prefer pinned, verified artifacts. |

## Recommendations
- Pin dependencies by version + checksum/signature.
- Avoid `curl -k` outside explicitly trusted self-signed lab contexts; prefer CA/cert pinning.
- Do not `eval` constructed commands; use arrays/explicit args.
- Keep secrets in env/secret store, never in repo/logs.
- Run CI builds in isolated, least-privilege environments with egress controls.
