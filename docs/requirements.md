# Monorepo integration requirements

### REQ-001 — EnthusiaSignature build pin

WHEN the network build runs THE SYSTEM SHALL verify and package the reviewed EnthusiaSignature submodule with its tests enabled, retain all existing plugin pins, and report its shaded artifact.

Acceptance: Unix and Windows helpers and GitHub Build invoke `mvn -B -ntp clean verify`; the submodule points to merged ItemSignature commit `4c16c729ccca96fdd025387c36ea2cec2b17f706`; upstream watch tracks its canonical repository.
