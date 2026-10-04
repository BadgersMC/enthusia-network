<p align="center">
  <img src="assets/enthusia-logo.png" width="220" alt="Enthusia logo — a fiery beast emblem in dark orange and gold">
</p>

<h1 align="center">Enthusia&nbsp;Network</h1>

<p align="center"><em>the plugin ecosystem behind Enthusia SMP</em></p>

<p align="center">
  <a href="https://github.com/BadgersMC/enthusia-network/actions/workflows/upstream-watch.yml"><img src="https://github.com/BadgersMC/enthusia-network/actions/workflows/upstream-watch.yml/badge.svg" alt="Upstream watch"></a>
  <img src="https://img.shields.io/badge/plugins-20-C2410C" alt="20 plugins">
  <img src="https://img.shields.io/badge/core-Paper_26.2-F5B841" alt="Core: Paper 26.2">
  <img src="https://img.shields.io/badge/core-Java_25-DC2626" alt="Core: Java 25">
  <img src="https://img.shields.io/badge/status-active-0A0A0A" alt="Active">
  <a href="https://github.com/BadgersMC"><img src="https://img.shields.io/badge/upstream-BadgersMC-F5B841" alt="Upstream: BadgersMC"></a>
  <a href="https://github.com/wsg138"><img src="https://img.shields.io/badge/upstream-wsg138-C2410C" alt="Upstream: wsg138"></a>
  <a href="https://github.com/Hermes-Enthusia"><img src="https://img.shields.io/badge/upstream-Hermes--Enthusia-0A0A0A" alt="Upstream: Hermes-Enthusia"></a>
  <a href="https://github.com/Rosewood-Development"><img src="https://img.shields.io/badge/upstream-Rosewood-F5B841" alt="Upstream: Rosewood Development"></a>
</p>

---

**Enthusia Network** is a monorepo for the **Enthusia SMP** server plugin ecosystem. Every plugin lives in its own git submodule with independent history — this repo pins them together and provides a unified build.

