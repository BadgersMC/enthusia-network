#!/usr/bin/env bash
# Build all Enthusia plugins in dependency order.
# Usage: ./scripts/build-all.sh [--clean]

set -euo pipefail
cd "$(dirname "$0")/.."

CLEAN=false
[[ "${1:-}" == "--clean" ]] && CLEAN=true

echo "=== Enthusia Network Build ==="

if $CLEAN; then
    echo ">> Cleaning all builds..."
    ./gradlew cleanAll
fi

# Build composite (luma-guilds -> item-shops -> arm-guilds-bridge -> enthusia-advancements, luma-sg)
echo ">> Building composite plugins (Gradle 8.x)..."
./gradlew buildAll

# Build enthusia-biomes separately (requires Gradle 9.x / paperweight)
echo ">> Building enthusia-biomes (Gradle 9.x)..."
cd plugins/enthusia-biomes
if [ -f "./gradlew" ]; then
    ./gradlew shadowJar
else
    gradle shadowJar
fi
cd ../..

echo ""
echo "=== Build Complete ==="
echo "JARs:"
find plugins/*/build/libs -name "*.jar" -not -name "*-dev*" -not -name "*-sources*" 2>/dev/null | sort
