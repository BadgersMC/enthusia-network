# Standalone build integration verification — 2026-10-08

Network base: `559bfabc2187ab796a3be889f032383a8041f819`. Only three new
gitlinks were added; no previous pin or provider implementation changed.
Owner selected both Discord forks for network ownership. Canonical default
branches and merged source were verified before creating this isolated branch.

## Exact local clean-build evidence

| Source | Commit | Version | Gate and result |
| --- | --- | --- | --- |
| wsg138/StartupGuardian | 97e5032489f6dfa03c8878a725f6025f121a87e3 | 1.1.1 | Java 21 Maven clean verify; 77 tests, no failures/errors/skips; Checkstyle, PMD/CPD, SpotBugs passed |
| FainNeito/DiscordSRV | 318ced607368d34d9fde7c238afea7deb6ab654d | 1.30.5 | Java 25 Gradle clean test shadowJar spotlessCheck; 14 tests, no failures/errors/skips |
| FainNeito/InteractiveChat-DiscordSRV-Addon | 746cf2e33de06dc9e0dd36ebc1668fea5ce6e42f | 2026.1.2.0 | Java 25 Maven clean verify; all 46 modules passed; 21 item-name, 24 plain-chat, 10 Staff visibility checks |

Artifact SHA-256 values from these builds (not reproducibility guarantees):

- StartupGuardian.jar: `98ca469c61280248a23f879ab0672ea149fa8fac235c9d3450dd766bb42320c0`
- DiscordSRV-1.30.5.jar: `3a808ccd3e4ccee537f3d447231c1c5df18c03dfc0fe0e50dc1f66d38d0d2c6f`
- InteractiveChatDiscordSrvAddon-2026.1.2.0.jar: `f5334e73172fce40aa953e9d2e63e0bf61b098aeb5ef9d23c09ddeb897fbb33a`

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
