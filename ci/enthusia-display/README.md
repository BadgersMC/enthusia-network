# EnthusiaDisplay integration

## Requirements and scope (SPEAR spec)

- ED-NET-001: WHEN the network is checked out recursively, THE BUILD SHALL obtain `plugins/enthusia-display` from `FainNeito/EnthusiaDisplay`, pinned to reviewed merged commit `1734f4329ecb8cd10203fed162e4c0bc3ae27a72`.
- ED-NET-002: WHEN `buildAll` or either platform's build helper runs, THE BUILD SHALL test and package both the Paper backend and Velocity companion with Java 25, using the network's pinned RoseChat build.
- ED-NET-003: IF required compile APIs are unavailable or checked-out source differs from its gitlink, THEN THE BUILD SHALL fail with an actionable error rather than publish an incomplete artifact.
- ED-NET-004: WHEN a build succeeds, THE BUILD SHALL record source pins, dependency and artifact SHA-256 hashes, versions, and test counts. Server placement and activation remain separate operations.

This is build infrastructure; plugin behavior and persistence are unchanged. Behavioral engine proof is not applicable. Proof consists of missing-input failure, pinned companion build/API compatibility, backend/proxy tests and packaging. The repository has no EARS validator or SPEAR state helper; this document records requirements, tasks and evidence.

## Build contract

EnthusiaDisplay remains outside the composite so its standalone root and `proxy` build use its own wrapper without sharing Kotlin plugin versions with other plugins. Root `buildAll` invokes `buildDisplay`; root `cleanAll` cleans both Display projects. Build helpers reuse the RoseChat artifact they just built. Direct `buildDisplay` builds pinned RoseChat first.

Requirements: Python 3.11+ (set `PYTHON_BIN` if it is not named `python`), Git, JDK 25 for Display and JDK 21 for the currently pinned RoseChat toolchain. Both Java installations must be discoverable by Gradle. Supply licensed/local API dependencies through:

- `ENTHUSIADISPLAY_UNT_JAR`: absolute path to UnlimitedNameTags 2.0.2 with the `UntNametagDisplayCore` API (the Enthusia rendering fix). An unpatched upstream jar is insufficient.
- `ENTHUSIADISPLAY_PAPI_JAR`: absolute path to PlaceholderAPI 2.12.3.

Alternatively put these files in the ignored Display `libs/` directory as `UnlimitedNametags.jar` and `PlaceholderAPI-2.12.3.jar`. No dependency binary is committed or redistributed here. CI requires approved HTTPS download URLs and SHA-256 values in repository variables `ENTHUSIADISPLAY_UNT_JAR_URL`, `ENTHUSIADISPLAY_UNT_JAR_SHA256`, `ENTHUSIADISPLAY_PAPI_JAR_URL`, and `ENTHUSIADISPLAY_PAPI_JAR_SHA256`; absent values fail the build with an explicit dependency error.

The standalone Display repository is currently private. Recursive local clones need authorized Git credentials. CI also needs a read-only `ENTHUSIADISPLAY_READ_TOKEN` secret with access to this monorepo and the Display repository; the default Actions token cannot read another private repository. Fork PRs do not receive that secret. Upstream-watch likewise needs this token to query Display commits; its existing repository token retains issue creation authority. Do not merge before the owner has configured these inputs and completed checks in an authorized environment.

```bash
python scripts/build-display.py --clean
# or, after all submodules are initialized:
./gradlew buildDisplay
```

The helper adds the official Paper Maven repository through a scoped init script, because the pinned Display build otherwise expects Paper API in Maven local. It does not modify the plugin source. `--rosechat-built` is reserved for build orchestration after the pinned RoseChat build; a preexisting jar alone does not establish clean release provenance.

Outputs: `plugins/enthusia-display/build/libs/EnthusiaDisplay.jar`, `plugins/enthusia-display/proxy/build/libs/EnthusiaDisplayProxy-0.1.5-test.jar`, and ignored `build/enthusia-display/provenance.json`. Versions retain their source `-test` labels. The general backend deploy helper selects only `EnthusiaDisplay.jar`; the proxy jar must be separately reviewed and placed on Velocity. No hot-load, activation or restart is performed by this integration.

## Tasks and evidence

- [x] Inspect clean current network main, existing build orchestration, standalone requirements and reviewed merged source.
- [x] Add submodule, backend/proxy build orchestration, dependency contract, upstream tracking and documentation.
- [x] Verify canonical pinned RoseChat plus Display build and record exact results.
- [ ] Complete the whole network composite build and hosted checks after required dependencies and CI access are configured.
- [ ] Inspect exact PR head checks and actionable reviews; merge requires the normal repository gate and permissions.
- [ ] Live server/client acceptance remains outside this build integration.

Initial local baseline: RoseChat build stopped because JDK 21 was not installed/discoverable. A local isolated JDK 21 resolved this environment prerequisite; no plugin code changed. Missing Display API input failed before Gradle work with an actionable environment-variable error.

Local verification on 4 October 2026: network base `876d401431b548b8ecdf559169b1e2f3f7c72f1d`; Display pin `1734f4329ecb8cd10203fed162e4c0bc3ae27a72`; RoseChat pin `cf8a7b040f7194a0bf26d98096493bbb7e53efa9`. Clean pinned RoseChat `shadowJar` succeeded using JDK 21. Display's clean backend/proxy test and jar build against that exact RoseChat artifact succeeded on JDK 25: 77 tests, zero failures/errors/skips. Backend version `0.1.8-test`, SHA-256 `0580897457291b7d6f9dd0176b2604a090e07c321632bfdc4d5345c5c349f0d9`; proxy version `0.1.5-test`, SHA-256 `fdddb24254e81ee894afe443ee34bcde35b44ed80dd23e377de4b09dbea86b22`. Dependency hashes are in the helper's ignored provenance file. Workflow YAML parses; helper Python compiles; `git diff --check` passes.

Whole-network `buildAll --dry-run --offline` stopped while configuring the existing EnthusiaMarket build: `com.github.BadgersMC.Nexus:nexus-permissions-gradle:057836b` is not in the local cache. This does not establish a network build pass or a Display regression. The normal network helpers first publish the pinned Nexus dependency; that whole preparation/build path and hosted checks remain required before merge. No server files, databases, permissions, activation or restarts changed.
