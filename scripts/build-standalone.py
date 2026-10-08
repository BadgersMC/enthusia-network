#!/usr/bin/env python3
"""Verify pinned independent builds. Never install, publish or operate on servers."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[1]
PLUGINS = {
    "startup-guardian": (21, "maven", "target/StartupGuardian.jar"),
    "discordsrv": (25, "gradle", "build/libs/DiscordSRV-*.jar"),
    "interactivechat-discord-addon": (25, "maven", "common/target/InteractiveChatDiscordSrvAddon-*.jar"),
    "enthusia-autoclicker": (21, "maven", "target/EnthusiaServerAutoClicker.jar"),
}


def project_path(plugin):
    path = ROOT / "plugins" / plugin
    return path / "server-plugin" if plugin == "enthusia-autoclicker" else path


def followup_commands(plugin):
    if plugin == "enthusia-autoclicker":
        executable = shutil.which("mvn.cmd" if os.name == "nt" else "mvn")
        if not executable:
            raise ValueError("Maven is required on PATH; do not skip verification")
        return [[executable, "-B", "-ntp", "org.apache.maven.plugins:maven-pmd-plugin:3.26.0:check"]]
    return []


def verify_packaging(path, plugin):
    if plugin != "enthusia-autoclicker":
        return
    with zipfile.ZipFile(path) as archive:
        names = set(archive.namelist())
    required = {"net/enthusia/autoclicker/server/api/ClientHandshakeSnapshot.class",
                "net/enthusia/autoclicker/server/api/EnthusiaAutoClickerClientApi.class"}
    if not required.issubset(names):
        raise ValueError("AutoClicker artifact is missing public client evidence APIs")
    if any(name.startswith(("org/bukkit/", "org/junit/")) for name in names):
        raise ValueError("AutoClicker artifact packages provided server/test APIs")


def git(*args):
    return subprocess.check_output(["git", *map(str, args)], cwd=ROOT, text=True).strip()


def pin(plugin):
    path = ROOT / "plugins" / plugin
    fields = git("ls-files", "--stage", "--", f"plugins/{plugin}").split()
    if len(fields) < 3 or fields[0] != "160000" or fields[2] != "0":
        raise ValueError(f"Missing or conflicted gitlink: {plugin}")
    if git("-C", path, "rev-parse", "HEAD") != fields[1]:
        raise ValueError(f"{plugin} checkout differs from gitlink {fields[1]}")
    if git("-C", path, "status", "--porcelain"):
        raise ValueError(f"{plugin} has local changes; use clean pinned source")
    return fields[1]


def java_environment(major):
    home = os.environ.get(f"JAVA_HOME_{major}_X64") or os.environ.get("JAVA_HOME")
    if not home:
        raise ValueError(f"Set JAVA_HOME_{major}_X64 to a JDK {major} installation")
    binary = Path(home) / "bin" / ("java.exe" if os.name == "nt" else "java")
    version = subprocess.check_output([str(binary), "-version"], stderr=subprocess.STDOUT, text=True)
    if not re.search(rf'version "{major}(?:[.\"]|$)', version):
        raise ValueError(f"Expected Java {major} at {home}; found {version.splitlines()[0]}")
    env = dict(os.environ, JAVA_HOME=home)
    env["PATH"] = str(Path(home) / "bin") + os.pathsep + env.get("PATH", "")
    return env


def command(path, kind, clean_only=False):
    if kind == "maven":
        executable = shutil.which("mvn.cmd" if os.name == "nt" else "mvn")
        if not executable:
            raise ValueError("Maven is required on PATH; do not skip verification")
        return [executable, "-B", "-ntp", "clean", *([] if clean_only else ["verify"])]
    wrapper = path / ("gradlew.bat" if os.name == "nt" else "gradlew")
    return ([str(wrapper)] if os.name == "nt" else ["sh", str(wrapper)]) + [
        "clean", *([] if clean_only else ["test", "shadowJar", "spotlessCheck"]), "--no-daemon"]


def evidence(path, plugin, log):
    if plugin == "interactivechat-discord-addon":
        patterns = {
            "item_name_checks": r"Passed (\d+) Discord item-name checks",
            "plain_chat_checks": r"Passed (\d+) plain Discord chat checks",
            "staff_visibility_checks": r"Staff visibility proof: (\d+) checks passed",
        }
        result = {}
        for name, pattern in patterns.items():
            found = re.search(pattern, log)
            if not found or int(found[1]) == 0:
                raise ValueError(f"Missing executed add-on proof: {name}")
            result[name] = int(found[1])
        return result
    folder = "build/test-results/test" if plugin == "discordsrv" else "target/surefire-reports"
    totals = dict(tests=0, failures=0, errors=0, skipped=0)
    for report in (path / folder).glob("TEST-*.xml"):
        suite = ET.parse(report).getroot()
        for key in totals:
            totals[key] += int(suite.get(key, "0"))
    if totals["tests"] <= totals["skipped"] or totals["failures"] or totals["errors"]:
        raise ValueError(f"Missing or failing executed tests: {totals}")
    return totals


def artifact(path, pattern, plugin=None):
    jars = [p for p in path.glob(pattern) if not any(
        marker in p.name for marker in ("-original", "original-", "-sources", "-javadoc"))]
    if len(jars) != 1:
        raise ValueError(f"Expected one shaded artifact for {pattern}, found {len(jars)}")
    verify_packaging(jars[0], plugin)
    with zipfile.ZipFile(jars[0]) as jar:
        descriptor = jar.read("plugin.yml").decode("utf-8")
    version = re.search(r"^version:\s*['\"]?([^\s'\"]+)", descriptor, re.MULTILINE)
    if not version or "${" in version[1]:
        raise ValueError("Missing resolved plugin version")
    return {"path": jars[0].relative_to(ROOT).as_posix(), "version": version[1],
            "sha256": hashlib.sha256(jars[0].read_bytes()).hexdigest()}


def build(plugin, clean_only=False):
    path = project_path(plugin)
    major, kind, pattern = PLUGINS[plugin]
    output = ROOT / "build" / "standalone"
    output.mkdir(parents=True, exist_ok=True)
    provenance = output / f"{plugin}.json"
    provenance.unlink(missing_ok=True)  # failed rebuilds must not retain a success record
    source = pin(plugin)
    env = java_environment(major)
    args = command(path, kind, clean_only)
    commands = [args] + ([] if clean_only else followup_commands(plugin))
    with (output / f"{plugin}.log").open("w", encoding="utf-8") as log_file:
        for invocation in commands:
            with subprocess.Popen(invocation, cwd=path, env=env, stdout=subprocess.PIPE,
                                  stderr=subprocess.STDOUT, text=True, encoding="utf-8", errors="replace") as process:
                for line in process.stdout:
                    print(line, end="", flush=True)
                    log_file.write(line)
                if process.wait():
                    raise subprocess.CalledProcessError(process.returncode, invocation)
    if pin(plugin) != source:
        raise ValueError("Source changed during verification")
    if not clean_only:
        result = {"source_commit": source, "java": major, "command": args, "commands": commands,
                  "evidence": evidence(path, plugin, (output / f"{plugin}.log").read_text(encoding="utf-8")),
                  "artifact": artifact(path, pattern, plugin)}
        provenance.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("plugin", choices=PLUGINS)
    parser.add_argument("--clean-only", action="store_true")
    options = parser.parse_args()
    try:
        build(options.plugin, options.clean_only)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
