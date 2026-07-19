import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════
// WHITE PART PLACEHOLDER — replace with your real game.
// ════════════════════════════════════════════════════════════
//
// This is the ONLY integration point between the gray flow and your
// game (white part). The gray flow routes here when the backend says
// the user is organic / unattributed (no offer to show) and this is
// what App Store reviewers see.
//
// HOW TO INTEGRATE YOUR GAME:
//   1. Drop your game code into lib/ (screens/, widgets/, data/, …).
//   2. Register every named route your game pushes to in
//      lib/app/app.dart (a missing route crashes the organic path).
//   3. In lib/screens/boot_screen.dart → _openDestination(), replace
//      WhitePartPlaceholder with your game's first screen. Do NOT push
//      a second loading screen — BootScreen already IS the splash.
//   4. Re-add any game asset precache in BootScreen._assetsToLoad so the
//      progress bar reflects real work.
//   5. Delete this file.
//
// WHAT THE GRAY FLOW ALREADY PROVIDES (do not re-implement):
//   • Firebase init (lib/main.dart)
//   • AppsFlyer attribution (hatchway/infra/flight_attribution.dart)
//   • Push notifications + cold-start URL (hatchway/infra/egg_signal_hub,
//     launch_route_reader + ios/Runner/SceneDelegate.swift)
//   • Config endpoint dispatch (hatchway/infra/hatch_exchange.dart)
//   • Session persistence (hatchway/infra/nest_vault.dart)
//   • WebView shell + offline/permit screens (hatchway/pages/*)
//
// Your game code MUST NOT depend on any hatchway/ class.
// ════════════════════════════════════════════════════════════
class WhitePartPlaceholder extends StatelessWidget {
  const WhitePartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.egg_alt_rounded, size: 72, color: Color(0xFFFF9F1C)),
              SizedBox(height: 20),
              Text(
                'WHITE PART PLACEHOLDER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF2A1A0E),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Replace WhitePartPlaceholder in\n'
                'lib/white/white_placeholder.dart\n'
                "with your game's first screen.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF806A5A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
