# Active playtime and Discord retry integration

## Requirements and task (SPEAR)

- NET-PT-01: WHEN the network is built, THE SYSTEM SHALL verify the pinned Tags source and its checksum-pinned dependencies, including the actual network pilot renderer API.
- NET-PT-02: WHEN candidate component pins are reviewed, THE SYSTEM SHALL retain their exact source identifiers and prohibit release acceptance until both component PRs are merged and the pins identify canonical merged commits.
- NET-PT-03: WHEN integration checks run, THE SYSTEM SHALL leave production files, configuration and processes unchanged.

Task NET-PT: draft integration preparation. Component PRs: wsg138/PlayTimePlugin #27 and wsg138/EnthusiaTags #23. Current GitHub account FainNeito has read-only upstream access; component merges and Playtime workflow approval require a maintainer.

Spec: canonical network main 876d401 omits Tags from build-all and CI. Tags' native track requires the pilot renderer, which is present in the network Advancements submodule but is not built by its root Gradle shadowJar. A candidate draft may reference unmerged component heads for review; it must not be merged or treated as a release pin until those components land upstream.

Prove: component behavior has existing regression evidence in their PRs. This change is build orchestration, so no new gameplay regression test or invented red/green evidence applies. Static baseline inspection confirms Tags has no build step. The first local full build stopped at an absent jar executable; that is an environment failure, not behavioral proof.

Engine/arch: run existing Tags verification/bootstrap tooling; install the pilot from the actual network renderer submodule immediately before Tags verification, replacing the standalone bootstrap compile artifact. Retain the separate root renderer and pilot artifacts and their existing responsibilities. No component source patches or deployment-script edits.

Refine: validate current component sources and actual renderer together; exercise normal network build as far as existing dependencies permit; inspect hosted checks and actionable findings for the exact draft head. This network repository has no EARS/state helper. Requirements, phase evidence and limitations live here; no helper pass is claimed.

## Release gates

This draft is not a production release. After Playtime #27, Tags #23 and renderer #18 merge, replace all three candidate pins with exact canonical merged commits, rerun the combined build and inspect exact-head checks. The pilot is a separate renderer artifact with the same plugin name as the root renderer; they are alternative runtime profiles and must not both be installed. Native Tags acceptance requires the pilot profile and actual client/server testing. Production remains untouched.

## Evidence

- Candidate pins: Playtime ffd2abaa63b259a1d3466eb16da81cf5db4b9539, Tags be05125d342ee57245943a0e2da3cd13ce1a40cd, renderer ca8c2a170d5639fb6eadc58bb4577b5ec96c0540. All remain unmerged; this PR is intentionally draft. The renderer's final refinement only records the verified results in docs.
- Fresh candidate network checkout: Playtime clean verify passed 218 tests. Actual pinned renderer afe40d9 pilot clean install passed; Tags clean verify against that installed API passed 250 tests and its shaded SQLite read-only probe passed.
- Canonical dependency data was validated before fetching the RoseChat contract and LoreItems release; LoreItems SHA-256 matched its pinned POM. This local compatibility run used PowerShell equivalents because Bash is absent from the local runtime. Actual Bash orchestration still requires a hosted network run; upstream run 37216229727 requires maintainer approval. Automatic approval review rejected local portable Bash setup with only 'blocked by policy'; remaining checks use the installed Java tools and workspace-local checksum-verified Java profiles.
- Full network baseline reached Playtime API staging but the local PATH lacked jar. This is corrected for further local checks by using the complete installed Java 25 bin directory; no global environment setting changed.
- Root renderer's legacy Playtime filename is corrected in BadgersMC/EnthusiaAdvancements PR #18. Its candidate pin accepts the exact ENTHUSIAPLAYTIME_JAR exported by network scripts/CI. A real Gradle classpath check passed for the exact 3.7.2 jar and its PlayerPlaytimeTickEvent API. No renamed duplicate plugin jar is introduced.
- Local combined Gradle buildAll passed 22 tasks (16 executed, 6 up-to-date), including root renderer compileKotlin/shadowJar and all six composite plugin artifacts. Windows equivalent dependency steps built the pinned CombatLogX API, RoseChat, Nexus, Guilds and Market first. Complete JDK 21/25 toolchain paths were supplied locally; no global environment configuration changed.
- Local SPEAR spec/prove/engine/arch/refine complete for integration preparation. Hosted Bash/build-all verification still requires maintainer approval; standalone biomes and live client/server acceptance are not claimed by this combined Gradle result. Hosted results are recorded for the exact draft head in the PR.
