# Enthusia Network

Monorepo for the **Enthusia SMP** server plugin ecosystem. Each plugin lives in its own git submodule with independent history — this repo pins them together and provides a unified build.

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

## Quick Start

```bash
# Clone with all submodules
git clone --recurse-submodules https://github.com/BadgersMC/enthusia-network.git
cd enthusia-network

# Build all plugins (except enthusia-biomes which needs Gradle 9.x)
./gradlew buildAll

# Build enthusia-biomes separately
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

### Why enthusia-biomes is separate

`enthusia-biomes` uses [paperweight](https://github.com/PaperMC/paperweight) 2.0.0-beta.19 which requires Gradle 9.x. All other plugins use Gradle 8.x. Mixing them in a single composite build causes plugin API version conflicts, so biomes is excluded from `includeBuild()` and built independently.

## Upstream Watch

`.github/workflows/upstream-watch.yml` runs hourly and compares every submodule pin against its **true upstream main** (BadgersMC / wsg138 / Hermes-Enthusia — note some `.gitmodules` URLs point at BadgersMC forks of wsg138 repos). When a pin falls behind, it auto-files a `⬆️ <name> upstream:` issue with a diff summary; when a pin catches up, the issue auto-closes. Existing issues act as the "already seen" state (same pattern as the Fuji upstream watch).

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

```
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
│   ├── enthia-donor/
│   └── enthia-donor-npcs/
└── scripts/
    ├── build-all.sh / .bat  # Build everything
    └── deploy.sh            # Copy JARs to server
```
