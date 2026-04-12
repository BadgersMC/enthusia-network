rootProject.name = "enthusia-network"

// ── Enthusia Plugin Composite Builds ──────────────────────────────
// Each plugin is an independent Gradle build (its own repo/submodule).
// includeBuild() lets them reference each other by GAV coordinates
// instead of fragile relative JAR paths.
//
// To use: in a plugin's build.gradle.kts, replace:
//   compileOnly(files("../bell-claims/build/libs/LumaGuilds-2.0.0.jar"))
// with:
//   compileOnly("net.lumalyte:LumaGuilds:2.0.0")
//
// The composite build will resolve it to the local project automatically.

includeBuild("plugins/luma-guilds")
includeBuild("plugins/enthusia-advancements")
includeBuild("plugins/arm-guilds-bridge")
includeBuild("plugins/item-shops")
includeBuild("plugins/luma-sg")

// enthusia-biomes is excluded from composite build — it requires Gradle 9.x
// (paperweight 2.0.0-beta.19) while all other plugins use Gradle 8.x.
// Build it separately: cd plugins/enthusia-biomes && ./gradlew build
