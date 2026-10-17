# Integration tasks

- [ ] INFRA-004: Integrate merged EnthusiaArmorStands without changing existing pins.
  References: REQ-003; docs/implementation.md, EnthusiaArmorStands.
  Evidence: FainNeito/EnthusiaArmorStands PR #1 merged as `bb03231483b007375f792de660cc4f959c1c2300`; network main `559bfab`; .gitmodules; scripts/build-all.sh; scripts/build-all.bat; .github/workflows/build.yml; .github/workflows/upstream-watch.yml. See ci/enthusia-armorstands/README.md for verification and CI access gates.
  SPEAR: Infrastructure-only pin/build orchestration. No plugin behavior changes, so behavioral prove/engine phases do not apply; verification consists of clean pinned build, descriptor/pin checks, EARS, YAML and exact-head CI. Use the existing pinned Signature SPEAR helper from the network root; do not modify that submodule. No automatic deploy, production permissions or restart.
  Verification: pinned submodule Maven clean verify passed 22 tests on Java 25; Windows network helper also passed its new ArmorStands step. EARS and YAML parse passed. Existing 22 pins are unchanged. Task stays open pending exact-head and trusted whole-network checks with private credentials.
  Combined-build limit: Windows helper continued through legacy Maven dependencies, Signature's 77 tests and nine importer checks, then failed in the unchanged Playtime artifact PowerShell query (literal caret argument). Upstream PR #190 carries the integration and remaining private credential/combined-build gates.

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
