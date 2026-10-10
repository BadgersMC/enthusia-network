# Monorepo integration requirements

### REQ-001 — EnthusiaSignature build pin

WHEN the network build runs THE SYSTEM SHALL verify and package the reviewed EnthusiaSignature submodule with its tests enabled, retain all existing plugin pins, and report its shaded artifact.

Acceptance: Unix and Windows helpers and GitHub Build invoke `mvn -B -ntp clean verify`; the submodule points to merged ItemSignature commit `2e60f42d29d67dc610d16d6564b2251e58731a13`; upstream watch tracks its canonical repository.

### REQ-002 — Halloween asset verification

WHEN the network build verifies EnthusiaSignature THE SYSTEM SHALL run its Halloween importer regression checks using the pinned Python dependencies.

Acceptance: Unix and Windows helpers and CI run the nine importer checks from the pinned source. Licensed images remain outside Git, all other plugin pins remain unchanged, and live asset placement does not replace a plugin JAR or authorize activation.

### REQ-003 — Express source and upload traceability

WHEN an Express production file upload is recorded THE SYSTEM SHALL associate the monorepo Express pin with the authoritative merged source, artifact version and SHA-256, backup location, API verification evidence, and activation limits.

Acceptance: `plugins/enthusia-express` remains pinned to canonical main commit `a650216c6e795f900988b05d788de68b9d4a9866`; docs/express-main-upload-evidence-20261010.md records the October 10 upload and separates local artifact hashing, remote metadata, combined-build gates, and runtime activation. No other plugin pins change and no restart or reload is issued by this evidence update.
