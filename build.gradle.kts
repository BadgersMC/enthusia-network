// Root build for enthusia-network monorepo.
// This file only provides convenience tasks — each plugin builds independently.

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

// EnthusiaHolidays and EnthusiaFriends are private; fork PRs skip them (see build.yml).
val privatePluginsSkipped = System.getenv("ENTHUSIA_PRIVATE_PLUGINS_SKIP") == "true"
// Lets nested wrappers resolve the JDK 21/25 toolchains CI installs.
val toolchainsFromEnv = "-Porg.gradle.java.installations.fromEnv=JAVA_HOME_21_X64,JAVA_HOME_25_X64"

tasks.register<Exec>("buildHolidays") {
    description = "Test and package EnthusiaHolidays"
    group = "enthusia"
    onlyIf { !privatePluginsSkipped }
    workingDir("plugins/enthusia-holidays")
    commandLine(nestedGradle, "build", toolchainsFromEnv, "--no-daemon")
}

tasks.register<Exec>("cleanHolidays") {
    group = "enthusia"
    onlyIf { !privatePluginsSkipped }
    workingDir("plugins/enthusia-holidays")
    commandLine(nestedGradle, "clean", "--no-daemon")
}

tasks.register<Exec>("buildFriends") {
    description = "Test and package EnthusiaFriends Paper and Velocity artifacts for Paper 26.2"
    group = "enthusia"
    onlyIf { !privatePluginsSkipped }
    workingDir("plugins/enthusia-friends")
    commandLine(nestedGradle, "build", "-PpaperTarget=26.2", toolchainsFromEnv, "--no-daemon")
}

tasks.register<Exec>("cleanFriends") {
    group = "enthusia"
    onlyIf { !privatePluginsSkipped }
    workingDir("plugins/enthusia-friends")
    commandLine(nestedGradle, "clean", "--no-daemon")
}

tasks.register<Exec>("buildExpress") {
    description = "Test and package EnthusiaExpress"
    group = "enthusia"
    workingDir("plugins/enthusia-express")
    commandLine(nestedGradle, "build", toolchainsFromEnv, "--no-daemon")
}

tasks.register<Exec>("cleanExpress") {
    group = "enthusia"
    workingDir("plugins/enthusia-express")
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

    // Order matters: dependencies first, dependents last
    // enthusia-biomes excluded — requires Gradle 9.x (paperweight), build separately
    dependsOn(
        "buildDisplay",
        "buildToiletFlush",
        "buildHolidays",
        "buildFriends",
        "buildExpress",
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
        "cleanDisplay",
        "cleanToiletFlush",
        "cleanHolidays",
        "cleanFriends",
        "cleanExpress",
        gradle.includedBuild("luma-guilds").task(":clean"),
        gradle.includedBuild("enthusia-market").task(":clean"),
        gradle.includedBuild("enthusia-advancements").task(":clean"),
        gradle.includedBuild("luma-sg").task(":clean"),
        gradle.includedBuild("enthusia-giveaway").task(":clean"),
        gradle.includedBuild("enthusia-votes").task(":clean"),
    )
}
