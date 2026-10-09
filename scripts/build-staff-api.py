#!/usr/bin/env python3
"""Stage LumaGuilds' moderation API from the same immutable source as Guilds CI."""
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "build/deps/enthusia-staff"
REF = "8539bb8c77d7ecaf083546dda7ca8ccbfa8064e6"


def run(*command, cwd=ROOT):
    subprocess.run([str(part) for part in command], cwd=cwd, check=True)


def main():
    SOURCE.parent.mkdir(parents=True, exist_ok=True)
    if not SOURCE.exists():
        run("git", "clone", "https://github.com/wsg138/EnthusiaStaff.git", SOURCE)
    if subprocess.check_output(["git", "status", "--porcelain"], cwd=SOURCE, text=True).strip():
        raise ValueError("Staff API dependency has local changes; use a clean build/deps checkout")
    run("git", "fetch", "origin", REF, cwd=SOURCE)
    run("git", "checkout", "--detach", REF, cwd=SOURCE)
    wrapper = SOURCE / ("gradlew.bat" if os.name == "nt" else "gradlew")
    command = [wrapper, ":moderation-platform-api:clean", ":moderation-platform-api:jar", "--no-daemon",
               "-Dorg.gradle.java.installations.fromEnv=JAVA_HOME_21_X64,JAVA_HOME_25_X64"]
    if os.name != "nt":
        command.insert(0, "sh")
    run(*command, cwd=SOURCE)
    jars = [jar for jar in (SOURCE / "moderation-platform-api/build/libs").glob("*.jar")
            if not jar.name.endswith(("-sources.jar", "-javadoc.jar"))]
    if len(jars) != 1:
        raise ValueError("Expected exactly one freshly built moderation API JAR")
    target = ROOT / "plugins/luma-guilds/libs/EnthusiaStaff-moderation-api.jar"
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(jars[0], target)
    print(f"Staff API source: {REF}; staged {target}")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"Staff API build failed: {error}", file=sys.stderr)
        sys.exit(1)
