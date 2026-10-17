# Integration architecture

## Layer Dependency Rules

The monorepo owns infrastructure orchestration and immutable Git submodule pins. Plugin domain/application/platform code remains in each authoritative repository. This change introduces no application imports or runtime adapters.

## Forbidden Domain Annotations

forbidden: [org.springframework.*, jakarta.persistence.*, javax.persistence.*, com.fasterxml.jackson.*, io.micronaut.*, lombok.*]

## EnthusiaSignature

`plugins/enthusia-signature` references `FainNeito/ItemSignature`. Its independent Maven build targets Java 21 and produces `target/EnthusiaSignature-1.3.0.jar`; do not register it as a Gradle composite build. Existing network Java 25 builders also support its Java 21 bytecode. The optional native spear listener is capability-gated by the plugin.

Unix/Windows helpers and CI run its complete verification separately from Maven compile dependencies that skip tests. Upstream watch follows its main branch. No item data, defaults, permissions, other submodule pins, or deployment actions change.

The Halloween pin includes the offline Nexo importer and its nine checks. Network helpers and CI install its pinned PyYAML requirement and run those checks alongside Maven verification. Purchased textures and generated packs stay outside Git. The additive installation contains fifteen textures and one glyph catalog with `is_emoji: false`; it requires no plugin JAR upgrade. Source pinning, live file placement, Nexo regeneration, and client acceptance are separate operations.

## EnthusiaArmorStands

`plugins/enthusia-armorstands` pins private `FainNeito/EnthusiaArmorStands` at merged commit `bb03231483b007375f792de660cc4f959c1c2300`. Its Maven build is independent of Gradle composite dependency substitution. Both platform helpers and trusted CI use Java 25 and run its full clean verification; the result is `target/EnthusiaArmorStands-0.1.0-SNAPSHOT.jar`.

CI and upstream-watch require the read-only `ENTHUSIAARMORSTANDS_READ_TOKEN` secret for the source repository. Fork PRs do not receive it, so they skip private checkout and verification with an explicit warning. A public/fork CI pass cannot satisfy the private integration gate. No source visibility or token grants are changed by this integration.

The existing backend deploy helper does not copy this Maven artifact. Replacing BedrockArmorstands requires a separate authorized deployment with backup, removal of the old active JAR, and restart. Both permission nodes default true in source; production must receive the reviewed rank allow/deny policy in its actual LuckPerms server context before activation. TEST grants (`server=test`) do not secure production. User-confirmed TEST acceptance is independent of this build change.
