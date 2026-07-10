import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'data/progress_store.dart';

/// Entrypoint. Warms up local persistence and sets a friendly system-UI
/// overlay before mounting the material app. Orientation is left flexible
/// so the boot screen can render in both portrait and landscape; screens
/// downstream lock to portrait themselves.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ProgressStore.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFF6E1),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const FeatheredOriginsApp());
}
