# Standalone build integration verification — 2026-10-08

Network base: `559bfabc2187ab796a3be889f032383a8041f819`. Only four new
gitlinks were added; no previous pin or provider implementation changed.
Owner selected both Discord forks for network ownership. Canonical default
branches and merged source were verified before creating this isolated branch.

## Exact local clean-build evidence

| Source | Commit | Version | Gate and result |
| --- | --- | --- | --- |
| wsg138/StartupGuardian | 97e5032489f6dfa03c8878a725f6025f121a87e3 | 1.1.1 | Java 21 Maven clean verify; 77 tests, no failures/errors/skips; Checkstyle, PMD/CPD, SpotBugs passed |
| FainNeito/DiscordSRV | 318ced607368d34d9fde7c238afea7deb6ab654d | 1.30.5 | Java 25 Gradle clean test shadowJar spotlessCheck; 14 tests, no failures/errors/skips |
| FainNeito/InteractiveChat-DiscordSRV-Addon | 746cf2e33de06dc9e0dd36ebc1668fea5ce6e42f | 2026.1.2.0 | Java 25 Maven clean verify; all 46 modules passed; 21 item-name, 24 plain-chat, 10 Staff visibility checks |
| wsg138/EnthusiaAutoClicker (server-plugin only) | a29dac939687ed9cac1004d1e76c80bfd2666357 | 1.0.0 | Java 21 Maven clean verify + PMD 3.26.0; 39 tests, zero failures/errors/skips; both public evidence APIs packaged, Bukkit/JUnit excluded |

Artifact SHA-256 values from these builds (not reproducibility guarantees):

- StartupGuardian.jar: `98ca469c61280248a23f879ab0672ea149fa8fac235c9d3450dd766bb42320c0`
- DiscordSRV-1.30.5.jar: `3a808ccd3e4ccee537f3d447231c1c5df18c03dfc0fe0e50dc1f66d38d0d2c6f`
- InteractiveChatDiscordSrvAddon-2026.1.2.0.jar: `f5334e73172fce40aa953e9d2e63e0bf61b098aeb5ef9d23c09ddeb897fbb33a`
- EnthusiaServerAutoClicker.jar: `7317144350b7be442f9dfd4cf9d4835564d88aef184d4263a7d6175dd5d1d144`

AutoClicker's committed gradlew.bat is CRLF while its attributes normalize text.
The new local submodule needed an untracked info/attributes `-text` override for
that file to preserve its exact committed bytes during clean-source inspection.
No tracked source was edited or dirtiness ignored; canonical server Maven gates
run without the client Gradle wrapper. This is not a runtime compatibility claim.

## Hosted failure and canonical repair

Network PR #169 head 74d17c0 failed hosted run 37782503774 in the standalone
add-on Maven model validation: 44 identical duplicate Gson serializer entries.
The local Maven 3.9.11 pass above does not supersede that failure. Canonical owner
[add-on PR #2](https://github.com/FainNeito/InteractiveChat-DiscordSRV-Addon/pull/2)
head c7209f279836adb3f58d3a3ee96bf0c933f54387 removes only duplicate declarations
and adds hosted complete-reactor uniqueness checks. The new regression first
failed on 44 duplicates, then passed; all 46 modules and 55 presentation/privacy
assertions pass locally after repair. The network gitlink is intentionally still
merged 746cf2e3 until source review/CI/merge authorizes a canonical pin update.

## Remaining source contracts

- wsg138/EnthusiaKOTH main f80adebb10f5be991abe20de41e505ebceb3d5a5:
  Java 21 clean test/shadowJar passes 158 tests, zero failures/errors/skips.
  Canonical runtime dependency report resolves Nexus v2.1.1 without substituting
  network Nexus 2.3.0. The source shim signatures match the used API in network
  LumaGuilds pin a15b244e8a294bf18e6dedf722462edf9faa40ae, but KOTH bank calls
  pass guild UUID as actor UUID. The actual provider's permission/wallet semantics
  must be reconciled; signatures alone do not prove financial behavior. No KOTH
  gitlink or build entry has been added.
- BadgersMC/LumaTrivia main a293dafb3427567ed40b72f20ba706b98b463202:
  Java 21 clean test/shadowJar passes 41 tests, zero failures/errors/skips using
  Nexus v2.1.1. RosePlayer(Player), PlayerData mute/query methods and Channel ID
  source signatures exist at network RoseChat pin cf8a7b040f7194a0bf26d98096493bbb7e53efa9.
  The canonical build still compiles a checked-in legacy RoseChat JAR; exact
  built-network companion compilation and actual chat/mute integration remain
  gates. No Trivia gitlink/build entry has been added.

The helper checks clean gitlink/source parity before and after a build, requires
actual executed regression evidence, rejects wrong Java versions/missing tools,
and invalidates old success provenance before any new attempt. Its regression
suite covers missing/wrong tools, source mismatch/dirtiness, complete commands,
missing/all-skipped/failed reports, all three add-on proof outputs, and stale
provenance invalidation. Existing portable Signature EARS/state helpers are used
for the infrastructure SPEAR cycle; no new gameplay red/green claim is made.

## Remaining acceptance

The network PR must pass exact-head hosted verification and review. Its fork CI
skips private Display, so a successful public build is not a complete trusted
network release. PR #168 separately adds private Holidays/Friends and has the
same distinction. No skips were added or private gates weakened by this change.

Local clean standalone builds do not prove the entire Gradle composite. Nor do
they prove actual Discord item images, notification escaping, linked offline
senders, Staff vanish/staffmode privacy or live startup behavior. InteractiveChat
backend/proxy upgrades require coordinated staging validation. StartupGuardian
can enforce whitelist/restart policy, so artifact generation is not activation
approval. No server files, configuration, processes or deployment script changed.
