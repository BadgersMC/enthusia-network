// Root build for enthusia-network monorepo.
// This file only provides convenience tasks — each plugin builds independently.

val standalonePlugins = listOf("startup-guardian", "discordsrv", "interactivechat-discord-addon", "enthusia-autoclicker")
standalonePlugins.forEach { plugin ->
    tasks.register<Exec>("verify-$plugin") {
        group = "enthusia"
        commandLine(System.getenv("PYTHON_BIN") ?: "python", "scripts/build-standalone.py", plugin)
    }
    tasks.register<Exec>("clean-$plugin") {
        group = "enthusia"
        commandLine(System.getenv("PYTHON_BIN") ?: "python", "scripts/build-standalone.py", plugin, "--clean-only")
    }
}

val nestedGradle = if (System.getProperty("os.name").startsWith("Windows", ignoreCase = true)) {
    "gradlew.bat"
} else {
    "./gradlew"
}

tasks.register<Exec>("buildToiletFlush") {
    description = "Test and package EnthusiaToiletFlush Velocity and Paper companion artifacts"
    group = "enthusia"
    workingDir("plugins/enthusia-toilet-flush")
    commandLine(
        nestedGradle,
        ":velocity:check",
        ":velocity:shadowJar",
        ":paper-companion:check",
        ":paper-companion:shadowJar",
        "--no-daemon",
    )
}

tasks.register<Exec>("cleanToiletFlush") {
    group = "enthusia"
    workingDir("plugins/enthusia-toilet-flush")
    commandLine(nestedGradle, "clean", "--no-daemon")
}

tasks.register<Exec>("buildDisplay") {
    description = "Test and package pinned EnthusiaDisplay backend and Velocity companion"
    group = "enthusia"
    onlyIf { System.getenv("ENTHUSIADISPLAY_SKIP") != "true" }
    commandLine(listOf(System.getenv("PYTHON_BIN") ?: "python", "scripts/build-display.py") +
        if (System.getenv("ENTHUSIADISPLAY_ROSECHAT_BUILT") == "true") listOf("--rosechat-built") else emptyList())
}

tasks.register<Exec>("cleanDisplay") {
    group = "enthusia"
    onlyIf { System.getenv("ENTHUSIADISPLAY_SKIP") != "true" }
    commandLine(System.getenv("PYTHON_BIN") ?: "python", "scripts/build-display.py", "--clean-only")
}

tasks.register("buildAll") {
    description = "Build all Enthusia plugins (shadowJar where available)"
    group = "enthusia"
    dependsOn(standalonePlugins.map { "verify-$it" })

    // Order matters: dependencies first, dependents last
    // enthusia-biomes excluded — requires Gradle 9.x (paperweight), build separately
    dependsOn(
        "buildDisplay",
        "buildToiletFlush",
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
    dependsOn(standalonePlugins.map { "clean-$it" })

    dependsOn(
        "cleanDisplay",
        "cleanToiletFlush",
        gradle.includedBuild("luma-guilds").task(":clean"),
        gradle.includedBuild("enthusia-market").task(":clean"),
        gradle.includedBuild("enthusia-advancements").task(":clean"),
        gradle.includedBuild("luma-sg").task(":clean"),
        gradle.includedBuild("enthusia-giveaway").task(":clean"),
        gradle.includedBuild("enthusia-votes").task(":clean"),
    )
}
