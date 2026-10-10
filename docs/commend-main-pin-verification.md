# Commend main pin verification

Base: canonical network main `559bfabc2187ab796a3be889f032383a8041f819`.
Old pin: `2083061b8aeaa7fb3adaf89746f91a45e3a03e59` from BadgersMC/EnthusiaCommend.
Requested pin: `580eed61b8639c40ba07252cd1377b5c0dfea501` from wsg138/EnthusiaCommend.
Version: `2.14.0-test9`.

The exact requested main source passed hosted verify and PMD and published an
artifact in https://github.com/wsg138/EnthusiaCommend/actions/runs/37876808534.
The uploaded main JAR has SHA-256
`8f2a01264f5af7410e7b056ffb952a77c8507bb2fdaa1256a91884190ad6a629`.

The user separately authorized its production file upload and backup. API
readback verified both hashes and a single active Commend JAR file. No restart
or reload occurred; uploaded files are not evidence that the new version is
running. This PR changes only source ownership, the pin, and delivery evidence.

## Local verification

- The canonical repository was fetched and the clean submodule checked out at
  the exact requested commit, which is reachable from authoritative main.
- Java 21 / Maven 3.9.11 `clean verify`: success; 248 tests discovered,
  241 executed, zero failures/errors, seven Linux-only filesystem tests skipped
  by the existing `@EnabledOnOs(OS.LINUX)` conditions on this Windows host.
- Canonical `maven-pmd-plugin:3.26.0:pmd`: success.
- Existing portable EARS validator and state helper: pass; the infrastructure
  cycle records spec -> arch -> refine without inventing red/green behavior.
- Whitespace validation passes; Commend is the sole changed plugin gitlink.
- The existing pinned Advancements build uses a wildcard Commend artifact
  contract and therefore accepts `EnthusiaCommend-2.14.0-test9.jar` unchanged.

Logs and portable state remain ignored local evidence. Exact-head combined
hosted CI is a separate pending merge gate; no full local network build is
claimed. Private build gates and unrelated open network PRs remain unchanged.
