#!/usr/bin/env python3
"""Build the same immutable moderation API used by the pinned guild CI."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "https://github.com/wsg138/EnthusiaStaff.git"
SOURCE = "8539bb8c77d7ecaf083546dda7ca8ccbfa8064e6"


def run(*args, cwd=ROOT):
    subprocess.run(args, cwd=cwd, check=True)


def main():
    guilds = ROOT / "plugins/luma-guilds"
    workflow = (guilds / ".github/workflows/unit-test.yml").read_text(encoding="utf-8")
    pin = re.search(r"^\s+ENTHUSIASTAFF_API_REF:\s+([a-f0-9]{40})\b", workflow, re.MULTILINE)
    if pin is None or pin.group(1) != SOURCE:
        raise RuntimeError("Network Staff API pin differs from the selected guild source")
    checkout = ROOT / "build/deps/guild-staff-api"
    checkout.mkdir(parents=True, exist_ok=True)
    if not (checkout / ".git").exists():
        run("git", "init", str(checkout))
    if subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=no"], cwd=checkout).strip():
        raise RuntimeError("Refusing to change a modified API checkout")
    run("git", "fetch", "--depth=1", REPOSITORY, SOURCE, cwd=checkout)
    run("git", "checkout", "--detach", SOURCE, cwd=checkout)
    actual = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=checkout, text=True).strip()
    if actual != SOURCE:
        raise RuntimeError("API source does not match its immutable pin")
    wrapper = checkout / ("gradlew.bat" if os.name == "nt" else "gradlew")
    if os.name != "nt":
        wrapper.chmod(wrapper.stat().st_mode | 0o100)
    run(str(wrapper), ":moderation-platform-api:jar", "--no-daemon", cwd=checkout)
    jars = [p for p in (checkout / "moderation-platform-api/build/libs").glob("*.jar")
            if not p.name.endswith(("-sources.jar", "-javadoc.jar"))]
    if len(jars) != 1:
        raise RuntimeError("Expected exactly one built moderation API JAR")
    with zipfile.ZipFile(jars[0]) as archive:
        for name in ("PunishmentLifecyclePlatform", "PunishmentLifecycleCursor", "PunishmentLifecycleEvent",
                     "PunishmentLifecyclePage", "PunishmentLifecycleSource", "PunishmentCategory"):
            if "net/enthusia/staff/moderation/api/" + name + ".class" not in archive.namelist():
                raise RuntimeError("Built JAR lacks the required lifecycle API: " + name)
    target = guilds / "libs/EnthusiaStaff-moderation-api.jar"
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(jars[0], target)
    digest = hashlib.sha256(target.read_bytes()).hexdigest()
    evidence = {"repository": REPOSITORY, "commit": SOURCE, "sha256": digest,
                "target": str(target.relative_to(ROOT))}
    (checkout.parent / "guild-staff-api.json").write_text(json.dumps(evidence, indent=2), encoding="utf-8")
    print("Verified guild Staff API", SOURCE, digest)


if __name__ == "__main__":
    main()
