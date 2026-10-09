# Integration architecture

## Layer Dependency Rules

The monorepo owns infrastructure orchestration and immutable Git submodule pins. Plugin domain/application/platform code remains in each authoritative repository. This change introduces no application imports or runtime adapters.

## Forbidden Domain Annotations

forbidden: [org.springframework.*, jakarta.persistence.*, javax.persistence.*, com.fasterxml.jackson.*, io.micronaut.*, lombok.*]

## EnthusiaKOTH

KOTH stays outside the Gradle 9 composite: `buildKoth` uses its Gradle 8 wrapper with explicit `KOTH_JAVA_HOME` or `JAVA_HOME_21_X64`. Its real Guilds contract suite uses the discoverable Java 25 launcher. `buildAll` depends on this task and its freshly built Guilds artifact; `cleanAll` also cleans KOTH. Missing providers or a wrong runner fail instead of skipping verification.

The Git pins are KOTH `b6f4a50716005f6c8cd88e778ef69dd1343d5ef2`, Guilds `352406f2498afc412a976289f43e158da92317e0`, and Advancements `2736261976480891fcf298ad4305e7dc44910eca`. Guilds requires the moderation API built from EnthusiaStaff `8539bb8c77d7ecaf083546dda7ca8ccbfa8064e6`, matching Guilds CI. A shared Python helper stages that compile dependency for both platform helpers and hosted builds. It refuses dirty dependency source and cleans the API output before selecting exactly one JAR.

Supplying `ENTHUSIA_LORE_API_JAR` additionally verifies KOTH's read-only readiness contract against the real provider artifact. Without it, the helper explicitly reports omitted LoreItems contract verification. The optional V1 query fails closed on older runtimes while preserving delivery compatibility; companion LoreItems PR #40 must pass upstream checks and merge before release use. The network does not pin an unmerged companion candidate.

The full Advancements renderer and pilot remain distinct build profiles. TEST currently runs the pilot; KOTH verified display notifications are compatible with that provider. Do not replace it with the full renderer or install both without a separate runtime migration. Thresholds, reward pools, tag grants and exclusive templates remain inactive until TEST calibration. TEST ownership records must never be imported into the lifetime production registry.

The platform helpers and CI copy the freshly built Guilds and Market artifacts into `build/compile-api` before running the composite. These compile inputs remain stable while included builds rewrite their own shaded outputs. This prevents dependent compilers from reading an incomplete provider JAR; the copies contain the real pinned providers rather than API fixtures.

## EnthusiaSignature

`plugins/enthusia-signature` references `FainNeito/ItemSignature`. Its independent Maven build targets Java 21 and produces `target/EnthusiaSignature-1.3.0.jar`; do not register it as a Gradle composite build. Existing network Java 25 builders also support its Java 21 bytecode. The optional native spear listener is capability-gated by the plugin.

Unix/Windows helpers and CI run its complete verification separately from Maven compile dependencies that skip tests. Upstream watch follows its main branch. No item data, defaults, permissions, other submodule pins, or deployment actions change.

The Halloween pin includes the offline Nexo importer and its nine checks. Network helpers and CI install its pinned PyYAML requirement and run those checks alongside Maven verification. Purchased textures and generated packs stay outside Git. The additive installation contains fifteen textures and one glyph catalog with `is_emoji: false`; it requires no plugin JAR upgrade. Source pinning, live file placement, Nexo regeneration, and client acceptance are separate operations.
