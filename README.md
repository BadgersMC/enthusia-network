# Enthusia Network

Monorepo for the **Enthusia SMP** server plugin ecosystem. Each plugin lives in its own git submodule with independent history — this repo pins them together and provides a unified build.

## Plugins

### Core (BadgersMC)

| Submodule | Description | Author |
|-----------|-------------|--------|
| [enthusia-advancements](plugins/enthusia-advancements) | Config-driven custom advancement trees (guilds, economy, combat) | Badger |
| [luma-guilds](plugins/luma-guilds) | Guild system — claims, vaults, ranks, relations, progression | Badger |
| [arm-guilds-bridge](plugins/arm-guilds-bridge) | Bridge between Advanced Region Market and LumaGuilds | Badger |
| [item-shops](plugins/item-shops) | Chest+sign shop system with guild integration | Badger (fork of p2wn) |
| [enthusia-biomes](plugins/enthusia-biomes) | Custom biome generation via NMS (paperweight) | Badger |
| [luma-sg](plugins/luma-sg) | Survival Games minigame | Badger |
| [enthusia-currency](plugins/enthusia-currency) | Physical token economy with Vault integration | BadgersMC fork (p2wn) |

### Server Plugins (p2wn)

| Submodule | Description |
|-----------|-------------|
| [playtime-plugin](plugins/playtime-plugin) | Playtime tracking |
| [mace-guard](plugins/mace-guard) | Mace combat restrictions |
| [faster-sleep](plugins/faster-sleep) | Accelerated sleep mechanic |
| [enthusia-teleport](plugins/enthusia-teleport) | Teleportation system |
| [enthusia-tags](plugins/enthusia-tags) | Player tags / prefixes |
| [enthusia-commend](plugins/enthusia-commend) | Player commendation system |
| [diary-keeper](plugins/diary-keeper) | Player diary / journal system |

## Dependency Graph

```
luma-guilds (core)
  ^
  |--- enthusia-advancements (listens to guild events)
  |--- arm-guilds-bridge (uses guild vault, ranks, relations)
  |       ^
  |       |--- enthusia-advancements (listens to bridge events)
  |
  |--- item-shops (guild shop ownership)
  |       ^
  |       |--- enthusia-advancements (listens to shop events)
  |
  |--- enthusia-currency (Vault economy, token items)
          ^
          |--- enthusia-advancements (listens to economy events)

enthusia-biomes      (independent)
luma-sg              (independent)
playtime-plugin      (independent — advancement hook planned)
diary-keeper         (independent — advancement hook planned)
mace-guard           (independent)
faster-sleep         (independent)
enthusia-teleport    (independent)
enthusia-tags        (independent)
enthusia-commend     (independent)
```

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

## Repository Layout

```
enthusia-network/
├── settings.gradle.kts     # Composite build config
├── build.gradle.kts        # Root tasks (buildAll, cleanAll)
├── plugins/
│   ├── enthusia-advancements/   (BadgersMC)
│   ├── luma-guilds/             (BadgersMC)
│   ├── arm-guilds-bridge/       (BadgersMC)
│   ├── item-shops/              (BadgersMC)
│   ├── enthusia-biomes/         (BadgersMC)
│   ├── enthusia-currency/       (BadgersMC fork)
│   ├── luma-sg/                 (BadgersMC)
│   ├── playtime-plugin/         (p2wn)
│   ├── mace-guard/              (p2wn)
│   ├── faster-sleep/            (p2wn)
│   ├── enthusia-teleport/       (p2wn)
│   ├── enthusia-tags/           (p2wn)
│   ├── enthusia-commend/        (p2wn)
│   └── diary-keeper/            (p2wn)
└── scripts/
    ├── build-all.sh / .bat  # Build everything
    └── deploy.sh            # Copy JARs to server
```
