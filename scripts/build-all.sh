#!/usr/bin/env bash
# Build all Enthusia plugins in dependency order.
# Requires: Git, Maven, and JDK 25.
# Usage: ./scripts/build-all.sh [--clean]

set -euo pipefail
cd "$(dirname "$0")/.."

CLEAN=false
[[ "${1:-}" == "--clean" ]] && CLEAN=true
COMBATLOGX_API_REF="4812e85af1264ebb27da481b9d9cbf8de0956e53"
DEPS_DIR="$PWD/build/deps"

echo "=== Enthusia Network Build ==="

if $CLEAN; then
    echo ">> Cleaning composite builds..."
    ./gradlew cleanAll
fi

echo ">> Building Maven plugin dependencies..."
for plugin in diary-keeper enthusia-currency playtime-plugin enthusia-commend; do
    echo "   - $plugin"
    (cd "plugins/$plugin" && mvn -q -B package -DskipTests)
done

echo ">> Staging EnthusiaPlaytime API for LumaGuilds..."
rm -rf "$DEPS_DIR/playtime-api"
mkdir -p "$DEPS_DIR/playtime-api" plugins/luma-guilds/libs
javac -d "$DEPS_DIR/playtime-api" \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/api/PlaytimeService.java \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/api/PlaytimeRange.java \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/api/PlaytimeMetric.java \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/activity/ActivityState.java \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/data/model/PlaytimeSnapshot.java \
    plugins/playtime-plugin/src/main/java/org/enthusia/playtime/data/model/RangeTotals.java
jar cf plugins/luma-guilds/libs/EnthusiaPlaytime-api.jar -C "$DEPS_DIR/playtime-api" .

echo ">> Staging CombatLogX API for LumaGuilds..."
if [ ! -d "$DEPS_DIR/combatlogx/.git" ]; then
    rm -rf "$DEPS_DIR/combatlogx"
    git clone https://github.com/SirBlobman/CombatLogX.git "$DEPS_DIR/combatlogx"
fi
git -C "$DEPS_DIR/combatlogx" fetch origin "$COMBATLOGX_API_REF"
git -C "$DEPS_DIR/combatlogx" checkout --detach "$COMBATLOGX_API_REF"
(
    cd "$DEPS_DIR/combatlogx"
    chmod +x gradlew
    ./gradlew :api:jar --no-daemon
)
combatlogx_jar=$(find "$DEPS_DIR/combatlogx/api/build/libs" -maxdepth 1 -type f -name "*.jar" \
    ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -1)
if [ -z "$combatlogx_jar" ]; then
    echo "CombatLogX API build produced no jar" >&2
    exit 1
fi
cp "$combatlogx_jar" plugins/luma-guilds/libs/CombatLogX-api.jar

echo ">> Building official RoseChat 26.2 compile API..."
(
    cd plugins/rosechat
    chmod +x gradlew
    ./gradlew -I ../../ci/rosechat/simpleclans.init.gradle shadowJar --no-daemon
)
rosechat_jar=$(find plugins/rosechat/build/libs -maxdepth 1 -type f -name "RoseChat-*.jar" | head -1)
if [ -z "$rosechat_jar" ]; then
    echo "RoseChat build produced no shaded jar" >&2
    exit 1
fi
cp "$rosechat_jar" plugins/luma-guilds/libs/RoseChat-RC-2.jar

echo ">> Building LumaGuilds 3 core artifact..."
(
    cd plugins/luma-guilds
    chmod +x gradlew
    ./gradlew shadowJar --no-daemon
)
lumaguilds_jar=$(find plugins/luma-guilds/build/libs -maxdepth 1 -type f -name "LumaGuilds-*.jar" \
    ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -1)
if [ -z "$lumaguilds_jar" ]; then
    echo "LumaGuilds build produced no shaded jar" >&2
    exit 1
fi
export LUMAGUILDS_JAR="$PWD/$lumaguilds_jar"

echo ">> Building composite plugins..."
./gradlew buildAll

echo ">> Building enthusia-biomes..."
(
    cd plugins/enthusia-biomes
    if [ -f "./gradlew" ]; then
        chmod +x gradlew
        ./gradlew shadowJar
    else
        gradle shadowJar
    fi
)

echo
echo "=== Build Complete ==="
echo "JARs:"
find plugins/*/build/libs -name "*.jar" -not -name "*-dev*" -not -name "*-sources*" 2>/dev/null | sort
