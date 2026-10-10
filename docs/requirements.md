# Monorepo integration requirements

### REQ-004 — Canonical Commend main pin

WHEN a fresh network checkout initializes EnthusiaCommend THE SYSTEM SHALL fetch wsg138/EnthusiaCommend and select merged main commit 580eed61b8639c40ba07252cd1377b5c0dfea501.

Acceptance: build version 2.14.0-test9, preserve every other gitlink and the existing EnthusiaAdvancements artifact discovery contract, and record canonical verification evidence. This pin update performs no deployment, restart, reload, or Policy v2 runtime activation.

### REQ-001 — EnthusiaSignature build pin

WHEN the network build runs THE SYSTEM SHALL verify and package the reviewed EnthusiaSignature submodule with its tests enabled, retain all existing plugin pins, and report its shaded artifact.

Acceptance: Unix and Windows helpers and GitHub Build invoke `mvn -B -ntp clean verify`; the submodule points to merged ItemSignature commit `2e60f42d29d67dc610d16d6564b2251e58731a13`; upstream watch tracks its canonical repository.

### REQ-002 — Halloween asset verification

WHEN the network build verifies EnthusiaSignature THE SYSTEM SHALL run its Halloween importer regression checks using the pinned Python dependencies.

Acceptance: Unix and Windows helpers and CI run the nine importer checks from the pinned source. Licensed images remain outside Git, all other plugin pins remain unchanged, and live asset placement does not replace a plugin JAR or authorize activation.
