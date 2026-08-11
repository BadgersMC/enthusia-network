<p align="center">
  <img src="assets/enthusia-logo.png" width="220" alt="Enthusia logo — a fiery beast emblem in dark orange and gold">
</p>

<h1 align="center">Enthusia&nbsp;Network</h1>

<p align="center"><em>the plugin ecosystem behind Enthusia SMP</em></p>

<p align="center">
  <a href="https://github.com/BadgersMC/enthusia-network/actions/workflows/upstream-watch.yml"><img src="https://github.com/BadgersMC/enthusia-network/actions/workflows/upstream-watch.yml/badge.svg" alt="Upstream watch"></a>
  <img src="https://img.shields.io/badge/plugins-18-C2410C" alt="18 plugins">
  <img src="https://img.shields.io/badge/Minecraft-1.21-F5B841" alt="Minecraft 1.21">
  <img src="https://img.shields.io/badge/Java-21-DC2626" alt="Java 21">
  <img src="https://img.shields.io/badge/status-active-0A0A0A" alt="Active">
  <a href="https://github.com/wsg138"><img src="https://img.shields.io/badge/upstream-wsg138-C2410C" alt="Upstream: wsg138"></a>
</p>

---

**Enthusia Network** is a monorepo for the **Enthusia SMP** server plugin ecosystem. Every plugin lives in its own git submodule with independent history — this repo pins them together and provides a unified build.

Built on the work of **[BadgersMC](https://github.com/BadgersMC)**, **[wsg138 (p2wn)](https://github.com/wsg138)**, and **[NotBorlyn](https://github.com/NotBorlyn)**.

## Server Plugins

| Plugin | Description | Author |
|--------|-------------|--------|
| [enthusia-advancements](plugins/enthusia-advancements) | Config-driven custom advancement trees (guilds, economy, combat) | Badger |
| [luma-guilds](plugins/luma-guilds) | Guild system — claims, vaults, ranks, relations, progression | Badger |
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

## What's in it

- 🏰 **Guilds.** LumaGuilds — claims, vaults, ranks, relations, and progression, with guild-driven advancement trees listening in.
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

# Build the composite plugins (luma-guilds, market, advancements, luma-sg,
# giveaway, votes) in dependency order
./gradlew buildAll

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
gradlew.bat buildAll
scripts\build-all.bat
```

## Build System

This repo uses **Gradle composite builds**. The root `settings.gradle.kts` includes each plugin via `includeBuild()`, which means:

- Plugins can reference each other by GAV coordinates instead of relative JAR paths
- A single `./gradlew buildAll` builds everything in dependency order
- Each plugin retains its own `build.gradle.kts` and can still be built standalone

### Why enthia-biomes is separate

`enthusia-biomes` uses [paperweight](https://github.com/PaperMC/paperweight) 2.0.0-beta.19 which requires Gradle 9.x. All other plugins use Gradle 8.x. Mixing them in a single composite build causes plugin API version conflicts, so biomes is excluded from `includeBuild()` and built independently.

## Upstream Watch

`.github/workflows/upstream-watch.yml` runs hourly and compares every submodule pin against its **true upstream main** (BadgersMC / wsg138 / Hermes-Enthusia — note some `.gitmodules` URLs point at BadgersMC forks of wsg138 repos). When a pin falls behind, it auto-files a `⬆️ <name> upstream:` issue with a diff summary; when a pin catches up, the issue auto-closes. Existing issues act as the "already seen" state (same pattern as the [Fuji](https://github.com/BadgersMC/Fuji) upstream watch).

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
- The **PaperMC** ecosystem — [Paper](https://github.com/PaperMC/Paper), [Gradle](https://gradle.org/), [paperweight](https://github.com/PaperMC/paperweight), and every dependency the plugins build against.

If you run a server on this stack, credit the plugin authors — they did the hard parts.

## License

Each plugin submodule carries its own license and attribution (see each repo's `LICENSE`). The monorepo glue (build scripts, CI, docs) is available under the same spirit — see the individual plugin repos for licensing details.
