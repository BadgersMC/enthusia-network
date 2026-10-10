# KOTH release preparation

## Current boundary

The user deferred server testing and activation. This record prepares the upgrade;
it does not authorize a restart, reward activation or production upload. The previously
staged TEST archive remains inactive outside `plugins`.

## Source and build gate

- KOTH: `23dba1b7ed71315c8ff32e786707a4bb0d68e0a4`.
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

The preparation fragments remain inactive. Later pin/build-helper updates are
infrastructure orchestration: existing plugin suites, real-provider contracts,
explicit missing-input failure, EARS and whitespace checks validate the change;
no historical behavioral red/green evidence is claimed. No server configuration
was saved, no additional file was uploaded and no startup, multiplayer,
resource-pack or reward acceptance was performed in this turn.

## Match integrity pin update (2026-10-09)

KOTH [PR #8](https://github.com/FainNeito/EnthusiaKOTH/pull/8) merged at 2ad0b693caaaf2ce5011579152fd4b54b7b55f5b. Its final source head 4e3cddd754cf9a29e4aa100314d2aeee58592bf8 passed hosted Build 37891803581; only the Ubuntu runner migration notice was annotated. Local tests passed 314 cases plus 16 real Guilds API cases (one ordinary provider-only skip). Manual source review completed; CodeRabbit skipped automatic review, not independent approval.

The network pin now includes contest/control/combat evidence, bounded win-trading reports, audited restart-safe reward/challenge holds, UTC event currency/item ceilings, persisted arena identities and /ekoth results. All new enforcement defaults off/zero until TEST. Readiness fails closed for unverifiable definitions; LoreItems V1 needs a read-only definition query before enforced readiness with item rewards can pass. Combat remains MaceGuard's current rotation. Owning exact-head combined build is a separate gate and must be rechecked for this pin.

The older staged archive above does not contain this integrity update and must not be represented as the new artifact. No archive was uploaded/replaced, no server changed, no activation/client testing occurred. Preserve isolated TEST databases and the existing real asset/configuration review requirements.

## Read-only provider readiness pin (2026-10-09)

KOTH [PR #9](https://github.com/FainNeito/EnthusiaKOTH/pull/9) merged at `b6f4a50716005f6c8cd88e778ef69dd1343d5ef2`. Exact head `d2ac6e08ec9cd8348be3e0ed9cfce4a27d74acd7` passed hosted Build [37898143016](https://github.com/FainNeito/EnthusiaKOTH/actions/runs/37898143016), including JAR API exclusions and duplicate checks. Manual source/adapter review completed; CodeRabbit skipped automatic review. Local verification passed 321 ordinary cases (two provider-only skips), 16 real Guilds cases and eight real LoreItems contract cases.

The bounded asynchronous query creates no probe item or claim. Missing/failed/unsupported definitions block enforced rewarded starts before charge/flare acceptance; snapshots expire after five seconds and queries time out after three. Provider replacement/reload clears readiness; delivery still revalidates definitions. All enforcement stays off/zero until TEST.

[LoreItems PR #40](https://github.com/wsg138/EnthusiaLoreItems/pull/40), candidate `f89d153e2280d998d5b6225f308ae71c3a907ce1`, adds the optional read-only V1 method and separates plain/shaded JAR paths. Its local `clean check :plugin:shadowJar` passed 481 cases with four existing environment skips. Hosted workflows require upstream approval, and this account cannot merge upstream. The local provider JAR is an unmerged contract-test input only. Canonical provider merge/build and later real definition/signature/texture acceptance remain gates.

Previous network head `2708f8fe9aef8ca79d15da6479bce0e6dfedefd0` passed public hosted Build 37892096786 and local `buildAll` including private Display. Recheck the new head for this pin/helper update; public fork CI omits private Display and has no supplied LoreItems artifact. No production acceptance is inferred.

## Automatic wand outline pin (2026-10-09)

KOTH [PR #10](https://github.com/FainNeito/EnthusiaKOTH/pull/10) merged at `fea6ebdc5f7982e73d3181260a8b22e4a0524207`. Exact source head `562c2bf460661a090697957e3289661e6ac0aa2b` passed hosted [Build 38001085464](https://github.com/FainNeito/EnthusiaKOTH/actions/runs/38001085464), including JAR checks; 325 local ordinary tests passed with two provider-only skips. Manual source/lifecycle review found no blocking findings; CodeRabbit skipped automatic review.

The wand now shows private yellow first-corner markers, an orange live aimed cuboid and a cyan completed boundary. Point counts and view distance are bounded. Selection tasks stop on save, cancel, disconnect, world change and shutdown. The interactive illustration is a simulation; Java/Bedrock particle visibility remains a deferred TEST gate. The network pin follows merged source only. This infrastructure pin update uses the existing plugin regressions and combined build instead of invented historical red/green evidence. No server files or running plugins changed. Exact-head network checks remain separate from the standalone result.

## Setup and rewards navigation pin (2026-10-10)

KOTH [PR #11](https://github.com/FainNeito/EnthusiaKOTH/pull/11) merged as `23dba1b7ed71315c8ff32e786707a4bb0d68e0a4`; reviewed source `03142a0231ae142173293fad1efa170a9e595968` passed [Build 38068563963](https://github.com/FainNeito/EnthusiaKOTH/actions/runs/38068563963), 329 ordinary local cases with two provider-only skips, and the actual built Tags/KOTH menu contract. The source trees of head and merge are identical. Manual presentation/lifecycle review passed; CodeRabbit skipped automatic review.

The compact hub links arena setup and progression. Setup follows Area -> Rules -> Review, using an enchanted wooden axe and guarded unsaved edits. Advanced schedules, payouts and displays remain available. [Tags PR #30](https://github.com/wsg138/EnthusiaTags/pull/30) adds /rewards -> KOTH and return navigation without duplicating eligibility or payout authority. Exact head `a94be809a7dfa402c6ce142ef9103eeda00ec4eb` passed hosted verification 38068920218, Sentinel artifact 38068920246 and Codacy (zero issues), plus 256 local tests and the shaded SQLite probe. This account's merge attempt was denied by the GitHub integration; its canonical merge and a later network Tags pin remain gates. Existing Tags remains pinned until then.

Combined local `buildAll` stopped during Market configuration because JitPack could not resolve `com.github.BadgersMC.Nexus:nexus-permissions-gradle:057836b`. No combined success is claimed for this pin. Infrastructure-only changes retain the existing canonical helper and all other gitlinks. Source provider checks, owning network CI/merge and combined release verification remain separate gates. No server upload/restart or player/client acceptance occurred. The owner-private interactive schematic is https://enthusia-koth-setup-preview.awareyak.chatgpt.site/cleanup.html; mobile layout was checked, authenticated mobile access remains unverified.
Merged-source network KOTH helper verification passed: 329 ordinary tests (two provider-only skips), 16 real Guilds cases, clean shadowJar; artifact SHA-256 `d1a1941a64b993d13ff6c8ba9a344e0d92a612f1d95aa3ef6e39615ae2cc4ad1`. Optional LoreItems suite omitted with explicit helper notice. This does not clear the combined build or server acceptance gates.
