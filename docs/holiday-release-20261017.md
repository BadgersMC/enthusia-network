# Holiday release integration

REQ-HREL-001: WHEN building the holiday release THE SYSTEM SHALL retain current parent-network features and resolve the exact reviewed component pins below.
REQ-HREL-002: WHEN an explicitly approved fork is selected as the temporary release source THE SYSTEM SHALL use its merged default branch, retain upstream ancestry, and record that fork identity rather than claiming a parent merge.
REQ-HREL-003: IF any selected source is unmerged or a required build is incomplete THEN THE SYSTEM SHALL withhold production release approval.
REQ-HREL-004: WHEN preparing production rollback THE SYSTEM SHALL retain current artifacts, configuration and matched data/identity history without activating the release or resetting live claims.

The owner approved the merged Tags fork as the temporary release source on 17 October after the canonical merge returned HTTP403. This integration therefore changes the Tags submodule URL explicitly to FainNeito/EnthusiaTags. It does not impersonate a canonical Tags or Network merge. The release Network source is the owner's merged fork; upstream PR191 remains open for independent review. No security/build gate is waived by selecting a fork.

## Exact sources

| Component | Approved repository | Commit | Build |
|---|---|---|---|
| Tags | FainNeito/EnthusiaTags | a2d7d9e1f2cd5e5732717a8bc35de56baf1be3da | Network gitlink; merged fork main, contains prior 111d95a and parent 28048ca |
| Renderer | BadgersMC/EnthusiaAdvancements | 01fac426152737c76cd4d2e570e07a33dde99798 | Network gitlink; canonical merged |
| Guilds | BadgersMC/LumaGuilds | 283d75f1e1016d415aa5afdfac840252f0391846 | Network gitlink; canonical v3.0.39 |
| Holidays | FainNeito/EnthusiaHolidays | d07390924de3a953a0685958325de6cf24e85d8d | Standalone canonical Gradle build; merged PR29 |
| UAA | FainNeito/UltimateAdvancementAPI | 94b59a461bcdd0452b98dbdf3536a678b77839ac | Standalone fork Maven build; merged PR2, contains current parent |

Unrelated Network pins and parent features are retained from canonical main 559bfabc2187ab796a3be889f032383a8041f819. The owner Network fork already contains that parent. The historical Tags/renderer and Guild-Staff bootstrap reconciliation remains in this branch. Guild Staff API is built from verified wsg138/EnthusiaStaff commit 8539bb8c77d7ecaf083546dda7ca8ccbfa8064e6; dirty or mismatched sources are rejected. No loose or stub API is committed.

Holidays and UAA are not Network submodules; retain their canonical standalone build paths and record their hashes in the release manifest. Do not claim the renderer's Maven compile dependency packages the server's UAA runtime. The selected UAA keeps version 2.8.2, so source commit and hash distinguish the fork build.

## SPEAR and evidence

Spec: the requirements and approved source boundary above. Prove: the earlier strict Tags consumer/provider version check and bounded bootstrap regression failed before pin reconciliation; the real UAA refresh regression observed [select, remove, definitions, select] during a routine tick. Engine: dependency and CI bootstrap changes only in Network; the UAA fix uses progress-only packets for unchanged wrapper snapshots. Arch: preserve domain/persistence, reward and platform boundaries. No runtime plugin behavior is implemented in Network. Refine: existing component suites, actual renderer-to-UAA compatibility, current-head CI/review and the exact merged-fork combined build. No local EARS/state helper exists in Network; this manual record is validated by the existing Tags EARS helper where available.

Verified component results: canonical Holidays clean build and all eleven Paper profiles pass, 274 tests. Clean UAA merged-fork default Maven build passes 46 tests, both distributions, Javadocs and all 24 adapters. Renderer production and test sources compile against that exact new UAA API (all old UAA classpath entries removed), with 44 tests passing. Tags previously passed 278 Java tests, 11 bootstrap checks, 12 Node checks and EARS; Guilds previously passed 1,769 cases with 16 environment skips. Current combined build must be verified at its merged fork head; a component result is not that combined proof.

The workflow recognizes same-repository owner-fork runs and cross-fork PRs as public builds. Canonical trusted builds still require the private Display read token and approved dependency URLs/hashes. Public builds skip private Display and never count as its acceptance. Keep the existing private Display gate unchanged; verify its actual pinned source in an authorized local/trusted build for a complete release.

The owner confirmed the remaining gameplay checks working, including fresh payouts/Netherite, inventory handling, first finisher, Watcher eyes/music/advancements/disc. This is owner acceptance, distinct from independent replay. The new selected-tab transport fix is installed on TEST for a separate 30-second inspection check.

