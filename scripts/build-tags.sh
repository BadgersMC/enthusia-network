#!/usr/bin/env bash
# Verify Tags and compile it against the renderer API from this network pin.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAGS="$ROOT/plugins/enthusia-tags"
cd "$TAGS"

if [[ -f tools/ci/bootstrap_companions.sh ]]; then
    python3 -m pip install --require-hashes -r tools/ci/requirements.txt
    python3 -m unittest discover -s tools/ci -p 'test_*.py'
    node tools/spear/ears.mjs docs/requirements.md
    node --test tools/spear/*.test.mjs
    bash tools/bootstrap_loreitems_release.sh
    bash tools/ci/bootstrap_companions.sh

    python3 - "$ROOT" <<'PY'
import pathlib
import sys
from defusedxml import ElementTree as xml
root = pathlib.Path(sys.argv[1])
ns = {"m": "http://maven.apache.org/POM/4.0.0"}
consumer = xml.parse(root / "plugins/enthusia-tags/pom.xml")
provider = xml.parse(root / "plugins/enthusia-advancements/pilot/pom.xml")
required = consumer.find(".//m:dependency[m:artifactId='EnthusiaAdvancements-pilot']/m:version", ns)
provided = provider.find("m:version", ns)
if required is None or provided is None or required.text != provided.text:
    raise SystemExit("Network pilot version does not match Tags; refusing the standalone fixture API")
PY

    # Use the runtime API provided by the actual network submodule, rather
    # than relying only on Tags' standalone compile fixture.
    mvn -B -ntp -f "$ROOT/plugins/enthusia-advancements/pilot/pom.xml" clean install
fi

mvn -B -ntp clean verify
if [[ -f tools/ci/org/enthusia/tools/SQLiteArtifactProbe.java ]]; then
    java --class-path target/EnthusiaTags.jar tools/ci/org/enthusia/tools/SQLiteArtifactProbe.java
fi
