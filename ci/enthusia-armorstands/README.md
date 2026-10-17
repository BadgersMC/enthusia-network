# EnthusiaArmorStands integration

Source: private `FainNeito/EnthusiaArmorStands`, merged PR #1 commit `bb03231483b007375f792de660cc4f959c1c2300`. Network base: `559bfab`. This submodule pin retains standalone source ownership and all existing network pins.

## Build and access contract

Requires Java 25 and Maven. Unix/Windows network helpers and trusted Build CI invoke `mvn -B -ntp clean verify` in `plugins/enthusia-armorstands`, with no test-skip flag. Artifact: `plugins/enthusia-armorstands/target/EnthusiaArmorStands-0.1.0-SNAPSHOT.jar`. No additional runtime dependencies or Gradle composite membership are needed. Root `./gradlew buildAll` alone does not build standalone Maven plugins; use the platform network helper.

The source stays private. The owner/maintainer must configure a read-only `ENTHUSIAARMORSTANDS_READ_TOKEN` secret with repository contents access to `FainNeito/EnthusiaArmorStands`. Trusted CI fails explicitly without it. Upstream-watch uses that credential for source commit/compare reads while the monorepo Actions token retains issue authority. Tokens are not committed. Fork PRs cannot receive these credentials; their public build reports skipped private checkout/verification, and cannot establish a full network release pass. No `pull_request_target` execution or untrusted-source secret exposure is introduced.

For local verification after an authorized submodule checkout:

```sh
cd plugins/enthusia-armorstands
mvn -B -ntp clean verify
```

## SPEAR / verification

REQ-003 / INFRA-004. This changes infrastructure orchestration and an immutable source pin; plugin behavior is unchanged, so behavioral prove/engine do not apply. Existing pinned Signature EARS/state helpers are run from the network root. Source, build, runtime and player acceptance remain separate.

- [x] Fetch current canonical network main and standalone main; inspect clean source and build conventions.
- [x] Pin the merged ArmorStands commit and wire Unix/Windows verification, authenticated CI, and upstream tracking.
- [x] Run EARS, YAML, pin preservation, local clean Maven regression build and artifact descriptor checks.
- [ ] Inspect exact-head upstream PR checks and reviews.
- [ ] Complete trusted whole-network CI with private credentials and existing Display prerequisites before merge/release.

Local verification on 17 October 2026: clean Maven verification from the network's pinned submodule passed all 22 tests on Java 25 / Paper `26.2.build.128-stable`. The Windows network helper also reached and passed the same new verification step before continuing to the existing dependencies. EARS validation and workflow YAML parsing passed. All 22 pre-existing gitlink pins are preserved. Artifact descriptor remains `EnthusiaArmorStands` / `0.1.0-SNAPSHOT` / API `26.2`; no Paper dependency is bundled. Whole-network and exact-head hosted results are recorded in the PR before delivery; a standalone pass is not a full network pass.

The complete Windows helper then built the existing Maven compile dependencies, passed Signature's 77 tests and nine importer checks, and failed at its pre-existing Playtime artifact query: PowerShell received a literal `^` token from the batch file's escaped pipeline. This integration does not change that existing query. The whole-network task therefore remains open, as does trusted private CI access. No full combined pass is claimed.

The user confirmed prior TEST permission, protection, pose rendering, persistence and duty-context acceptance on 17 October. That confirmation does not run or authorize a new deployment. The version remains the reviewed `0.1.0-SNAPSHOT`; this integration does not silently create a release version.

## Deployment boundary

The generic backend deploy helper intentionally does not copy this replacement. A separately authorized rollout must build from the clean merged network/plugin pins, back up the original JAR, apply the accepted rank policy in production's real LuckPerms server context, remove the original active BedrockArmorstands JAR, install the replacement, restart, and verify the loaded version/checksum. The two plugins must not run together; the replacement disables itself if the original is enabled. Source defaults allow both permission nodes, so TEST-context restrictions alone are insufficient for production.
