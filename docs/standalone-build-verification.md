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
The new local submodule used an untracked info/attributes `-text` override for
that file. On other checkouts, the verifier accepts that single normalization
report only if the wrapper's raw Git blob hash equals HEAD exactly. Changed
bytes or any additional dirty path fail verification. Regression tests cover
both rejections; the full helper suite passes 16 tests. No tracked source was
edited; server Maven gates run without the client wrapper. This is not a runtime
compatibility claim.

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
Hosted owner PR #2 run 37786282569 on c7209f27 passes the complete 46-module
reactor, the new model regression and all 55 assertions; presentation also
passes. No review was submitted at inspection. These passes do not merge source.

## Remaining source contracts

### Retry passed add-on; StartupGuardian tooling failure

Network run 37800713821 on 69e54ff0 passes the complete merged e04e2dbd add-on
reactor and all 55 proof checks. The earlier CraftBukkit connection reset did
not repeat. DiscordSRV and server AutoClicker also produce verified provenance.
The next failure is StartupGuardian SpotBugs 4.9.0.0 loading:
`VelocityEngine.setProperties(java.util.Properties)` is missing from its
resolved plugin class realm (which contains Velocity 1.7 and engine-core 2.4).

Runner image 20261004.327.1 documents Maven 3.10.0. Local clean Maven 3.9.11
verification passes the same StartupGuardian source, including SpotBugs;
tool-version causality is not yet proven on the hosted runner. CI now selects
the already verified Maven 3.9.11 before all Maven builds, from Maven Central
with committed SHA-512 checked before extraction. A downloaded copy's checksum
was verified locally; workflow YAML/order, EARS and whitespace pass. No plugin
dependency version, static check, test, module or quality gate is removed.
The new exact-head hosted run must determine whether this environment selection
clears the failure. Network #169 remains open and draft, with private/trusted
and live/client acceptance still outstanding.

Runner evidence: https://github.com/actions/runner-images/blob/ubuntu24/20261004.327/images/ubuntu/Ubuntu2404-Readme.md

### Hosted dependency transport failure, 2026-10-08

Network run 37796972150 on 3b7e3765 cleared the repaired duplicate Maven model
and built add-on adapters through V1_16_2. V1_16_4 then failed resolving
`org.bukkit:craftbukkit:1.16.4-R0.1-SNAPSHOT`: loohp-repo reported Connection
reset, while the other repositories do not supply this legacy artifact. This
is observed dependency transport failure, not proof of a new source regression.
The canonical merged owner run 37796559490 on e04e2dbd passes the complete
reactor and presentation jobs. Both local merged-source gates also passed.

Direct retry of the network run was denied: the connector lacks integration
access and the authenticated account lacks repository admin rights. This
evidence update will trigger normal PR CI; no quality gates, modules, versions,
source checks or dependency origins are removed or substituted. If transport
failure repeats, dependency availability/reliability needs further evidence.
Private Display remains skipped in fork CI; network release validation remains
incomplete, and no server operation occurred.

### Authorized merged repair pin, 2026-10-08

The user authorized owner PR #2 merge and network #169 update. PR #2 merged as
`e04e2dbdddd8a8136c1572cf087ef89bbfc7c6c6`; fetched owner master confirms it.
The merge tree equals the verified c7209f27 candidate tree. Network #169 now
pins that merged commit. All other gitlinks and build/deploy helpers are intact.
Clean merged-source Java 25/Maven 3.9.11 helper verification passed all 46
modules and 55 presentation/privacy checks, with clean-source checks before
and after. Version 2026.1.2.0; local artifact SHA-256
`17e525e3e3a9cdc837496c66b4d238346df1259b3656d22385bf16d4a21bfac2`.
All 16 helper regressions, model uniqueness, EARS and whitespace pass.
New network-head CI is pending; candidate evidence below is historical.
Network #169 remains open.
No upload, deployment or activation was authorized or performed.

### Network helper repair verification, 2026-10-08

Latest network run 37791405003 on 1767cf83 fails on the same duplicate Gson
serializer coordinates in the old add-on pin, not a new source defect. Owner
PR #2 c7209f27 remains unmerged; its complete reactor and presentation checks
pass and no review comments/reviews were present at refresh.

An isolated local candidate checkout tested c7209f27 using this network's actual
`scripts/build-standalone.py`, Java 25 and Maven 3.9.11. Clean verify passed all
46 modules and the helper captured 21 item-name, 24 plain-chat and 10 Staff
visibility checks. All 16 helper regressions pass. Semantic XML comparison
confirmed exactly 44 identical dependency removals, preserving every other
model field including versions/scopes. Model uniqueness, EARS and whitespace
checks pass. Candidate version 2026.1.2.0, local test artifact SHA-256
`f21f2e6163130d6467b0d7b0339de8e282b20e689d1b17f97297def2bce84703`.

This candidate pin is confined to the isolated local proof checkout and is not
published here. Explicit owner-source merge authorization is pending. After
source merge, update only the canonical merged add-on gitlink and rerun exact
network-head CI. Network #169 stays open; full trusted/private verification and
Paper/Discord/client acceptance remain distinct. No server operations occurred.

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

## Companion repairs delivered for review

The source-contract follow-up is implemented, but not merged or pinned here:

- [KOTH upstream #11](https://github.com/wsg138/EnthusiaKOTH/pull/11),
  [owner #1](https://github.com/FainNeito/EnthusiaKOTH/pull/1), head
  `65ed709c8b7800300ca5955d079cdeb2d13ce6c2`: system guild-bank calls replace
  the guild-as-personal-actor dispatch. Seven regressions failed first; all nine
  adapter regressions and 167 total tests now pass on Java 21. Invalid amounts
  and missing system methods fail without personal-wallet fallback. ZIP checks
  confirm excluded companion mirrors and no duplicates. Upstream Build needs
  maintainer workflow approval; no fork check run exists at inspection. Actual
  live guild-bank transactions remain an acceptance gate. Initial Codacy flagged
  four test maintainability issues; test classes/literals were refined without
  dropping regressions, and all 167 tests pass again. Latest-head Codacy check
  113358815579 succeeds with no issues. Upstream Build still requires approval.
- [Trivia upstream #56](https://github.com/BadgersMC/LumaTrivia/pull/56),
  [owner #1](https://github.com/FainNeito/LumaTrivia/pull/1), head
  `8b3be2bbc2c5f07fb6221681ead3633566b6ad98`: explicit property/environment
  compile-only API selection, preserved legacy default, and hosted immutable
  companion build verification. Actual network RoseChat cf8a7b04 builds as RC-4
  on Java 21; clean Trivia property, environment and default builds each pass
  all 41 tests. Missing explicit input is rejected; RoseChat classes are not
  bundled. Owner run [37790535380](https://github.com/FainNeito/LumaTrivia/actions/runs/37790535380)
  passes both default tests and exact companion verification on 8b3be2bb;
  logs confirm RC-4 source build, missing-path rejection and compile-only checks.
  Upstream Codacy passes; upstream CI still needs maintainer approval. Local
  compilation does not prove actual Paper chat/mute or client behavior.

No KOTH/Trivia feature gitlinks, server uploads or activation were added. Source
review/CI/merge precede clean merged-source artifacts and a network pin PR.

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
