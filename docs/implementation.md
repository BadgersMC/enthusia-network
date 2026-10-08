# Integration architecture

## Standalone operational and Discord builds

`plugins/enthusia-autoclicker` pins wsg138/EnthusiaAutoClicker, but verification
selects only `server-plugin/`, not the root client-mod Gradle build. Java 21
Maven clean verify, PMD 3.26.0 and the canonical public API/no-Bukkit-or-JUnit
packaging assertions run before artifact provenance is written. No client mod
is copied to a backend. This is build ownership, not live runtime approval.

The network owns immutable pins for `wsg138/StartupGuardian`, `FainNeito/DiscordSRV` and `FainNeito/InteractiveChat-DiscordSRV-Addon`. Keep all three outside the Gradle composite: StartupGuardian requires Maven on Java 21; the Discord forks use their own Gradle/Maven lifecycles on Java 25. `scripts/build-standalone.py` verifies a clean gitlink checkout, selects the actual required Java installation, invokes the canonical quality gate and records ignored artifact provenance. Root buildAll/cleanAll invoke it; both platform helpers already call those tasks. Neither plugin source nor stored player state, permissions, configuration or server processes change.

DiscordSRV and the add-on are backend plugins, not Velocity replacements. The add-on pins 2026.1.2.0 and requires the corresponding real InteractiveChat dependency; no unpublished 2026.1.3.0 dependency, stub API or binary overlay is introduced. Its full reactor includes 26.2 and 26.3 adapters and executable presentation proofs. Runtime InteractiveChat backend/proxy coordination, EnthusiaStaff service compatibility, Discord notification/rendering and vanish/staffmode privacy acceptance remain deployment gates.

These artifacts are intentionally excluded from the existing automatic deploy helper. A new build entry is not approval to replace production files or activate StartupGuardian's whitelist/restart policies. Preserve existing Display private access and the separate Holidays/Friends trusted-build gates in PR #168.

## Layer Dependency Rules

The monorepo owns infrastructure orchestration and immutable Git submodule pins. Plugin domain/application/platform code remains in each authoritative repository. This change introduces no application imports or runtime adapters.

## Forbidden Domain Annotations

forbidden: [org.springframework.*, jakarta.persistence.*, javax.persistence.*, com.fasterxml.jackson.*, io.micronaut.*, lombok.*]

## EnthusiaSignature

`plugins/enthusia-signature` references `FainNeito/ItemSignature`. Its independent Maven build targets Java 21 and produces `target/EnthusiaSignature-1.3.0.jar`; do not register it as a Gradle composite build. Existing network Java 25 builders also support its Java 21 bytecode. The optional native spear listener is capability-gated by the plugin.

Unix/Windows helpers and CI run its complete verification separately from Maven compile dependencies that skip tests. Upstream watch follows its main branch. No item data, defaults, permissions, other submodule pins, or deployment actions change.

The Halloween pin includes the offline Nexo importer and its nine checks. Network helpers and CI install its pinned PyYAML requirement and run those checks alongside Maven verification. Purchased textures and generated packs stay outside Git. The additive installation contains fifteen textures and one glyph catalog with `is_emoji: false`; it requires no plugin JAR upgrade. Source pinning, live file placement, Nexo regeneration, and client acceptance are separate operations.
