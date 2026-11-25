# Host Module Static Review (steam_client / ui / swapchain)

Read-only static review of local Tiramisu host modules. No runtime exploit testing performed.

## steam_client.cpp

**Observed behavior (code-cited):**
- Persists Steam credentials/tokens in `steam.token` under state dir (`token_file_path`, `save_credentials`, fopen/write; ~182-212).
- Loads tokens at startup (`fopen token_file_path`, parses `refresh_token`/`access_token`; ~1656-1694).
- Deletes token file on signout (`DeleteFileA(token_file_path...)`; ~1733).
- Refreshes access token via `IAuthenticationService/GenerateAccessTokenForApp/v1` (~1435-1475).
- Uses access tokens in URL query params for GetOwnedGames/GetFriendList/GetPlayerSummaries (~1484,1516,1568,1586).
- Uses hardcoded Steam Web API/CM endpoints (`api.steampowered.com`, `ISteamDirectory/GetCMListForConnect`, CM websocket connect; ~1482,1515,1567,1982,2009 etc.).

**Trust-boundary notes:**
- Token-at-rest: protect `steam.token` with ACLs; treat as secret. Debug bundles/backup exports should exclude or redact.
- Token-in-URL: query params can leak in logs/proxies/crash reports; prefer Authorization header where API allows.
- Outbound network: expected for Steam features; ensure TLS validation and endpoint pinning/allowlist as appropriate.
- No unauth webxfer exposure proven directly from this module; risk is local secret handling and log/export hygiene.

## ui.cpp

**Observed behavior (limited grep/read):**
- Tracks pad/controller connection state and displays transfer status including port 9127 string (~123,1560,2054-2056).
- No obvious network listeners, HTTP clients, token/auth handling, or command exec patterns found by simple grep.

## swapchain.cpp

**Observed behavior (limited grep/read):**
- Graphics bind/present logic (`d3d9_rt::bind`, `gl_rt::bind`, `vk_rt::bind`; ~688-693).
- No obvious network/auth/exec patterns found by simple grep.

## Caveats
- Simple grep is not a security audit. Manual review and fuzzing in authorized lab needed for memory safety, parser bugs, and logic flaws.
