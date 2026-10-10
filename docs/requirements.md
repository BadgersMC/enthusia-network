# Monorepo integration requirements

### REQ-001 — EnthusiaSignature build pin

WHEN the network build runs THE SYSTEM SHALL verify and package the reviewed EnthusiaSignature submodule with its tests enabled, retain all existing plugin pins, and report its shaded artifact.

Acceptance: Unix and Windows helpers and GitHub Build invoke `mvn -B -ntp clean verify`; the submodule points to merged ItemSignature commit `2e60f42d29d67dc610d16d6564b2251e58731a13`; upstream watch tracks its canonical repository.

### REQ-002 — Halloween asset verification

WHEN the network build verifies EnthusiaSignature THE SYSTEM SHALL run its Halloween importer regression checks using the pinned Python dependencies.

Acceptance: Unix and Windows helpers and CI run the nine importer checks from the pinned source. Licensed images remain outside Git, all other plugin pins remain unchanged, and live asset placement does not replace a plugin JAR or authorize activation.

### REQ-003 — Verified KOTH dependency set

WHEN the network build runs THE SYSTEM SHALL test and package the merged KOTH pin against the real merged LumaGuilds artifact, stage the pinned Staff moderation API required by Guilds, and retain the compatible EnthusiaAdvancements pilot provider.

Acceptance: KOTH runs its Java 21 wrapper, unit tests and Java 25 actualGuildApiTest; missing JDK 21 or provider JAR fails explicitly. The network updates only the KOTH, Guilds and Advancements gitlinks. Source pins, artifact hashes, hosted results and TEST acceptance remain separate evidence.

### REQ-004 — Optional LoreItems provider verification

WHEN a real LoreItems provider JAR is supplied THE SYSTEM SHALL run the pinned KOTH read-only definition contract suite against that artifact and reject a missing supplied file.

Acceptance: `ENTHUSIA_LORE_API_JAR` enables `actualLoreApiTest`; absence is explicitly reported as omitted verification, never as passing provider acceptance. An unmerged companion test artifact is not a canonical release dependency. Existing Guilds checks and plugin pins remain required.
