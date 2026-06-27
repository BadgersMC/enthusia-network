#!/usr/bin/env bash
# Build all Enthusia plugins in dependency order.
# Usage: ./scripts/build-all.sh [--clean]

set -euo pipefail
cd "$(dirname "$0")/.."

CLEAN=false
[[ "${1:-}" == "--clean" ]] && CLEAN=true

echo "=== Enthusia Network Build ==="

# Bootstrap private/local deps (Nexus, RoseChat, LumaGuilds circular compileOnly)
if [[ ! -f plugins/luma-guilds/libs/RoseChat-RC-2.jar ]] || ! ls ~/.m2/repository/net/badgersmc/nexus-core/*/nexus-core-*.jar >/dev/null 2>&1; then
    echo ">> Running build environment setup (first-time or missing deps)..."
    ./scripts/setup-build-env.sh
fi

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
