#!/usr/bin/env python3
"""Build the pinned backend and proxy; never operate on servers."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DISPLAY = ROOT / "plugins/enthusia-display"
ROSECHAT = ROOT / "plugins/rosechat"


def run(args, cwd=ROOT):
    subprocess.run([str(arg) for arg in args], cwd=cwd, check=True)


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


def pin(path):
    relative = path.relative_to(ROOT).as_posix()
    line = git("ls-files", "--stage", "--", relative)
    parts = line.split()
    if len(parts) < 3 or parts[0] != "160000":
        raise ValueError(f"No gitlink found for {relative}")
    expected = parts[1]
    if git("-C", str(path), "rev-parse", "HEAD") != expected:
        raise ValueError(f"{relative} checkout does not match gitlink {expected}")
    if git("-C", str(path), "status", "--porcelain"):
        raise ValueError(f"{relative} has local changes; use clean pinned source")
    return expected


def gradle(path, *args):
    wrapper = path / ("gradlew.bat" if os.name == "nt" else "gradlew")
    command = [wrapper, *args, "--console=plain"]
    if os.name != "nt":
        command.insert(0, "sh")
    command.append("-Dorg.gradle.java.installations.fromEnv=JAVA_HOME_21_X64,JAVA_HOME_25_X64")
    run(command, path)


def api(env, filename, entry):
    path = Path(os.environ.get(env, str(DISPLAY / "libs" / filename))).resolve()
    if not path.is_file():
        raise ValueError(f"Missing {env}: supply {filename}; see ci/enthusia-display/README.md")
    with zipfile.ZipFile(path) as jar:
        if entry not in jar.namelist():
            raise ValueError(f"{env} is missing required API class {entry}")
    return path


def digest(path):
    with path.open("rb") as source:
        sha256 = hashlib.file_digest(source, "sha256").hexdigest()
    return {"file": path.relative_to(ROOT).as_posix() if path.is_relative_to(ROOT) else path.name,
            "bytes": path.stat().st_size,
            "sha256": sha256}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--clean", action="store_true")
    parser.add_argument("--clean-only", action="store_true")
    parser.add_argument("--rosechat-built", action="store_true")
    args = parser.parse_args()
    display_pin = pin(DISPLAY)
    if args.clean_only:
        gradle(DISPLAY, "clean", ":proxy:clean")
        return
    rosechat_pin = pin(ROSECHAT)
    unt = api("ENTHUSIADISPLAY_UNT_JAR", "UnlimitedNametags.jar",
              "org/alexdev/unlimitednametags/api/UntNametagDisplayCore.class")
    papi = api("ENTHUSIADISPLAY_PAPI_JAR", "PlaceholderAPI-2.12.3.jar",
               "me/clip/placeholderapi/expansion/PlaceholderExpansion.class")
    if not args.rosechat_built:
        gradle(ROSECHAT, "clean", "shadowJar")
    rose_jars = list((ROSECHAT / "build/libs").glob("RoseChat-*.jar"))
    rose_jars = [p for p in rose_jars if not p.name.endswith(("-sources.jar", "-javadoc.jar", "-plain.jar"))]
    if len(rose_jars) != 1:
        raise ValueError("Expected exactly one freshly built pinned RoseChat shaded jar")
    rose = rose_jars[0].resolve()
    tasks = (["clean", ":proxy:clean"] if args.clean else []) + ["test", ":proxy:test", "jar", ":proxy:jar"]
    gradle(DISPLAY, *tasks, "--init-script", ROOT / "ci/enthusia-display/repositories.init.gradle",
           f"-PuntJar={unt}", f"-PpapiJar={papi}", f"-ProseChatJar={rose}")
    backend = DISPLAY / "build/libs/EnthusiaDisplay.jar"
    proxy = DISPLAY / "proxy/build/libs/EnthusiaDisplayProxy-0.1.5-test.jar"
    with zipfile.ZipFile(backend) as jar:
        descriptor = jar.read("plugin.yml").decode()
        backend_version = next(line.split(":", 1)[1].strip() for line in descriptor.splitlines()
                               if line.startswith("version:"))
    with zipfile.ZipFile(proxy) as jar:
        proxy_version = json.loads(jar.read("velocity-plugin.json"))["version"]
    totals = {"tests": 0, "failures": 0, "errors": 0, "skipped": 0}
    for directory in (DISPLAY, DISPLAY / "proxy"):
        reports = list((directory / "build/test-results/test").glob("TEST-*.xml"))
        if not reports or not any(int(ET.parse(report).getroot().get("tests", 0)) for report in reports):
            raise ValueError(f"Missing test evidence for {directory.name}")
        for report in reports:
            suite = ET.parse(report).getroot()
            for key in totals:
                totals[key] += int(suite.get(key, 0))
    if not totals["tests"] or totals["failures"] or totals["errors"]:
        raise ValueError(f"Invalid test evidence: {totals}")
    pin(DISPLAY)
    pin(ROSECHAT)
    evidence = {"networkCommit": git("rev-parse", "HEAD"), "networkDirty": bool(git("status", "--porcelain")),
                "javaVersion": subprocess.check_output([str(Path(os.environ["JAVA_HOME"]) / "bin" / "java") if os.environ.get("JAVA_HOME") else "java", "--version"], text=True).strip(),
                "displayCommit": display_pin, "roseChatCommit": rosechat_pin,
                "tests": totals, "dependencies": [digest(p) for p in (unt, papi, rose)],
                "artifacts": [dict(digest(backend), version=backend_version), dict(digest(proxy), version=proxy_version)],
                "productionUpload": False, "activation": False, "restart": False,
                "mariaDbAcceptance": "Not run by this helper; default test task excludes mariadb tag"}
    output = ROOT / "build/enthusia-display/provenance.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(f"Display build evidence: {output}")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError, zipfile.BadZipFile) as error:
        print(f"EnthusiaDisplay build failed: {error}", file=sys.stderr)
        sys.exit(1)
