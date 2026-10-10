# Integration architecture

## EnthusiaCommend

The Commend gitlink follows authoritative `wsg138/EnthusiaCommend` main at
`580eed61b8639c40ba07252cd1377b5c0dfea501` (2.14.0-test9). The old BadgersMC
fork pin was `2083061b8aeaa7fb3adaf89746f91a45e3a03e59` (2.13.1). The upstream
watcher already follows wsg138, so checkout and monitoring now agree.
EnthusiaAdvancements discovers `EnthusiaCommend-*.jar` through its existing
fileTree contract; a version-specific alias or binary overlay is unnecessary.
Plugin implementation stays in its source repository. The merged Policy v2
foundations remain unwired, and this infrastructure update activates nothing.

## Layer Dependency Rules

The monorepo owns infrastructure orchestration and immutable Git submodule pins. Plugin domain/application/platform code remains in each authoritative repository. This change introduces no application imports or runtime adapters.

## Forbidden Domain Annotations

forbidden: [org.springframework.*, jakarta.persistence.*, javax.persistence.*, com.fasterxml.jackson.*, io.micronaut.*, lombok.*]

## EnthusiaSignature

`plugins/enthusia-signature` references `FainNeito/ItemSignature`. Its independent Maven build targets Java 21 and produces `target/EnthusiaSignature-1.3.0.jar`; do not register it as a Gradle composite build. Existing network Java 25 builders also support its Java 21 bytecode. The optional native spear listener is capability-gated by the plugin.

Unix/Windows helpers and CI run its complete verification separately from Maven compile dependencies that skip tests. Upstream watch follows its main branch. No item data, defaults, permissions, other submodule pins, or deployment actions change.

The Halloween pin includes the offline Nexo importer and its nine checks. Network helpers and CI install its pinned PyYAML requirement and run those checks alongside Maven verification. Purchased textures and generated packs stay outside Git. The additive installation contains fifteen textures and one glyph catalog with `is_emoji: false`; it requires no plugin JAR upgrade. Source pinning, live file placement, Nexo regeneration, and client acceptance are separate operations.
