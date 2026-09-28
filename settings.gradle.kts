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

// RoseChat is pinned directly to Rosewood-Development/RoseChat and built separately.
// It is used as LumaGuilds' compile API but remains outside the composite build so its
// independent Gradle 9.x toolchain and upstream lifecycle stay intact.
//
// enthusia-biomes is excluded from composite build — it requires Gradle 9.x
// (paperweight 2.0.0-beta.19) while all other plugins use Gradle 8.x.
// Build it separately: cd plugins/enthusia-biomes && ./gradlew build
