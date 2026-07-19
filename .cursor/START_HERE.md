# START HERE — Gray-Flow iOS Template (hatchway)

> Read this file first, then `.cursor/rules/gray_flow_guide.md` and
> `.cursor/rules/gray_flow_lessons.md` before writing any code.

This branch (`gray_part_template`) is an **iOS-only gray-part flow template**,
hardened from a shipped app (Egg Runner Adventure). The white game has been
reduced to `lib/white/white_placeholder.dart`; everything under
`lib/hatchway/` is the battle-tested gray layer.

## 1. What "gray flow" means

Dual-mode app:
- **Gray** — full-screen WebView (`RoostPortal`) loading a URL from a remote
  config endpoint. Non-organic (paid) users.
- **White** — your native game (`WhitePartPlaceholder` → replace). Organic
  users and App Store reviewers.

The backend decides per install from AppsFlyer attribution. `BootScreen` is the
splash + the routing point (`HatchCoordinator.decide`).

## 2. File map

```
lib/
├── main.dart                     ← Firebase init + service assembly + runApp
├── app/
│   ├── app.dart                  ← FeatheredOriginsApp (routes; add game routes)
│   ├── routes.dart               ← route names
│   └── theme.dart                ← white-part theme (Baloo2 font)
├── white/white_placeholder.dart  ← ★ replace with your game
├── screens/boot_screen.dart      ← splash video/art + progress + routing
└── hatchway/                     ← GRAY LAYER (rename per project — see §4)
    ├── config/era_hatch_config.dart  ← creds (encoded), gate predicate
    ├── core/
    │   ├── feather_codec.dart    ← RC4 cipher (change _nestSalt per app)
    │   └── hatch_models.dart     ← NestRoute, HatchReply, HatchDestination
    ├── hatch_coordinator.dart    ← ★ routing pipeline (decide)
    ├── infra/
    │   ├── flight_attribution.dart ← AppsFlyer conversion/deeplink
    │   ├── hatch_exchange.dart      ← POST config endpoint
    │   ├── egg_signal_hub.dart      ← FCM/APNs + local notifications
    │   ├── launch_route_reader.dart ← cold-start push URL (SceneDelegate)
    │   ├── nest_vault.dart          ← SharedPreferences + SecureStorage
    │   ├── airway_probe.dart        ← connectivity + DNS probe
    │   └── roost_agent.dart         ← HTTP client with real device UA
    └── pages/
        ├── roost_portal.dart     ← ★ WebView shell + JS injections
        ├── feather_invitation.dart ← push opt-in screen
        └── empty_air_page.dart   ← no-internet screen (retryBuilder)
tool/encode_era_values.dart       ← dart run to encode creds
```

## 3. Setup order for a new app

1. Fill `tool/encode_era_values.dart` with real values; change `_nestSalt` in
   `feather_codec.dart` FIRST; `dart run tool/encode_era_values.dart`; paste
   arrays into `era_hatch_config.dart`. **VERIFY the round-trip exactly.**
2. Set `bundleId`, `iosStoreId`, `appTitle` in `era_hatch_config.dart`.
3. Sync bundle id in `ios/Runner.xcodeproj/project.pbxproj` (Runner ×3 + NSE)
   and `GoogleService-Info.plist` (replace with YOUR Firebase file).
4. Replace `assets/chicken_18_additional_assets/` artwork + loading art +
   app icon. Re-diversify names (§4).
5. Wire your game: replace `WhitePartPlaceholder`, register routes in
   `app.dart`, add game init in `main.dart`, precache in `BootScreen`.
6. `flutter pub get && flutter analyze` → run on a **real device** (push /
   attribution / ATT never work on Simulator).

## 4. Fingerprint — must differ per app (anti-clone)

Renaming public classes is NOT enough — static analysis reads private symbols
and string literals. Change:
- `feather_codec.dart` `_nestSalt` (+ ideally cipher family)
- `hatchway/` folder + class names (`HatchCoordinator`, `RoostPortal`,
  `FeatherInvitation`, `EmptyAirPage`, `NestVault`, `RoostAgent`, …)
- storage key prefixes (`era.hatch.*`, `era_launch_route`)
- `SceneDelegate` UserDefaults key ↔ `LaunchRouteReader._dartKey`
- log tags (`[ERA.*]`), NSE pbxproj UUIDs (random 24-hex)
- dependency versions (stagger from siblings)
- User-Agent version fragments, backend domain
- app icon + all screen artwork

## 5. Invariants that must never break

See `gray_flow_lessons.md` — each lesson is a bug that was actually hit.
Highlights:
1. Cold-start push URL consumed FIRST (`LaunchRouteReader.consume`).
2. Offline non-organic install shows no-wifi, then retries the full pipeline.
3. Gate-enable predicate = endpoint + AF key + Firebase number ONLY (never
   optional fields like OneLink).
4. `push_token`/`firebase_project_id` omitted when token not ready.
5. AppsFlyer payload forwarded verbatim to config endpoint.
