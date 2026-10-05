# Integration tasks

- [x] INFRA-001: Add reviewed EnthusiaSignature to network builds and monitoring.
  References: REQ-001; docs/implementation.md, EnthusiaSignature.
  Evidence: .gitmodules; scripts/build-all.sh; scripts/build-all.bat; .github/workflows/build.yml; .github/workflows/upstream-watch.yml; FainNeito/ItemSignature PR #3 and main build https://github.com/FainNeito/ItemSignature/actions/runs/37249409319; plugins/enthusia-signature/pom.xml and TESTING.md.
  SPEAR: INFRA routing skips prove/engine because this changes build orchestration and a Git pin, not plugin behavior. The monorepo had no local SPEAR helpers; use the authoritative pinned plugin's `.agents/skills/spear-*` and `tools/spear/{state,ears}.mjs`, with state stored in the ignored root `.claude` directory. Architecture review preserves source ownership and all existing pins. Verification evidence will be recorded after execution; live client/server acceptance is separate.
  Verification: EARS validator passed. The pinned submodule's offline Maven clean verify passed on Java 25 targeting Java 21: 77 tests, zero failures/errors/skips. Git diff whitespace checks passed. No other gitlinks changed. Both helpers and CI run tests without skip flags; the watcher follows the same canonical repository. PR CI must still verify the combined network build before merge. No production upload or activation occurred.
