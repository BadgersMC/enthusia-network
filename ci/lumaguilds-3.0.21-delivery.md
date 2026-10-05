# LumaGuilds 3.0.21 delivery

## SPEAR specification

WHEN the network is built, THE BUILD SHALL resolve LumaGuilds to reviewed merged commit `439681af6e828efb8df7b9bd7625658eedc6353b`, the source of canonical release `v3.0.21`.
Before production placement, THE DELIVERY SHALL verify merged network pins, required build checks, artifact version and SHA-256. Placement SHALL NOT restart, reload or activate the running server.

## Proof and implementation

This infrastructure change updates only the LumaGuilds gitlink from `e90bbb53f5b3b7a7b37b61c938f56d3e8abfc5cf` (3.0.20) to `439681af6e828efb8df7b9bd7625658eedc6353b` (3.0.21). Plugin behavior is supplied by merged LumaGuilds PR #204; no plugin source is changed here. New behavioral engine tests do not apply to the pin edit.

The canonical release workflow tests then builds a clean checkout of the tagged source. Exact merged-source GitHub build and release jobs passed. Official release artifact `LumaGuilds-3.0.21.jar` has SHA-256 `1c38496b291cedbb1c4e072a263f18dbc3f2d2337397a599d71b193c2d2674fe`.

## Refinement and remaining gates

- [x] Fetch authoritative network main and preserve existing checkouts.
- [x] Verify merged plugin source and canonical tag/release jobs.
- [x] Change only the LumaGuilds pin and document provenance.
- [ ] Complete exact-head network build checks and review before merge.
- [ ] Merge through normal authorized PR flow; source merge and upload authorization are separate.
- [ ] Verify uploaded artifact bytes and preserve the previous JAR for rollback.
- [ ] Runtime and player/client acceptance require later separately authorized activation.

No project-local EARS validator or state helper was found in this network checkout. This record tracks specification, pin implementation and verification gates. No production configuration, resource pack, console command, restart or reload is part of this change.
