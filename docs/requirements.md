# Monorepo integration requirements

### REQ-003 — Standalone canonical plugin builds

WHEN hosted network verification runs THE SYSTEM SHALL select checksum-verified
Apache Maven 3.9.11, matching the locally verified canonical quality gates,
rather than inheriting an unversioned runner tool. All static checks and tests
remain mandatory; this requirement changes build infrastructure only.

WHEN the network build runs THE SYSTEM SHALL verify and package clean pinned StartupGuardian, DiscordSRV, InteractiveChat Discord add-on and EnthusiaServerAutoClicker source using each repository's canonical quality gate and required Java version.

IF a required toolchain, clean source pin, artifact, or executed regression evidence is unavailable THEN THE SYSTEM SHALL fail verification without skipping quality gates or substituting binary overlays.

Acceptance: preserve all existing pins and private build gates; StartupGuardian uses Java 21 and Maven clean verify, DiscordSRV uses Java 25 and Gradle clean test shadowJar spotlessCheck, and the add-on uses Java 25 and the complete Maven clean verify reactor. Record source versions, hashes and test evidence. Server operations and automatic deployment remain outside this integration.

The AutoClicker repository SHALL build only its server-plugin directory on Java
21, run Maven clean verify and PMD 3.26.0, retain both public evidence API classes,
and reject packaged Bukkit/JUnit classes. Its client mod is not a server artifact.

### REQ-001 — EnthusiaSignature build pin

WHEN the network build runs THE SYSTEM SHALL verify and package the reviewed EnthusiaSignature submodule with its tests enabled, retain all existing plugin pins, and report its shaded artifact.

Acceptance: Unix and Windows helpers and GitHub Build invoke `mvn -B -ntp clean verify`; the submodule points to merged ItemSignature commit `2e60f42d29d67dc610d16d6564b2251e58731a13`; upstream watch tracks its canonical repository.

### REQ-002 — Halloween asset verification

WHEN the network build verifies EnthusiaSignature THE SYSTEM SHALL run its Halloween importer regression checks using the pinned Python dependencies.

Acceptance: Unix and Windows helpers and CI run the nine importer checks from the pinned source. Licensed images remain outside Git, all other plugin pins remain unchanged, and live asset placement does not replace a plugin JAR or authorize activation.
