# Express main pin and production file upload

This record reconciles PR #168 with the user-authorized Bloom API upload completed on 2026-10-10 at 21:17:43 UTC. It records file placement, not runtime activation or monorepo release approval.

## Source and artifact

- Authoritative source: [FainNeito/Enthusia-Express main](https://github.com/FainNeito/Enthusia-Express/commit/a650216c6e795f900988b05d788de68b9d4a9866).
- Exact merged main commit: `a650216c6e795f900988b05d788de68b9d4a9866`, independently refreshed using `git ls-remote` during this evidence update.
- Monorepo gitlink: `plugins/enthusia-express` already points to that exact commit in PR #168. No pin change is needed; this update preserves every gitlink.
- Version and filename: `EnthusiaExpress-1.2.1.jar`, descriptor version `1.2.1`, API version `1.21`.
- Canonical [Plugin verification run 37498665380](https://github.com/FainNeito/Enthusia-Express/actions/runs/37498665380): successful Paper 1.21, 1.21.8, 1.21.11 / Java 21 and Paper 26.2, 26.3-pre-2 / Java 25 jobs. The uploaded artifact is the baseline Paper 1.21 / Java 21 build, not a newer-API verification JAR.
- Workflow artifact: `EnthusiaExpress-testing-jar`, artifact ID `11428607957`, built from the exact merged main commit above.
- Uploaded local JAR SHA-256: `3e445ccb5bd52c257b4b3259b0a5e7d5ee31244f685abb18860f357272b450bb`.
- Uploaded local JAR size: `16,620,002` bytes.

## Backup and upload evidence

Server: Bloom SMP, identifier `41f458f0`. Operations used the authenticated API only; no desktop interaction was used. Before replacing the active file, the original JAR was archived server-side and extracted into the backup directory.

| Evidence | Recorded result |
| --- | --- |
| Original active file | `/plugins/EnthusiaExpress-1.2.1.jar`, 16,600,971 bytes, modified 2026-10-05 02:12:11 UTC |
| Original JAR backup | `/plugins/express-backup-main-a650216-20261010/EnthusiaExpress-1.2.1.jar`, 16,600,971 bytes, original modification timestamp retained |
| Additional backup archive | `/plugins/EnthusiaExpress-1.2.1.jar-2026-10-10T211706Z.tar.gz`, 16,499,889 bytes |
| Uploaded active file | `/plugins/EnthusiaExpress-1.2.1.jar`, 16,620,002 bytes, modified 2026-10-10 21:17:43 UTC |
| Root plugin inventory after upload | Exactly one active Express JAR: `EnthusiaExpress-1.2.1.jar` |
| Server state before / after | `running` / `running` |
| Uptime before / after | 62,142,638 ms / 62,207,888 ms; uptime continued increasing |
| Restart / reload commands issued | None |

The API acknowledged the binary upload, and subsequent API directory listings confirmed the new byte count, retained backup, and single active Express filename. The local uploaded bytes were SHA-256 verified. The remote JAR and backup SHA-256 were **not independently verified**: the panel file-content endpoint rejects this file size and the signed storage download endpoint has an expired TLS certificate. Certificate verification was retained. Matching metadata does not establish a remote cryptographic checksum.

The backup directory also contains a staged copy named `staged-EnthusiaExpress-1.2.1.jar`; it is outside the root plugin directory. No config or player-data change is part of this upload.

## Verification and remaining gates

PR #168's previous head `d60f4c9aa81e9bd143238d03337b07f373b66b14` passed the [public combined build](https://github.com/BadgersMC/enthusia-network/actions/runs/37662677269). Fork CI skips private Display, Holidays, and Friends, so that result does not verify those plugins. The evidence update requires its own exact-head hosted check; trusted combined coverage and normal PR review/merge remain release gates.

The server was not restarted or reloaded. The uploaded Express build awaits a future authorized restart; its loaded source version and live player behavior have not been established. This record does not claim that Holidays or Friends were uploaded or activated. Updating the monorepo evidence performs no production operations.
