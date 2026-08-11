// Root build for enthusia-network monorepo.
// This file only provides convenience tasks — each plugin builds independently.

tasks.register("buildAll") {
    description = "Build all Enthusia plugins (shadowJar where available)"
    group = "enthusia"

    // Order matters: dependencies first, dependents last
    // enthusia-biomes excluded — requires Gradle 9.x (paperweight), build separately
    dependsOn(
        gradle.includedBuild("luma-guilds").task(":shadowJar"),
        gradle.includedBuild("enthusia-market").task(":shadowJar"),
        gradle.includedBuild("enthusia-advancements").task(":shadowJar"),
        gradle.includedBuild("luma-sg").task(":shadowJar"),
        gradle.includedBuild("enthusia-giveaway").task(":shadowJar"),
        gradle.includedBuild("enthusia-votes").task(":shadowJar"),
    )
}

tasks.register("cleanAll") {
    description = "Clean all Enthusia plugin builds"
    group = "enthusia"

    dependsOn(
        gradle.includedBuild("luma-guilds").task(":clean"),
        gradle.includedBuild("enthusia-market").task(":clean"),
        gradle.includedBuild("enthusia-advancements").task(":clean"),
        gradle.includedBuild("luma-sg").task(":clean"),
        gradle.includedBuild("enthusia-giveaway").task(":clean"),
        gradle.includedBuild("enthusia-votes").task(":clean"),
    )
}
