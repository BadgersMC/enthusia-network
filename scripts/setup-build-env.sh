#!/usr/bin/env bash
# Bootstrap local build dependencies for enthusia-network.
# Resolves the RoseChat <-> LumaGuilds circular compileOnly dependency,
# publishes Nexus to mavenLocal, and installs a portable Maven if needed.
#
# Usage: ./scripts/setup-build-env.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE="$(dirname "$ROOT")"
NEXUS_DIR="${NEXUS_DIR:-$WORKSPACE/Nexus}"
ROSECHAT_DIR="${ROSECHAT_DIR:-$WORKSPACE/Enthusia-RoseChat}"
MAVEN_HOME="${MAVEN_HOME:-$HOME/.local/apache-maven/apache-maven-3.9.9}"
STUB_DIR="$ROOT/.build-stubs/rosechat-api"

log() { echo ">> $*"; }

ensure_maven() {
    if command -v mvn >/dev/null 2>&1; then
        return
    fi
    if [[ ! -x "$MAVEN_HOME/bin/mvn" ]]; then
        log "Installing portable Maven 3.9.9..."
        mkdir -p "$(dirname "$MAVEN_HOME")"
        curl -fsSL https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz \
            | tar xz -C "$(dirname "$MAVEN_HOME")"
    fi
    export PATH="$MAVEN_HOME/bin:$PATH"
}

ensure_repo() {
    local url="$1" dir="$2"
    if [[ ! -d "$dir/.git" ]]; then
        log "Cloning $url -> $dir"
        git clone --depth=1 "$url" "$dir"
    fi
}

publish_nexus() {
    ensure_repo "https://github.com/BadgersMC/Nexus.git" "$NEXUS_DIR"
    log "Publishing Nexus artifacts to mavenLocal..."
    (
        cd "$NEXUS_DIR"
        chmod +x gradlew
        bash ./gradlew publishToMavenLocal -PuseMavenLocal=true --no-daemon
    )
}

build_rosechat_stub() {
    log "Building minimal RoseChat API stub for initial LumaGuilds compile..."
    rm -rf "$STUB_DIR"
    mkdir -p "$STUB_DIR/src/main/java/dev/rosewood/rosechat/"{api,chat/channel,chat,message,manager}

    cat > "$STUB_DIR/src/main/java/dev/rosewood/rosechat/chat/channel/Channel.java" <<'EOF'
package dev.rosewood.rosechat.chat.channel;
public class Channel {
    private String id;
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
}
EOF

    cat > "$STUB_DIR/src/main/java/dev/rosewood/rosechat/chat/PlayerData.java" <<'EOF'
package dev.rosewood.rosechat.chat;
import dev.rosewood.rosechat.chat.channel.Channel;
public class PlayerData {
    public Channel currentChannel;
}
EOF

    cat > "$STUB_DIR/src/main/java/dev/rosewood/rosechat/manager/ChannelManager.java" <<'EOF'
package dev.rosewood.rosechat.manager;
import dev.rosewood.rosechat.chat.channel.Channel;
public class ChannelManager {
    public Channel getChannel(String id) { return null; }
    public Channel getDefaultChannel() { return null; }
}
EOF

    cat > "$STUB_DIR/src/main/java/dev/rosewood/rosechat/api/RoseChatAPI.java" <<'EOF'
package dev.rosewood.rosechat.api;
import dev.rosewood.rosechat.chat.channel.Channel;
import dev.rosewood.rosechat.manager.ChannelManager;
public final class RoseChatAPI {
    private static RoseChatAPI instance;
    public ChannelManager channelManager = new ChannelManager();
    public Channel defaultChannel;
    public static RoseChatAPI getInstance() { return instance; }
}
EOF

    cat > "$STUB_DIR/src/main/java/dev/rosewood/rosechat/message/RosePlayer.java" <<'EOF'
package dev.rosewood.rosechat.message;
import dev.rosewood.rosechat.chat.PlayerData;
import dev.rosewood.rosechat.chat.channel.Channel;
import org.bukkit.entity.Player;
public class RosePlayer {
    public PlayerData playerData;
    public RosePlayer(Player player) {}
    public void switchChannel(Channel channel) {}
}
EOF

    mkdir -p "$ROOT/plugins/luma-guilds/libs"
    javac --release 21 \
        -cp "$(find "$HOME/.gradle/caches" -name 'paper-api-*.jar' 2>/dev/null | head -1 || echo '')" \
        -d "$STUB_DIR/build/classes" \
        $(find "$STUB_DIR/src/main/java" -name '*.java') 2>/dev/null || {
        # paper-api may not be cached yet; compile without it (stubs don't need Bukkit at runtime)
        javac --release 21 -d "$STUB_DIR/build/classes" $(find "$STUB_DIR/src/main/java" -name '*.java')
    }
    jar cf "$ROOT/plugins/luma-guilds/libs/RoseChat-RC-2.jar" -C "$STUB_DIR/build/classes" .
    log "Stub jar: plugins/luma-guilds/libs/RoseChat-RC-2.jar"
}

build_luma_guilds() {
    log "Building LumaGuilds..."
    (
        cd "$ROOT/plugins/luma-guilds"
        chmod +x gradlew
        bash ./gradlew shadowJar --no-daemon
    )
}

build_rosechat_real() {
    ensure_repo "https://github.com/BadgersMC/Enthusia-RoseChat.git" "$ROSECHAT_DIR"
    log "Building real RoseChat (requires LumaGuilds jar)..."
    mkdir -p "$ROSECHAT_DIR/libs"
    cp "$ROOT/plugins/luma-guilds/build/libs/LumaGuilds-"*.jar "$ROSECHAT_DIR/libs/LumaGuilds-2.1.0.jar"
    (
        cd "$ROSECHAT_DIR"
        chmod +x gradlew
        bash ./gradlew shadowJar --no-daemon
    )
    cp "$ROSECHAT_DIR/build/libs/RoseChat-RC-2.jar" "$ROOT/plugins/luma-guilds/libs/RoseChat-RC-2.jar"
    log "Replaced stub with real RoseChat jar"
}

rebuild_luma_guilds() {
    log "Rebuilding LumaGuilds against real RoseChat..."
    (
        cd "$ROOT/plugins/luma-guilds"
        bash ./gradlew shadowJar --no-daemon
    )
}

main() {
    log "=== Enthusia Network Build Environment Setup ==="
    ensure_maven
    publish_nexus
    build_rosechat_stub
    build_luma_guilds
    build_rosechat_real
    rebuild_luma_guilds
    log "=== Setup complete ==="
    log "Next: ./scripts/build-all.sh"
}

main "$@"