Built on the work of **[BadgersMC](https://github.com/BadgersMC)**, **[wsg138 (p2wn)](https://github.com/wsg138)**, **[NotBorlyn](https://github.com/NotBorlyn)**, and **[Rosewood Development](https://github.com/Rosewood-Development)**.

## Server Plugins

| Plugin | Description | Author |
|--------|-------------|--------|
| [enthusia-advancements](plugins/enthusia-advancements) | Config-driven custom advancement trees (guilds, economy, combat) | Badger |
| [luma-guilds](plugins/luma-guilds) | Guild system — claims, vaults, ranks, relations, Chapter progression | Badger |
| [rosechat](plugins/rosechat) | Chat platform - canonical Enthusia fork tracking Rosewood upstream | Rosewood Development + Enthusia |
| [enthusia-market](plugins/enthusia-market) | Market stall + shop system with guild integration (replaces ItemShops + ARM-Bridge) | Badger |
| [enthusia-biomes](plugins/enthusia-biomes) | Custom biome generation via NMS (paperweight) | Badger |
| [luma-sg](plugins/luma-sg) | Survival Games minigame | Badger |
| [enthusia-currency](plugins/enthusia-currency) | Physical token economy with Vault integration | BadgersMC fork (p2wn) |
| [playtime-plugin](plugins/playtime-plugin) | Playtime tracking | p2wn |
| [mace-guard](plugins/mace-guard) | Mace combat restrictions | p2wn |
| [faster-sleep](plugins/faster-sleep) | Accelerated sleep mechanic | p2wn |
| [enthusia-teleport](plugins/enthusia-teleport) | Teleportation system | p2wn |
| [enthusia-tags](plugins/enthusia-tags) | Player tags / prefixes | p2wn |
| [enthusia-commend](plugins/enthusia-commend) | Player commendation system | p2wn |
| [diary-keeper](plugins/diary-keeper) | Player diary / journal system | p2wn |
| [warzone-duels](plugins/warzone-duels) | 1v1 duels with WarzoneRotator integration | p2wn |
| [enthusia-donor](plugins/enthusia-donor) | Donation perks, auto-link, SQLite-backed transactions | Hermes-Enthusia fork (upstream: NotBorlyn) |
| [enthusia-donor-npcs](plugins/enthusia-donor-npcs) | Leaderboard donor NPCs (FancyNPCs-based) | Hermes-Enthusia fork (upstream: NotBorlyn) |
| [enthusia-giveaway](plugins/enthusia-giveaway) | Scheduled giveaways with admin GUI and live winner announcements | Badger |
| [enthusia-votes](plugins/enthusia-votes) | Vote rewards — streaks, vote parties, Raw Gold payouts | Badger |
| [enthusia-display](plugins/enthusia-display) | Kotlin per-viewer nametag, TAB and chat preferences, with a Velocity companion | Enthusia |

## What's in it

- 🏰 **Guilds.** LumaGuilds — claims, vaults, ranks, relations, Chapter progression, weekly quests, and guild-driven advancement trees.
- 💬 **Chat.** RoseChat - canonical `BadgersMC/Enthusia-RoseChat`, carrying EnthusiaStaff/moderation integrations while tracking Rosewood upstream.
- 💰 **Economy.** EnthusiaCurrency's physical token economy with Vault integration, plus EnthusiaMarket's guild-integrated stall system.
- ⚔️ **Combat & minigames.** MaceGuard's combat restrictions, WarzoneDuels' 1v1 duels, and LumaSG's Survival Games.
- 🌋 **World.** EnthusiaBiomes' NMS custom biome generation.
- 🎮 **Life.** Playtime tracking, teleportation, tags, commendations, diary/journal, faster sleep — the daily-server QoL stack.
- 🎁 **Donations.** Donor perks and leaderboard NPCs, maintained on the Hermes-Enthusia fork.
- 🎉 **Events.** Scheduled giveaways with live winner announcements, and vote rewards (streaks, vote parties, Raw Gold payouts).

## Quick Start

```bash
# Clone with all submodules
git clone --recurse-submodules https://github.com/BadgersMC/enthusia-network.git
cd enthusia-network

# Build everything through the repo helper. It builds the pinned canonical
# Enthusia RoseChat artifact first, then the composite plugins and biomes.
./scripts/build-all.sh

# Build the standalone plugins individually (biomes needs Gradle 9.x;
# the p2wn/wsg138 and donor plugins build from their own repos)
cd plugins/enthusia-biomes && ./gradlew shadowJar && cd ../..

# Or use the build script for everything
./scripts/build-all.sh

# Deploy to server
./scripts/deploy.sh /path/to/server/plugins
```

On Windows:
```cmd
scripts\build-all.bat
```

## Build System

The network build verifies `enthusia-tags` through `scripts/build-tags.sh`, including its pinned dependency bootstrap and the pilot API from the network renderer submodule. Git Bash, Python 3 and Node.js are required alongside Maven and Java 25 for this verification. The resulting pilot renderer is a separate artifact from the root Gradle renderer; see [active playtime integration gates](docs/playtime-integration.md) before selecting a runtime profile.

This repo uses **Gradle composite builds**. The root `settings.gradle.kts` includes each plugin via `includeBuild()`, which means:

- Plugins can reference each other by GAV coordinates instead of relative JAR paths
- A single `./gradlew buildAll` builds everything in dependency order
- Each plugin retains its own `build.gradle.kts` and can still be built standalone

### Separate builds: RoseChat, EnthusiaDisplay and enthusia-biomes

`plugins/rosechat` is pinned to `BadgersMC/Enthusia-RoseChat` and uses its own Gradle build. It is built first so LumaGuilds compiles against the exact RoseChat API that will be deployed. It is intentionally not an `includeBuild()` member.

`enthusia-biomes` uses [paperweight](https://github.com/PaperMC/paperweight) and is also built independently from the root composite.

`plugins/enthusia-display` pins the reviewed merged standalone source at `1734f4329ecb8cd10203fed162e4c0bc3ae27a72`. Root `buildAll` invokes its standalone backend and proxy tests/JAR tasks through `buildDisplay`, using the freshly built pinned RoseChat API. It requires Python 3 and the patched UnlimitedNameTags 2.0.2 and PlaceholderAPI 2.12.3 compile JARs; set the dependency paths before running the build helpers. CI requires approved URLs and hashes. See [the Display build contract and evidence](ci/enthusia-display/README.md).

The backend deploy helper selects only `EnthusiaDisplay.jar`. Its `EnthusiaDisplayProxy-0.1.5-test.jar` belongs on Velocity and requires separate deployment authorization. Building these artifacts does not activate the plugin or restart a server.

## RoseChat lineage

RoseChat has one canonical Enthusia source here: **`BadgersMC/Enthusia-RoseChat`**. The monorepo pins a reviewed commit from that repository; Rosewood Development remains the external upstream whose changes are periodically reconciled into the Enthusia fork.

RoseChat remains subject to its repository license and upstream terms. This monorepo stores only the Git submodule reference and build orchestration; RoseChat source and release artifacts remain in the canonical RoseChat repository/build pipeline.

See [`ci/rosechat/README.md`](ci/rosechat/README.md) for build and dependency notes.

## Upstream Watch

`.github/workflows/upstream-watch.yml` runs hourly and compares every submodule pin against its **true upstream main** (BadgersMC / wsg138 / Hermes-Enthusia / Rosewood Development — note some `.gitmodules` URLs point at BadgersMC forks of wsg138 repos). When a pin falls behind, it auto-files a `⬆️ <name> upstream:` issue with a diff summary; when a pin catches up, the issue auto-closes. Existing issues act as the "already seen" state (same pattern as the [Fuji](https://github.com/BadgersMC/Fuji) upstream watch).

## Working with Submodules

```bash
# Pull latest for all submodules
git submodule update --remote --merge

# Work on a specific plugin
cd plugins/luma-guilds
git checkout -b feature/my-feature
# ... make changes, commit, push ...

# Update the monorepo to point to new commit
cd ../..
git add plugins/luma-guilds
git commit -m "chore: bump luma-guilds to latest"
```

> The upstream-watch CI will flag stale pins automatically — prefer bumping pins via a PR rather than pushing to `main` directly.

## Repository Layout

```text
enthusia-network/
├── settings.gradle.kts     # Composite build config
├── build.gradle.kts        # Root tasks (buildAll, cleanAll)
├── .github/workflows/
│   └── upstream-watch.yml  # Auto-files issues when submodule pins fall behind
├── plugins/
│   ├── enthusia-advancements/
│   ├── luma-guilds/
│   ├── rosechat/            # canonical Enthusia RoseChat pin
│   ├── enthusia-display/    # backend plus proxy/ companion
│   ├── enthusia-market/
│   ├── enthusia-biomes/
│   ├── enthusia-currency/
│   ├── luma-sg/
│   ├── playtime-plugin/
│   ├── mace-guard/
│   ├── faster-sleep/
│   ├── enthusia-teleport/
│   ├── enthusia-tags/
│   ├── enthusia-commend/
│   ├── diary-keeper/
│   ├── warzone-duels/
│   ├── enthusia-donor/
│   ├── enthusia-donor-npcs/
│   ├── enthusia-giveaway/
│   └── enthusia-votes/
└── scripts/
    ├── build-all.sh / .bat  # Build everything
    └── deploy.sh            # Copy JARs to server
```

## Credits

Enthusia Network is a monorepo — every plugin stands on its original author's work. Enormous thanks to:

- **[wsg138 (p2wn)](https://github.com/wsg138)** — author of the bulk of the server stack: EnthusiaCurrency, PlayTimePlugin, MaceGuard, FasterSleep, EnthusiaTeleport, EnthusiaTags, EnthusiaCommend, DiaryKeeper, WarzoneDuels, and the original EnthusiaAdvancements work. Most of the "fork" pins in this repo point at BadgersMC forks of p2wn's upstream repos.
- **[NotBorlyn](https://github.com/NotBorlyn)** — author of EnthusiaDonor and EnthusiaDonorNPCs, now maintained on the [Hermes-Enthusia fork](https://github.com/Hermes-Enthusia).
- **[BadgersMC](https://github.com/BadgersMC)** — LumaGuilds, EnthusiaMarket, EnthusiaBiomes, LumaSG, and the ongoing EnthusiaAdvancements development.
- **[Rosewood Development](https://github.com/Rosewood-Development)** — RoseChat and RoseGarden, including the official Paper 26.2/Java 25 migration used as our canonical chat base.
- The **PaperMC** ecosystem — [Paper](https://github.com/PaperMC/Paper), [Gradle](https://gradle.org/), [paperweight](https://github.com/PaperMC/paperweight), and every dependency the plugins build against.

If you run a server on this stack, credit the plugin authors — they did the hard parts.

## License

Each plugin submodule carries its own license and attribution (see each repo's `LICENSE`). The monorepo glue (build scripts, CI, docs) is available under the same spirit — see the individual plugin repos for licensing details.
