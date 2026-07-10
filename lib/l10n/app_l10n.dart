import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import 'app_strings.dart';

/// Lightweight, in-memory localisation solution. We deliberately avoid
/// intl/ARB codegen because chapter prose is easier to edit inline, and
/// because we want to switch language at runtime without restarting.
class AppL10n {
  AppL10n(this.locale);

  final Locale locale;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  String t(String key, [Map<String, String>? params]) {
    var value = AppStrings.get(key, locale.languageCode);
    if (params != null) {
      params.forEach((k, v) => value = value.replaceAll('{$k}', v));
    }
    return value;
  }
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.contains(locale.languageCode);

  @override
  Future<AppL10n> load(Locale locale) => SynchronousFuture(AppL10n(locale));

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

/// Notifier that surfaces the currently selected locale to MaterialApp.
class LocaleController extends ChangeNotifier {
  LocaleController(this._locale);

  Locale _locale;
  Locale get locale => _locale;

  void set(String code) {
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    ProgressStore.instance.setLanguage(code);
    notifyListeners();
  }
}