## Install and rollback boundary

Production has no Holidays directory/JAR at the backup baseline. Initial installation includes explicit module switches with hunt and Watcher off before startup; enable only on the owner's schedule. Do not import TEST hunts, databases, identity keys, staging events or TEST switches. Seasonal guild icons remain excluded; resource-pack reload is not authorized.

A production live rollback archive is stored without changing running plugins; six small Tags SQLite snapshots are integrity-verified. Large DB/sidecar copying is limited by panel size limits and an expired node download certificate. The live archive is not an atomic DB snapshot and has no independently verified remote SHA. Refresh with consistent stopped data at separately authorized activation, keeping DB/WAL and the hunt identity key together. Do not restore stale reward history or pay claims twice. No production activation occurred.

## 20 October local Tags pin reconciliation

REQ-HREL-005: WHEN refreshing the approved Tags release fork pin THE SYSTEM SHALL retain all existing PR191 integration changes, select its merged main, and leave renderer, Guilds, Staff, Holidays and UAA source decisions unchanged.

INFRA-HREL-005: Prepared locally from fetched canonical main `559bfabc2187ab796a3be889f032383a8041f819`, then fast-forwarded the existing reviewed PR191 head `07911cdfec5616e9cba0c09c3e1c201d993b92fc`. Only the Tags gitlink and this integration evidence change beyond PR191. The selected Tags commit includes the native-tab presentation fix and Pumpkin Patcher; it descends from PR191's previous Tags pin and canonical Tags main. No history is dropped. Existing sibling pins and orchestration remain exact.

SPEAR: spec is REQ-HREL-005; prove/engine behavioral phases do not apply to immutable infrastructure pin data. Architecture retains source ownership and companion API checks. Refine requires static pin/ancestry/version checks and canonical combined build at the eventual published head. Network contains no local EARS/state helpers; this manual record is not a claim they ran. The historical component counts and 17 October deployment boundaries above are dated evidence, not new acceptance. The existing PR191 CI success belongs only to its previous head. Local bounded validation built the exact pinned renderer pilot with Maven clean install, then the selected merged Tags source with Maven clean verify: 285 tests, zero failures/errors/skips. The consumer/provider pilot version matches exactly. All 12 project SPEAR tooling tests and all five HREL EARS clauses pass using the project parser; Tags requirements validation, Pumpkin Patcher static asset verification and whitespace checks pass. This is the Tags/renderer slice, not the full Network build.

Source/license boundary: Network is BadgersMC/enthusia-network; Tags uses the explicitly owner-approved FainNeito fork of wsg138/EnthusiaTags. GitHub reports no license for these repositories and Tags has no root LICENSE file. This change neither creates a third-party fork nor copies/modifies plugin implementation; it updates an existing approved immutable dependency. No broader redistribution/license clearance is asserted.

This preparation does not assert a merged Network change, complete combined build, production deployment, or native-client acceptance. Holidays and UAA remain standalone; no invented Holidays submodule is introduced. Full canonical combined verification, including trusted private Display, remains required before release approval.

## 22 October final Halloween dependency reconciliation

REQ-HREL-006: WHEN preparing the final Halloween release THE SYSTEM SHALL pin the approved Tags fork's merged `6d1acc9b72c81cb375402bb22f30be4beb688668`, retaining native tab presentation, Pumpkin Patcher and the single-owner Forgotten Melody announcement fix, while preserving every other existing plugin pin.

INFRA-HREL-006: Continued from exact PR191 head `0c7482031182403a2b5f35a76d82a995bd5f2404` after fetching authoritative main `559bfabc2187ab796a3be889f032383a8041f819`. Tags6d1acc9 descends from the prior a2d7d9e pin. Only this document and that gitlink change. Current source remains individually owned; Holidays is standalone at merged PR38 `829286e3e480cb702bcc8227e6bc02f3b78ccf14`, with no invented Network submodule. On TEST, exact Holidays b523cd7 implementation and Tags6d1acc9 produced one natural Forgotten Melody announcement after the full243-second duration, with newly persisted progress and unchanged physical inventory. The Holidays merge retains the same implementation tree.

SPEAR: infrastructure pin data has no behavioral engine change. Proof consists of ancestry, unchanged sibling pins, the real consumer/provider build and trusted private Display verification; a public CI skip cannot satisfy that last requirement. Existing Tags EARS tooling validates the new clause. Exact build results and immutable artifact hashes are recorded separately after execution. This paragraph does not assert completed builds, merge of Network191 or production readiness. Production remains read-only and activation requires a separate authorization.
