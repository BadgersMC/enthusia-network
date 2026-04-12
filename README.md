# Enthusia Network

Monorepo for the **Enthusia SMP** server plugin ecosystem. Each plugin lives in its own git submodule with independent history — this repo pins them together and provides a unified build.

## Plugins

| Submodule | Description | Gradle |
|-----------|-------------|--------|
| [enthusia-advancements](plugins/enthusia-advancements) | Config-driven custom advancement trees (guilds, economy, combat) | 8.x |
| [luma-guilds](plugins/luma-guilds) | Guild system — claims, vaults, ranks, relations, progression | 8.x |
| [arm-guilds-bridge](plugins/arm-guilds-bridge) | Bridge between Advanced Region Market and LumaGuilds | 8.x |
| [item-shops](plugins/item-shops) | Chest+sign shop system with guild integration | 8.x |
| [enthusia-biomes](plugins/enthusia-biomes) | Custom biome generation via NMS (paperweight) | 9.x |
| [luma-sg](plugins/luma-sg) | Survival Games minigame | 8.x |

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
          ^
          |--- enthusia-advancements (listens to shop events)

enthusia-biomes  (independent)
luma-sg          (independent)
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
│   ├── enthusia-advancements/   (submodule)
│   ├── luma-guilds/             (submodule)
│   ├── arm-guilds-bridge/       (submodule)
│   ├── item-shops/              (submodule)
│   ├── enthusia-biomes/         (submodule)
│   └── luma-sg/                 (submodule)
└── scripts/
    ├── build-all.sh / .bat  # Build everything
    └── deploy.sh            # Copy JARs to server
```

## License

Proprietary — BadgersMC / LumaLyte
