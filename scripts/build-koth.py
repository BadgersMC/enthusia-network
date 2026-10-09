#!/usr/bin/env python3
"""Verify and package the pinned KOTH against the network's real Guilds API."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
KOTH = ROOT / "plugins/enthusia-koth"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--clean-only", action="store_true")
    args = parser.parse_args()
    java21 = os.environ.get("KOTH_JAVA_HOME") or os.environ.get("JAVA_HOME_21_X64")
    if not java21:
        raise ValueError("Set KOTH_JAVA_HOME or JAVA_HOME_21_X64 to JDK 21")
    java = Path(java21) / "bin" / ("java.exe" if os.name == "nt" else "java")
    version = subprocess.run([str(java), "-version"], capture_output=True, text=True, check=True)
    if 'version "21.' not in version.stderr + version.stdout:
        raise ValueError("KOTH's Gradle 8 wrapper requires a JDK 21 runner")
    environment = dict(os.environ, JAVA_HOME=java21)
    tasks = ["clean"]
    if not args.clean_only:
        guild = Path(os.environ.get("LUMAGUILDS_JAR", str(ROOT / "plugins/luma-guilds/build/libs/LumaGuilds-3.0.0.jar")))
        if not guild.is_file():
            raise ValueError("Build the pinned LumaGuilds shaded JAR before KOTH")
        environment["ENTHUSIA_GUILD_API_JAR"] = str(guild.resolve())
        tasks += ["test", "actualGuildApiTest", "shadowJar"]
    wrapper = KOTH / ("gradlew.bat" if os.name == "nt" else "gradlew")
    command = [str(wrapper), *tasks, "--no-daemon", "--console=plain",
               "-Dorg.gradle.java.installations.fromEnv=KOTH_JAVA_HOME,JAVA_HOME_21_X64,JAVA_HOME_25_X64"]
    if os.name != "nt":
        command.insert(0, "sh")
    subprocess.run(command, cwd=KOTH, env=environment, check=True)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"KOTH build failed: {error}", file=sys.stderr)
        sys.exit(1)
