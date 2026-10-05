# Chapter 2 source and pin reconciliation

## Latest reconciliation

Tags PR #23 is merged upstream as 28048ca64d460534fd8bac2d6295f7283b4aa27d. This rebased PR pins that canonical merged commit. LumaGuilds and EnthusiaAdvancements were independently advanced on network main by PR #164, so this PR no longer changes either of those gitlinks. The Tags source tree is identical to aa7a7d7, whose verify/artifact/Codacy gates passed; this is provenance reconciliation, not a plugin behavior change.

Network PR #149's previous public build passed at 7a0175c, but skipped private Display. Secure Display inputs remain unverified: the current account cannot list repository Actions secrets/variables (403); this does not prove whether the inputs are present. Authorized maintainers must complete the trusted build. No token, account permissions, production file or process changes are made.

RoseChat's network-owned source reconciliation is draft BadgersMC/Enthusia-RoseChat #9, not an automatic change to this monorepo's RoseChat gitlink. PlayTimePlugin #27 remains open. UnlimitedNametags #101 now has passing fork CI and CodeFactor on e55b183, while upstream runner startup failed. WarzoneDuels #21 remains open with Codacy action_required and fresh substantive review pending. These distinctions supersede the older gate snapshot below.

## Requirements and task (SPEAR spec)

- NET-C2-01: WHEN the network builds the advancement pilot, THE BUILD SHALL use reviewed canonical merged source containing the gold/dark-red Minecraft announcements and compact Discord icons.
- NET-C2-02: IF any component is unmerged or required integration checks are incomplete, THEN THE RELEASE SHALL remain blocked rather than equating a candidate pin with production acceptance.
- NET-C2-03: WHEN source integration is prepared, THE TASK SHALL leave all production files, configurations and processes unchanged.

Task: update only the EnthusiaTags gitlink from be05125d342ee57245943a0e2da3cd13ce1a40cd to canonical merged main 28048ca64d460534fd8bac2d6295f7283b4aa27d. Preserve the current network-main LumaGuilds and EnthusiaAdvancements pins from PR #164, all other pins, and the private Display gate. This is build infrastructure, not new plugin behavior; behavioral proof and engine changes are not applicable. No EARS/state helper exists in this repository; this file records the scoped requirements and evidence.

## Prove / engine / architecture

Fresh canonical network base after PR #164: b32f9ad49c4491fe181adab29799491e7ef01a05. That base already pins merged LumaGuilds progression work and EnthusiaAdvancements #20. This rebased change only advances EnthusiaTags to its canonical merged commit and keeps the existing submodule/build path unchanged. Root renderer and pilot remain alternative runtime profiles with the same plugin name; never install both.

## Refine and release gates

Static verification confirms the reviewed provider checkout is clean and that Tags PR #23 merged canonically as 28048ca64d460534fd8bac2d6295f7283b4aa27d. The initial strict validator exposed a mismatch: Tags required 1.0.0-pilot.5 while merged advancement source declared 1.0.0-pilot.6-chat-colors-test.4. The reviewed Tags changes pin that exact provider/version. Ten bootstrap tests, 12 Node tests, EARS, the real provider's 40 tests and Tags' 250 tests passed on the reviewed candidate; the candidate-to-merge Tags tree diff is empty. No validator bypass or artifact relabeling occurred.

Whole-network hosted run 37255555304 failed before compilation because ENTHUSIADISPLAY_READ_TOKEN is missing. Authorized maintainers must configure that read-only secret and the approved Display API URL/hash variables, then complete trusted combined verification. Fork checks skip private Display and cannot establish a complete network pass. Do not weaken this gate or redistribute private dependencies.

Merge-permission changes are outside the user's requested scope. PlayTimePlugin #27 remains open and still needs hosted workflow approval. EnthusiaTags #23 is merged and this PR pins its canonical merge commit. LumaGuilds #206 and EnthusiaAdvancements #20 are merged and already pinned by network PR #164. WarzoneDuels #21 still requires exact-head hosted checks/review. UnlimitedNametags #101 requires fresh CodeFactor validation after cleanup. RoseChat lineage and MapShields source reconciliation remain separate release tasks; no blind downgrade or binary import is performed.

No claim of all recent work merged, complete combined build, or player/client acceptance is made. No production changes are authorized or performed by this source task.
