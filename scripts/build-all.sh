#!/usr/bin/env bash
# Build all Enthusia plugins in dependency order.
# Requires: Git, Maven, and JDK 25.
# Usage: ./scripts/build-all.sh [--clean]

set -euo pipefail
cd "$(dirname "$0")/.."

CLEAN=false
[[ "${1:-}" == "--clean" ]] && CLEAN=true
COMBATLOGX_API_REF="4812e85af1264ebb27da481b9d9cbf8de0956e53"
NEXUS_REF="057836befb9e35aa252cf90104030ec86f28b33f"
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

echo ">> Verifying EnthusiaSignature (including tracker regression tests)..."
(cd plugins/enthusia-signature && mvn -B -ntp clean verify)

mapfile -t playtime_jars < <(find plugins/playtime-plugin/target -maxdepth 1 -type f \
    -name 'playtime-plugin-*.jar' ! -name '*-sources.jar' ! -name '*-javadoc.jar')
if [[ "${#playtime_jars[@]}" -ne 1 ]]; then
    echo 'Expected one current Playtime artifact; clean its target directory before building.' >&2
    exit 1
fi
export ENTHUSIAPLAYTIME_JAR="$PWD/${playtime_jars[0]}"

echo ">> Verifying EnthusiaTags against the network renderer..."
bash scripts/build-tags.sh

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

echo ">> Building canonical Enthusia RoseChat..."
(
    cd plugins/rosechat
    chmod +x gradlew
    ./gradlew shadowJar --no-daemon
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

echo ">> Publishing Nexus 2.3.0 dependency locally..."
if [ ! -d "$DEPS_DIR/nexus/.git" ]; then
    rm -rf "$DEPS_DIR/nexus"
    git clone https://github.com/BadgersMC/Nexus.git "$DEPS_DIR/nexus"
fi
git -C "$DEPS_DIR/nexus" fetch origin "$NEXUS_REF"
git -C "$DEPS_DIR/nexus" checkout --detach "$NEXUS_REF"
(
    cd "$DEPS_DIR/nexus"
    chmod +x gradlew
    ./gradlew publishToMavenLocal --no-daemon
)
export USE_MAVEN_LOCAL_NEXUS=true

echo ">> Building EnthusiaMarket 26.2 artifact..."
(
    cd plugins/enthusia-market
    chmod +x gradlew
    ./gradlew shadowJar -PuseMavenLocal=true --no-daemon
)
enthusiamarket_jar=$(find plugins/enthusia-market/build/libs -maxdepth 1 -type f -name "EnthusiaMarket-*.jar"     ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -1)
if [ -z "$enthusiamarket_jar" ]; then
    echo "EnthusiaMarket build produced no shaded jar" >&2
    exit 1
fi
export ENTHUSIAMARKET_JAR="$PWD/$enthusiamarket_jar"

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
find plugins -type f \( -path "*/build/libs/*.jar" -o -path "*/target/*.jar" \) \
    ! -name "*-dev*" ! -name "*-sources*" ! -name "*-javadoc*" ! -name "original-*" | sort
