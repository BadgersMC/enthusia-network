# Integration tasks

- [ ] INFRA-006: Reproduce the verified Maven toolchain in hosted builds.
  References: REQ-003; hosted run 37800713821; standalone-build-verification.md.
  Spec: select checksum-verified Maven 3.9.11 before any Maven invocation.
  Proof: the retry passes all add-on modules/proofs, then fails loading
  StartupGuardian SpotBugs with VelocityEngine.setProperties API incompatibility.
  Runner image 20261004.327.1 supplies Maven 3.10.0; the local clean gate uses
  Maven 3.9.11. Tool-version causality remains an inference pending hosted proof.
  Engine: no gameplay change; infrastructure selects the previously verified
  Maven release without skipping or modifying static checks/tests.
  Architecture/refine: pinned official archive SHA-512 verified; YAML/order,
  EARS and whitespace pass. Clean Maven 3.9.11 StartupGuardian verification
  passes locally, including SpotBugs. Hosted exact-head verification remains.

- [ ] INFRA-005: Add canonical server AutoClicker build and verify remaining repository contracts.
  References: REQ-003; docs/standalone-build-verification.md.
  Source: wsg138/EnthusiaAutoClicker main a29dac939687ed9cac1004d1e76c80bfd2666357.
  Local server-plugin Maven clean verify passes 39 tests and PMD 3.26.0.
  Build integration must retain nested project selection and API packaging gates.
  SPEAR: infrastructure-only; no gameplay engine changes. Helper regressions,
  exact-head CI/review and Paper/client acceptance are distinct gates.
  KOTH main f80adebb10f5be991abe20de41e505ebceb3d5a5 passes 158 tests;
  Trivia main a293dafb3427567ed40b72f20ba706b98b463202 passes 41 tests.
  Both canonical Java 21 clean test/shadowJar builds passed using Nexus 2.1.1,
  not the network's 2.3.0 substitution. KOTH uses a excluded compile shim and
  Trivia a checked-in legacy RoseChat API; real pinned companion contracts must
  be verified before integrating their builds. No server changes.
  Follow-up delivered: KOTH upstream #11 fixes system-bank dispatch, with nine
  new adapter regressions and 167 total passing local tests. Trivia upstream
  #56 verifies the actual cf8a7b04 network RoseChat artifact; explicit property,
  environment and default builds pass 41 tests. Review/hosted checks and source
  merge remain gates; no unmerged KOTH/Trivia gitlinks were added.

- [ ] INFRA-004: Add canonical standalone operational and Discord plugin builds.
  Follow-up: add-on owner #2 merged by explicit authorization as e04e2dbd.
  Its clean network-helper build passes all 46 modules and 55 proof checks;
  canonical merged hosted run 37796559490 also passes. Network 37796972150
  clears the duplicate model but fails a legacy CraftBukkit download with
  Connection reset. Exact-head combined and trusted/private gates remain open.
  References: REQ-003; docs/implementation.md, Standalone operational and Discord builds.
  Evidence: network main 559bfabc2187ab796a3be889f032383a8041f819 lacks these modules. StartupGuardian main 97e5032489f6dfa03c8878a725f6025f121a87e3 is merged PR #8 and requires Java [21,22)/Maven >=3.9. Owner DiscordSRV master 318ced607368d34d9fde7c238afea7deb6ab654d and add-on master 746cf2e33de06dc9e0dd36ebc1668fea5ce6e42f each contain merged owner PR #1. Their canonical hosted workflows prescribe full Gradle verification and the complete 46-module Maven reactor respectively. The owner explicitly selected both forks for monorepo ownership.
  SPEAR: infrastructure routing skips plugin behavioral prove/engine because no plugin implementation changes. Verify helper failure paths, exact pins, orchestration, canonical quality gates and artifacts. Root has no independent EARS/state tools; reuse the existing Signature portable helpers. Full network/private hosted checks and live/client acceptance remain separate gates. No production access or deployment.
  Verification: all three clean pinned canonical builds passed locally. StartupGuardian 1.1.1: 77 tests, zero failures/errors/skips, complete Maven static-analysis gates. DiscordSRV 1.30.5: 14 tests, zero failures/errors/skips, clean test/shadowJar/spotlessCheck. Add-on 2026.1.2.0: all 46 Maven reactor modules passed, executing 21 item-name, 24 plain-chat and 10 Staff visibility checks. Helper regression, EARS and whitespace validation pass; source and artifact SHA-256 evidence is recorded in docs/standalone-build-verification.md. Exact-head network CI/review and trusted private combined build remain pending; this task is not marked completed or approved for production.

