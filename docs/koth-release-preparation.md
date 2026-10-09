# KOTH release preparation

## Current boundary

The user deferred server testing and activation. This record prepares the upgrade;
it does not authorize a restart, reward activation or production upload. The previously
staged TEST archive remains inactive outside `plugins`.

## Source and build gate

- KOTH: `d0552119f3a5ea01fdb094189c9a32df290e6081`.
- Guilds: `352406f2498afc412a976289f43e158da92317e0`.
- Advancements: `2736261976480891fcf298ad4305e7dc44910eca` (merged AxKoth retirement); TEST retains the pilot profile.
- Network integration: https://github.com/BadgersMC/enthusia-network/pull/171.
  A maintainer must merge after required checks pass; the current account has no merge control.
- Hosted Build [37882730858](https://github.com/BadgersMC/enthusia-network/actions/runs/37882730858)
  passed for PR head `843cfbbe280b0717a5ea4206e2a8e61595669259`, including the
  public composite, KOTH real-provider suite, Tags/pilot, Signature and importer.
  Private Display checkout/build was explicitly skipped for the fork PR; its prior
  local verification remains separate. GitHub rejected the connected integration's
  merge attempt with access denied. Maintainer merge and a trusted build including
  Display remain release gates. Subsequent documentation edits do not change the
  verified plugin pins or build inputs; check their new PR head separately.
- The earlier local root `buildAll` passed. Hosted run `37878739616` failed while
  downloading AxKothAPI 4 and axapi 1.4.8; direct official downloads reproduced
  truncated bodies with bounded retries. The owner subsequently requested removing
  AxKoth. Advancements PR #22 removes that repository/API and capture listener,
  while retaining saved configuration parsing and blocking retired progression,
  administrative grants and rewards. Verified eKOTH remains authoritative.
  Verify the canonical merged pin and new combined CI before release; the earlier
  failure is historical evidence, not passing verification. No mirror is needed.
- The staged archive SHA-256 is
  `e97a876448d608f11c344eecb2173f0acf3b8f112488441bd077f60343c8fb64`.
  Its manifest records per-plugin commits, versions and hashes. It remains a TEST
  candidate while the owning network integration is unmerged.

## Guilds holiday reconciliation

TEST's candidate `87af01b995eb31fb594372af4113ba612e228e07` was fetched from
FainNeito/LumaGuilds. Canonical Guilds contains the upstream holiday integration
merged by `ff5ec6aa04736c4236262ed3d3ff3e12f5dccda4` (PR #222), an ancestor of the
pinned source. Comparing the actual old and candidate JARs with javap found identical
public declarations for `GuildCosmeticUnlocks` and `GuiTheme`. The title builder retains
horizontal shift -8 and rewind -162. Its differences from the old candidate are comments.

The existing cosmetic API/service/SQLite persistence and menu-title/glyph suites passed
58 cases with zero failures/errors/skips against the real companion compile artifacts.
No holiday backport or plugin code change is needed for this dependency upgrade.
The canonical repository intentionally omits proprietary Nexo textures/glyph files:
preserve TEST's existing assets and ownership data. Matching ascent 13 and actual
Java/Bedrock rendering still require the later server/client acceptance session.

## Configuration preparation

`ci/koth/test-guilds-safety.fragment.yml` is a merge fragment, not a replacement for
Guilds' complete configuration. TEST's existing config omits this newer section;
the new default enables Discord role synchronization. Apply the explicit disabled
value before loading the upgraded Guilds, preserving every other setting.

`ci/koth/test-koth-safety.fragment.yml` supplies global inactive preparation settings.
Merge by key into the existing configuration, retaining accepted arena coordinates.
Also disable **every** configured arena; clear its `rewards` list and
`chanced-rewards` map, empty its schedule, and set every reward-family money value
to zero. Include custom arenas/families. The packaged sample capture arena contains
`bank 500` and a chanced `bank 50`: a zero money family alone does not neutralize
these command rewards. Never substitute the packaged example areas for real arenas.

Keep `progression.yml` disabled with pool/package budgets zero, packages empty,
guild XP command empty and all tag/LoreItems definitions blank. Thresholds stay
disabled until TEST calibration. Keep-inventory arena variants must explicitly set
both `keep-inventory: true` and `keep-experience: true` when later selected.

## Later TEST activation sequence

1. Resolve hosted CI and merge the owning network pin PR. Rebuild/reconcile the
   release manifest from canonical merged source before production delivery.
2. Record the active TEST inventory, configuration and candidate hashes. Stop TEST
   during the scheduled activation window, then back up old JARs, plugin directories
   and databases outside active plugins. Do not copy a running SQLite main file alone;
   use a stopped consistent backup including any WAL/SHM files or a supported online
   database backup. Preserve Tags/LoreItems/Currency and Guilds ownership data.
3. Apply the reviewed inactive configuration to TEST only. Use its own KOTH database
   (`koth_stats.db`) and local provider storage; disable Discord writers. Never import
   TEST match, claim or exclusive-ownership rows into production.
4. Replace the old KOTH, Guilds and pilot JARs with one selected version of each.
   Do not install both the pilot and full Advancements renderer. Leave unrelated
   provider plugins and private resource-pack assets intact.
5. Start TEST and verify loaded versions, provider registration, database migration
   and readiness in the fresh log. A successful startup is not player acceptance.
6. Validate actual arena coverage inside MaceGuard's effective warzone, excluding
   its spawn/market/duels regions. Notification audiences are separate: start and
   winner global; capture notices in spawn, warzone and market.
7. Run the matrix in `plugins/enthusia-koth/docs/test-acceptance.md` with consenting
   players. Enable disposable TEST thresholds/rewards only for explicitly recorded
   scenarios; verify balances, claims, restarts and no accidental advancement bypass.
8. Keep the genuine FainNeito signature and physical helmet texture acceptance as
   explicit gates. A draft item, cosmetic kill count or simulated preview is not proof.

Rollback after a failed migration requires restoring the consistent backup and matching
old JAR/config set together; downgrading only the JAR is not a verified rollback.

## Verification limits

This preparation changes documentation and inactive fragments only; behavioral
prove/engine steps do not apply. EARS, YAML parsing and whitespace checks validate
the record. No server configuration was saved, no additional file was uploaded and
no startup, multiplayer, resource-pack or reward acceptance was performed in this turn.
