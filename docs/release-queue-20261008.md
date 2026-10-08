# Release queue snapshot — 2026-10-08

This source/check audit supersedes the earlier handoff where explicitly noted.
It is not a refreshed production JAR inventory or runtime acceptance record.
No upstream merges or server operations are authorized by this source task.

## Monorepo

- Canonical main remains `559bfabc2187ab796a3be889f032383a8041f819`.
- [PR #168](https://github.com/BadgersMC/enthusia-network/pull/168) remains open,
  head `d60f4c9aa81e9bd143238d03337b07f373b66b14`. Hosted Build
  [37662677269](https://github.com/BadgersMC/enthusia-network/actions/runs/37662677269)
  passed, but explicitly skipped private Display, Holidays and Friends checkout
  and Display API preparation. An authorized trusted build needs the read-only
  private-plugin token plus existing Display inputs; secret presence was not
  inspected and absence is not inferred from the skipped fork run.
- Playtime remains pinned to `ffd2abaa63b259a1d3466eb16da81cf5db4b9539`, the
  still-open upstream #27 head. A passing candidate build is not merged release
  provenance. Do not silently roll back the API or substitute another fork.
- RoseChat is owned by `BadgersMC/Enthusia-RoseChat` in this network; wsg138's
  #21/#22 cannot simply be used as this gitlink without lineage reconciliation.

## Pending upstream source and checks

All PRs below remain open and unmerged at this snapshot.

| Repository | PRs | Current gate |
| --- | --- | --- |
| wsg138/EnthusiaTeleport | #19, #20 | Codacy success; hosted Build/artifact workflows action_required |
| wsg138/WarzoneDuels | #22 | latest test/verify successes; Codacy action_required; earlier failed runs also exist |
| wsg138/WarzoneDuels | #23 | test/verify workflows and Codacy action_required; includes #22 ancestry |
| BadgersMC/LumaGuilds | #207, #208 | current build/Codacy checks pass; review/maintainer merge remains |
| wsg138/EnthusiaTags | #24–#29 | current verify/artifact/Codacy gates pass; review/maintainer merge remains |
| wsg138/MaceGuard | #47 | Codacy success; Build/analysis workflows action_required |
| BadgersMC/EnthusiaMarket | #197 | Codacy success; build/quality workflows action_required |
| wsg138/Enthusia-RoseChat | #21, #22 | draft; hosted Build action_required |
| wsg138/EnthusiaStaff | #339 | draft and conflicting; current hosted coverage/runtime/Codacy checks pass |
| wsg138/PlayTimePlugin | #27 | Codacy success; hosted Build action_required |

Market #197 belongs to BadgersMC, not wsg138. Newer heads include Tags #29
`254c8f8`, LumaGuilds #208 `3933595`, Staff #339 `58fe8f3`; earlier test evidence
must not be assigned to these heads without verification. Green automation does
not establish human approval or permission to merge.

## Missing source integrations

This change adds canonical merged StartupGuardian plus the explicitly selected
owner Discord forks. The remaining names still need source/build reconciliation:

- EnthusiaStaff: wsg138 source exists, but paired RoseChat integration and #339
  conflict must be resolved before a release pin.
- EnthusiaMapShields: local checkout remote is FainNeito/EnthusiaMapShields;
  source reconciliation of the newer local build remains a separate gate.
- EnthusiaFrontier and EnthusiaLoreItems: public wsg138 sources found; inspect
  their independent build/asset/companion contracts before integration.
- EnthusiaEvents: public wsg138 source found; preserve its test-only placement.
- EnthusiaKOTH: both wsg138 and Hermes-Enthusia repositories exist. Select the
  authoritative production lineage before choosing a pin.
- LumaTrivia: both BadgersMC and Hermes-Enthusia repositories exist. Select the
  authoritative production lineage before choosing a pin.
- EnthusiaServerAutoClicker: repository search did not identify a source;
  this is not proof that a private or differently named repository does not exist.

Production/Test/proxy inventories, loaded artifact provenance and actual client
acceptance still require fresh read-only evidence. Filename dates and `-test`
labels alone neither prove content nor determine whether source is merged.
