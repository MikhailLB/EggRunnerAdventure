# Egg Runner Adventure

*The illustrated science story of chicken evolution — narrated by Henrietta Rex.*

An iPhone/iPad book app for the App Store **Books** category. Take a 150-million-year
journey with Henrietta, a modern Rhode Island Red who explains her lineage —
from Cretaceous theropods to the 25 billion chickens that share the planet today.

## Content

- **Chronicles** — 11 richly illustrated chapters spanning the Mesozoic to the modern era.
- **Daily Fact** — one bite-sized, popular-science fact per day, with streak tracking.
- **Codex** — a collectible library of 22 fun facts unlocked as you read.
- **Trophies** — 10 achievements marking milestones on the journey.
- **Settings** — reset progress, and switch UI language between English, Spanish, French, German and Portuguese.

## Screens (7)

1. Boot / loading — orientation-aware.
2. Home — hub with Henrietta, XP gauge and mode tiles.
3. Chronicles — vertical timeline of eras.
4. Chapter Reader — page-by-page reader with painted illustration per chapter.
5. Daily Fact — mystery-egg reveal with streak rewards.
6. Codex — grid of unlocked / locked fact cards.
7. Trophies — achievements list with rarity ribbons.
8. Settings — language selector, reset, about.

## Orientation policy

Following the LavaPickRun pattern:
- The **boot screen** adapts to both portrait and landscape (loading art is
  provided for both).
- Every other screen is **portrait-locked** so the book layout stays consistent.

## Tech

- Flutter 3.41 / Dart 3.11
- Rich hand-authored illustrations for the mascot and all 11 chapters.
- Persistent bottom-navigation shell (`IndexedStack`) across the 5 modes.
- Boot screen precaches every illustration and drives the loading bar from
  real asset-decode progress (bar only completes when the app is truly ready).
- Persistence via `shared_preferences`.
- In-memory localisation table (no ARB codegen) so long-form chapter prose
  stays easy to edit and translate.

## Build

```bash
flutter pub get
flutter test
flutter build ios --no-codesign      # verify on macOS
flutter build ios --release          # for App Store distribution
```

## Bundle info

- Bundle id: `com.chickenchronicles.eggRunnerAdventure`
- Display name: **Feathered Origins**
- Deployment target: iOS 13.0
- Device family: iPhone + iPad
