# Gray Flow Guide (hatchway template)

Deep reference for this template. See `../START_HERE.md` for the map and
`gray_flow_lessons.md` for the known-bug catalogue (must-read).

## State machine (`HatchCoordinator.decide`)

```
cold-start push URL present? ─ yes → save route=portal, background dispatch,
                                     open RoostPortal(coldLaunch:true)
route = undecided (first launch):
  no interface / DNS         → OfflineNest (retry re-runs pipeline)
  online → boot push → AppsFlyer signals → POST config
    reply.hasDestination     → route=portal → RoostPortal (via push invite)
    else                     → route=native → WhitePartPlaceholder
route = portal (returning):
  pending push url / cached (not expired) → RoostPortal
  else refresh signals → POST config → RoostPortal | cached | Offline
route = native (returning):
  optional re-attempt; POST config; destination? → portal else native
```

Invariants: gate enabled only when `EraHatchConfig.grayCredentialsReady`
(endpoint + AF key + Firebase number). `decide()` runs once per attempt but the
cache clears on completion so Retry re-runs (lesson 3).

## Config request contract (`HatchExchange`)

POST JSON, flat object = AppsFlyer conversion data (verbatim) + device fields:
```json
{ "af_id":"...", "af_status":"Non-organic", "media_source":"...",
  "campaign":"...", "bundle_id":"...", "os":"iOS", "store_id":"id123...",
  "locale":"en_US", "push_token":"<apns>", "firebase_project_id":"123..." }
```
- `os` = exactly `"iOS"`. `store_id` = `id<iosStoreId>`.
- Omit `push_token` + `firebase_project_id` entirely when the token isn't ready
  (never send null/""). Token arrival → `onTokenChanged` → re-POST.
- Response (gray): `{"ok":true,"url":"https://…","expires":<epoch>}`.
- Response (white): `{"ok":false,"message":"..."}`.

## Push payload (FCM → APNs)
```json
{ "apns":{"payload":{"aps":{"mutable-content":1}}},
  "data":{"url":"https://destination/..."} }
```
`mutable-content:1` required for the NSE. URL keys checked: `url/link/target/
deeplink/deep_link` at top level, `data`, and `payload`. Cold-start taps are
captured by `SceneDelegate` → `LaunchRouteReader.consume()` (called FIRST).

## Screens

- **BootScreen** (`screens/boot_screen.dart`): orientation-aware loading art +
  progress bar + `_GameTitle`. It IS the splash — never push another loader.
  Precache game assets via `_assetsToLoad`.
- **FeatherInvitation** (`hatchway/pages/feather_invitation.dart`): push opt-in.
  Big Accept/Skip buttons; landscape centered without SafeArea (lesson 9);
  re-enables landscape (lesson 10).
- **RoostPortal** (`hatchway/pages/roost_portal.dart`): WKWebView shell. Real
  device UA; `viewPadding` on all sides; JS injections on `onPageFinished`:
  inset-guard (with `overscroll-behavior:none`), zoom-lock, tap-polish,
  keyboard-lift, focus-scale, inline-playback; rotation reflow; cold-start
  resize+reload (no forced rotation). Offline via connectivity(none)=immediate,
  load-error=probe.
- **EmptyAirPage** (`hatchway/pages/empty_air_page.dart`): no-internet. Takes
  `retryBuilder`; probe host apple.com/cloudflare with timeout (VPN-safe);
  re-enables landscape.

## iOS notes
- `SceneDelegate.swift` writes the cold-start URL to UserDefaults under a key
  that matches `LaunchRouteReader._dartKey` (with the `flutter.` prefix).
- `Runner.entitlements` `aps-environment` + `CODE_SIGN_ENTITLEMENTS` on the
  **Runner** targets (not NSE). NSE has NO `baseConfigurationReference`,
  `PRODUCT_NAME="$(TARGET_NAME)"`, `SKIP_INSTALL=YES`, empty Resources phase.
- `GoogleService-Info.plist` in Runner Copy Bundle Resources. Replace with your
  own Firebase file (the template's belongs to another project).
- ATT after first frame; poll `getAPNSToken()` before `getToken()`.

## Anti-fingerprint
Reuse across apps clusters them for store scanners. Per app change: cipher salt
+ algorithm, all hatchway class/file names, storage key prefixes, log tags, NSE
UUIDs, dependency versions, UA fragments, backend domain, ALL artwork + icon.
Strip logs from release (`assert`-wrapped `eraTrace` / `#if DEBUG`).
