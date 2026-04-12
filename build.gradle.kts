// Root build for enthusia-network monorepo.
// This file only provides convenience tasks — each plugin builds independently.

tasks.register("buildAll") {
    description = "Build all Enthusia plugins (shadowJar where available)"
    group = "enthusia"

    // Order matters: dependencies first, dependents last
    // enthusia-biomes excluded — requires Gradle 9.x (paperweight), build separately
    dependsOn(
        gradle.includedBuild("luma-guilds").task(":shadowJar"),
        gradle.includedBuild("item-shops").task(":shadowJar"),
        gradle.includedBuild("arm-guilds-bridge").task(":shadowJar"),
        gradle.includedBuild("enthusia-advancements").task(":shadowJar"),
        gradle.includedBuild("luma-sg").task(":shadowJar"),
    )
}

tasks.register("cleanAll") {
    description = "Clean all Enthusia plugin builds"
    group = "enthusia"

    dependsOn(
        gradle.includedBuild("luma-guilds").task(":clean"),
        gradle.includedBuild("item-shops").task(":clean"),
        gradle.includedBuild("arm-guilds-bridge").task(":clean"),
        gradle.includedBuild("enthusia-advancements").task(":clean"),
        gradle.includedBuild("luma-sg").task(":clean"),
    )
}
