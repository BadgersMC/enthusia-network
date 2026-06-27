// Root build for enthusia-network monorepo.
// This file only provides convenience tasks — each plugin builds independently.

tasks.register("buildLumaGuilds") {
    description = "Build LumaGuilds shadowJar (foundation for market stack)"
    group = "enthusia"
    dependsOn(gradle.includedBuild("luma-guilds").task(":shadowJar"))
}

tasks.register("buildItemShops") {
    description = "Build ItemShops shadowJar"
    group = "enthusia"
    dependsOn(gradle.includedBuild("luma-guilds").task(":shadowJar"))
    dependsOn(gradle.includedBuild("item-shops").task(":shadowJar"))
}

tasks.register("buildArmBridge") {
    description = "Build ARM-Guilds-Bridge shadowJar"
    group = "enthusia"
    dependsOn(gradle.includedBuild("luma-guilds").task(":shadowJar"))
    dependsOn(gradle.includedBuild("item-shops").task(":shadowJar"))
    dependsOn(gradle.includedBuild("arm-guilds-bridge").task(":shadowJar"))
}

tasks.register("buildAll") {
    description = "Build all Enthusia plugins (shadowJar where available)"
    group = "enthusia"

    // Order matters: luma-guilds -> item-shops -> arm-guilds-bridge -> dependents
    // enthusia-biomes excluded — requires Gradle 9.x (paperweight), build separately
    dependsOn(gradle.includedBuild("luma-guilds").task(":shadowJar"))
    dependsOn(gradle.includedBuild("item-shops").task(":shadowJar"))
    dependsOn(gradle.includedBuild("arm-guilds-bridge").task(":shadowJar"))
    dependsOn(gradle.includedBuild("enthusia-advancements").task(":shadowJar"))
    dependsOn(gradle.includedBuild("luma-sg").task(":shadowJar"))
}

tasks.register("testAll") {
    description = "Run unit tests for all composite Gradle plugins"
    group = "enthusia"
    dependsOn(gradle.includedBuild("luma-guilds").task(":test"))
    dependsOn(gradle.includedBuild("enthusia-advancements").task(":test"))
    dependsOn(gradle.includedBuild("luma-sg").task(":test"))
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
