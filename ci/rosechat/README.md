# RoseChat upstream tracking

`plugins/rosechat` points directly at `Rosewood-Development/RoseChat`, not an Enthusia fork.

Current baseline: `179483128fa2020f3ad8b0e4192ada3d0a251c49` (`Add 26.2 support`). It builds against Paper 26.2 with Java 25.

Historical Enthusia forks (`wsg138/Enthusia-RoseChat` and `FainNeito/Enthusia-RoseChat`) are migration inputs only. They are not the canonical upstream.

RoseChat's license permits local use/modification/merge but forbids publishing or redistributing the software. For that reason this public monorepo does not commit modified RoseChat source, patch payloads, or built RoseChat jars.

The public CI build uses the pinned official source only as a compile dependency for LumaGuilds. The Enthusia runtime build is reconciled locally/private from this exact official baseline.

`simpleclans.init.gradle` substitutes the SimpleClans 2.19.2 artifact from Modrinth because the canonical Maven endpoint can fail TLS negotiation. It does not modify RoseChat source.
