# Chapter 2 source and pin reconciliation

## Requirements and task (SPEAR spec)

- NET-C2-01: WHEN the network builds the advancement pilot, THE BUILD SHALL use reviewed canonical merged source containing the gold/dark-red Minecraft announcements and compact Discord icons.
- NET-C2-02: IF any component is unmerged or required integration checks are incomplete, THEN THE RELEASE SHALL remain blocked rather than equating a candidate pin with production acceptance.
- NET-C2-03: WHEN source integration is prepared, THE TASK SHALL leave all production files, configurations and processes unchanged.

Task: update only the advancement gitlink from ca8c2a170d5639fb6eadc58bb4577b5ec96c0540 to canonical main af9cd7772d14fce201d58df28c3ef5c32e335319 (merged BadgersMC/EnthusiaAdvancements #19). Preserve all other pins and the private Display gate. This is build infrastructure, not new plugin behavior; behavioral proof and engine changes are not applicable. No EARS/state helper exists in this repository; this file records the scoped requirements and evidence.

## Prove / engine / architecture

Fresh canonical network base: bdd86de8223d8ab0c067c32aec965d3b6ac18002. Baseline gitlink lacks advancement presentation PR #19. The provider's merged commit is canonical main, not a local or unmerged test branch. The change uses the existing submodule/build path and does not add a second renderer plugin. Root renderer and pilot remain alternative runtime profiles with the same plugin name; never install both.

## Refine and release gates

Static verification confirms the provider checkout is clean at the exact merged pin. The existing build-tags.sh strict version validator rejects this candidate: Tags requires 1.0.0-pilot.5 while merged advancement source declares 1.0.0-pilot.6-chat-colors-test.4. Updating Tags' checksum-pinned companion dependency through its source PR and testing against the real provider is required before this draft can merge. Do not bypass the validator, relabel artifacts or treat this draft as release-ready.

Whole-network hosted run 37255555304 failed before compilation because ENTHUSIADISPLAY_READ_TOKEN is missing. Authorized maintainers must configure that read-only secret and the approved Display API URL/hash variables, then complete trusted combined verification. Fork checks skip private Display and cannot establish a complete network pass. Do not weaken this gate or redistribute private dependencies.

Current GitHub identity FainNeito cannot merge the network or most upstream component repositories. PlayTimePlugin #27 and EnthusiaTags #23 remain unmerged, despite their existing candidate network pins; replace those pins with canonical merged commits only after maintainer merges. Playtime needs hosted workflow approval. Tags exact-head verify/artifact/Codacy checks pass, but its upstream CodeRabbit status represents a skipped automatic review, not substantive approval. WarzoneDuels #21 still reports open lifecycle/recovery findings and action-required Codacy. UnlimitedNametags #101 remains draft with a failing CodeFactor status. RoseChat #21 targets wsg138, while the network uses BadgersMC's diverged fork; reconcile lineage before changing that pin. MapShields' newer local build still needs canonical source reconciliation; no blind downgrade or binary import is performed.

No claim of all recent work merged, complete combined build, or player/client acceptance is made. No production changes are authorized or performed by this source task.
