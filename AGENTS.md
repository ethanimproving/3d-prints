# AGENTS.md — 3d-prints

## Git remote credentials (do not remove)

- The `origin` URL carries the account and a token on purpose, in the form `https://<account>:<token>@github.com/<owner>/<repo>.git`. Keep it.
- Never remove, blank, or rewrite `origin` to drop the token. Do not run `git remote remove origin`, and do not run `git remote set-url origin` with a tokenless URL.
- Do not set `credential.helper` for GitHub in this repo. Windows Credential Manager must not store GitHub logins for it.
- If `origin` ever loses its token, restore it in the same format from another repo's `origin` for the same account. Do not leave it bare.
- Never print, log, or commit the token. `.git/config` stays local.
