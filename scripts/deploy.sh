#!/usr/bin/env bash
# Deploy built plugin JARs to a server's plugins directory.
# Usage: ./scripts/deploy.sh <server-plugins-dir>
#
# Example: ./scripts/deploy.sh /opt/minecraft/plugins
#          ./scripts/deploy.sh ~/servers/test/plugins

set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?Usage: deploy.sh <server-plugins-dir>}"

if [ ! -d "$TARGET" ]; then
    echo "Error: $TARGET is not a directory"
    exit 1
fi

echo "=== Deploying Enthusia plugins to $TARGET ==="

declare -A JARS=(
    ["luma-guilds"]="LumaGuilds-*.jar"
    ["enthusia-advancements"]="EnthusiaAdvancements-*.jar"
    ["arm-guilds-bridge"]="ARM-Guilds-Bridge-*.jar"
    ["item-shops"]="ItemShops-*.jar"
    ["enthusia-biomes"]="EnthusiaBiomes-*.jar"
    ["luma-sg"]="LumaSG-*.jar"
)

copied=0
for plugin in "${!JARS[@]}"; do
    pattern="plugins/$plugin/build/libs/${JARS[$plugin]}"
    # Exclude dev/sources JARs
    jar=$(find plugins/$plugin/build/libs -maxdepth 1 -name "${JARS[$plugin]}" \
          -not -name "*-dev*" -not -name "*-sources*" -not -name "*-all*" 2>/dev/null | head -1)

    if [ -n "$jar" ]; then
        cp "$jar" "$TARGET/"
        echo "  Copied $(basename "$jar")"
        ((copied++))
    else
        echo "  SKIP $plugin (no JAR found — run build-all.sh first)"
    fi
done

echo ""
echo "=== Deployed $copied plugin(s) to $TARGET ==="
