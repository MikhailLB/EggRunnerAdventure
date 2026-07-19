import 'package:flutter/material.dart';

import '../hatchway/hatch_coordinator.dart';
import '../screens/boot_screen.dart';
import '../white/white_placeholder.dart';
import 'routes.dart';
import 'theme.dart';

/// Root MaterialApp for the gray-flow template.
///
/// TEMPLATE: register EVERY named route your game uses in [onGenerateRoute]
/// (or the `routes` map). A missing route crashes the organic path with
/// "Could not find route". Wrap with your game's state provider if needed.
class FeatheredOriginsApp extends StatelessWidget {
  const FeatheredOriginsApp({super.key, this.hatchCoordinator});

  final HatchCoordinator? hatchCoordinator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: change to your app's display name.
      title: 'Gray Flow Template',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: Routes.boot,
      onGenerateRoute: (settings) {
        final Widget page = switch (settings.name) {
          // White-part entry — replace with your game's first screen.
          Routes.home => const WhitePartPlaceholder(),
          // TODO: add your game routes here.
          _ => BootScreen(hatchCoordinator: hatchCoordinator),
        };
        return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
      },
    );
  }
}
