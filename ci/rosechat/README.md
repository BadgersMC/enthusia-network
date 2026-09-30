# RoseChat source tracking

`plugins/rosechat` points to the canonical Enthusia source, `BadgersMC/Enthusia-RoseChat`.

The pinned commit is the exact RoseChat source built by monorepo CI and staged as LumaGuilds' compile API. Rosewood Development remains the external upstream; upstream changes should be reconciled into the Enthusia fork first, then the monorepo pin should be advanced.

LumaGuilds 3.x owns and registers its RoseChat channel provider at runtime. RoseChat must not carry a second compiled copy of LumaGuilds internals.

The historical `RoseChat-RC-2.jar` filename under LumaGuilds is only a local compile-path alias. Monorepo CI copies the freshly built canonical RoseChat jar to that filename until LumaGuilds removes the legacy filename assumption.
