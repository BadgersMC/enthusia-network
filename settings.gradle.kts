rootProject.name = "enthusia-network"

// ── Enthusia Plugin Composite Builds ──────────────────────────────
// Each plugin is an independent Gradle build (its own repo/submodule).
// includeBuild() lets them reference each other by GAV coordinates
// instead of fragile relative JAR paths.
//
// To use: in a plugin's build.gradle.kts, replace:
//   compileOnly(files("../bell-claims/build/libs/LumaGuilds-3.0.0.jar"))
// with:
//   compileOnly("net.lumalyte:LumaGuilds:3.0.0")
//
// The composite build will resolve it to the local project automatically.

includeBuild("plugins/luma-guilds")
includeBuild("plugins/enthusia-advancements")
includeBuild("plugins/enthusia-market")
includeBuild("plugins/luma-sg")
includeBuild("plugins/enthusia-giveaway")
includeBuild("plugins/enthusia-votes")

// RoseChat is pinned to BadgersMC/Enthusia-RoseChat and built separately.
// It is used as LumaGuilds' compile API but remains outside the composite build so its
// independent Gradle 9.x toolchain and upstream lifecycle stay intact.
//
// enthusia-biomes remains excluded from the composite build because its
// paperweight lifecycle is maintained independently. The root composite now
// runs on Gradle 9.1 for the Paper 26.2 / Java 25 core.
// Build biomes separately: cd plugins/enthusia-biomes && ./gradlew build
