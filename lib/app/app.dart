import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_strings.dart';
import '../screens/boot_screen.dart';
import '../screens/chapter_reader_screen.dart';
import '../screens/main_shell.dart';
import '../screens/settings_screen.dart';
import 'routes.dart';
import 'theme.dart';

/// Root MaterialApp. Owns the [LocaleController] so the whole tree rebuilds
/// on language change without needing a provider package.
class FeatheredOriginsApp extends StatefulWidget {
  const FeatheredOriginsApp({super.key});

  @override
  State<FeatheredOriginsApp> createState() => _FeatheredOriginsAppState();
}

class _FeatheredOriginsAppState extends State<FeatheredOriginsApp> {
  late final LocaleController _localeController = LocaleController(
    Locale(ProgressStore.instance.languageCode),
  );

  @override
  void initState() {
    super.initState();
    _localeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Egg Runner Adventure',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: _localeController.locale,
      supportedLocales: AppStrings.supportedLocales.map(Locale.new).toList(),
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Routes.boot,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case Routes.home:
            page = const MainShell();
          case Routes.reader:
            final id = settings.arguments as String? ?? 'ch_meet';
            page = ChapterReaderScreen(chapterId: id);
          case Routes.settings:
            page = SettingsScreen(localeController: _localeController);
          case Routes.boot:
          default:
            page = const BootScreen();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