- [x] INFRA-002: Pin merged Halloween asset tooling and verify it in network builds.
  References: REQ-002; docs/implementation.md, EnthusiaSignature.
  Evidence: FainNeito/ItemSignature PR #4, merged commit `2e60f42d29d67dc610d16d6564b2251e58731a13`; tools/resourcepack/test_prepare_halloween.py; resourcepack/halloween/requirements.txt; scripts/build-all.sh; scripts/build-all.bat; .github/workflows/build.yml.
  SPEAR: Infrastructure work skips prove/engine because no plugin behavior changes. The pinned plugin's portable state and EARS tools govern this cycle. Architecture preserves authoritative source ownership, all other gitlinks, and the separation of asset placement from runtime activation.
  Verification: Merged pinned source passed Maven clean verify (77 tests, zero failures/errors/skips), all nine importer regression checks, EARS validation, and whitespace checks. Exact-head combined network CI remains a merge gate; this record does not claim live/client activation. No plugin JAR will be uploaded for this asset addition.

- [x] INFRA-003: Replace the reviewed Tags candidate pin with canonical merged source.
  References: NET-C2-02 in docs/chapter2-release-reconciliation.md; docs/implementation.md infrastructure ownership.
  Evidence: wsg138/EnthusiaTags PR #23 merged as 28048ca64d460534fd8bac2d6295f7283b4aa27d; fetched origin/main; identical source tree to tested aa7a7d75507f1c880d7f81167f3b158884829eca. Only gitlink and evidence change. Behavioral prove/engine do not apply to an immutable build pin; hosted combined verification remains required and private Display must not be skipped for release acceptance.
  Verification: candidate-to-merge Git tree diff is empty; EARS and git diff whitespace checks pass. No runtime imports changed. Public combined hosted CI will run on the new PR head; this task's completed pin reconciliation is not a complete release gate.

- [x] INFRA-001: Add reviewed EnthusiaSignature to network builds and monitoring.
  References: REQ-001; docs/implementation.md, EnthusiaSignature.
  Evidence: .gitmodules; scripts/build-all.sh; scripts/build-all.bat; .github/workflows/build.yml; .github/workflows/upstream-watch.yml; FainNeito/ItemSignature PR #3 and main build https://github.com/FainNeito/ItemSignature/actions/runs/37249409319; plugins/enthusia-signature/pom.xml and TESTING.md.
  SPEAR: INFRA routing skips prove/engine because this changes build orchestration and a Git pin, not plugin behavior. The monorepo had no local SPEAR helpers; use the authoritative pinned plugin's `.agents/skills/spear-*` and `tools/spear/{state,ears}.mjs`, with state stored in the ignored root `.claude` directory. Architecture review preserves source ownership and all existing pins. Verification evidence will be recorded after execution; live client/server acceptance is separate.
  Verification: EARS validator passed. The pinned submodule's offline Maven clean verify passed on Java 25 targeting Java 21: 77 tests, zero failures/errors/skips. Git diff whitespace checks passed. No other gitlinks changed. Both helpers and CI run tests without skip flags; the watcher follows the same canonical repository. PR CI must still verify the combined network build before merge. No production upload or activation occurred.
