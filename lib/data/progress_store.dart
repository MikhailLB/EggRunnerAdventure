import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chapters_data.dart';
import 'facts_data.dart';

/// Central, JSON-backed persistence layer. Static so any screen can call it
/// without an inherited widget. Exposes a [ChangeNotifier] on top so widgets
/// listen only when they must (e.g. header XP bar, achievement counts).
class ProgressStore extends ChangeNotifier {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  static const String _kPrefsKey = 'feathered_origins_state_v1';

  bool _initialized = false;
  bool get initialized => _initialized;

  // Persisted state ---------------------------------------------------------
  bool tutorialSeen = false;
  Set<String> readChapters = <String>{};
  Set<String> unlockedFacts = <String>{};
  int xp = 0;
  int dailyStreak = 0;
  String? lastDailyIso; // yyyy-MM-dd of last claim
  String languageCode = 'en';
  int launchCount = 0;
  int readingSeconds = 0;
  int chaptersOpenedCount = 0;

  // Session -----------------------------------------------------------------
  DateTime _sessionStart = DateTime.now();

  static Future<void> init() async {
    if (instance._initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefsKey);
    if (raw != null) {
      try {
        final Map<String, dynamic> data =
            jsonDecode(raw) as Map<String, dynamic>;
        instance.tutorialSeen = data['tutorialSeen'] as bool? ?? false;
        instance.readChapters = ((data['readChapters'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
        instance.unlockedFacts = ((data['unlockedFacts'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
        instance.xp = (data['xp'] as num?)?.toInt() ?? 0;
        instance.dailyStreak = (data['dailyStreak'] as num?)?.toInt() ?? 0;
        instance.lastDailyIso = data['lastDailyIso'] as String?;
        instance.languageCode = data['languageCode'] as String? ?? 'en';
        instance.launchCount = (data['launchCount'] as num?)?.toInt() ?? 0;
        instance.readingSeconds =
            (data['readingSeconds'] as num?)?.toInt() ?? 0;
        instance.chaptersOpenedCount =
            (data['chaptersOpenedCount'] as num?)?.toInt() ?? 0;
      } catch (_) {
        // Corrupt payload — start fresh.
      }
    }
    instance.launchCount += 1;
    instance._initialized = true;
    await instance._save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, dynamic>{
      'tutorialSeen': tutorialSeen,
      'readChapters': readChapters.toList(),
      'unlockedFacts': unlockedFacts.toList(),
      'xp': xp,
      'dailyStreak': dailyStreak,
      'lastDailyIso': lastDailyIso,
      'languageCode': languageCode,
      'launchCount': launchCount,
      'readingSeconds': readingSeconds,
      'chaptersOpenedCount': chaptersOpenedCount,
    };
    await prefs.setString(_kPrefsKey, jsonEncode(payload));
  }

  // Public mutators ---------------------------------------------------------

  void markTutorialSeen() {
    if (tutorialSeen) return;
    tutorialSeen = true;
    _save();
    notifyListeners();
  }

  void markChapterOpened() {
    chaptersOpenedCount += 1;
    _save();
    notifyListeners();
  }

  void completeChapter(String chapterId) {
    final chapter = ChaptersData.byId(chapterId);
    final wasNew = readChapters.add(chapterId);
    if (wasNew) {
      xp += chapter.xpReward;
      for (final fk in chapter.factKeys) {
        unlockedFacts.add(fk);
      }
    }
    _save();
    notifyListeners();
  }

  void setLanguage(String code) {
    if (languageCode == code) return;
    languageCode = code;
    _save();
    notifyListeners();
  }

  void addReadingSeconds(int seconds) {
    if (seconds <= 0) return;
    readingSeconds += seconds;
    _save();
    // Reading time changes rarely surface in UI — save quietly, no notify.
  }

  void resetProgress() {
    readChapters.clear();
    unlockedFacts.clear();
    xp = 0;
    dailyStreak = 0;
    lastDailyIso = null;
    readingSeconds = 0;
    chaptersOpenedCount = 0;
    _save();
    notifyListeners();
  }

  // Daily reward ------------------------------------------------------------

  static String _today() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  bool get canClaimDaily => lastDailyIso != _today();

  /// Returns the freshly claimed reward or `null` if already claimed today.
  DailyReward? claimDaily() {
    if (!canClaimDaily) return null;

    final yesterdayIso = _yesterday();
    final streak = (lastDailyIso == yesterdayIso) ? dailyStreak + 1 : 1;
    dailyStreak = streak;
    lastDailyIso = _today();

    // Rotate through fun facts deterministically by day-of-year so users
    // get a stable "fact of the day", while still surfacing new content on
    // each subsequent claim.
    final doy = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final fact = FactsData.facts[(doy + streak) % FactsData.count];
    unlockedFacts.add(fact.id);

    final xpBonus = 10 + min(streak, 7) * 5;
    xp += xpBonus;

    _save();
    notifyListeners();
    return DailyReward(factId: fact.id, xp: xpBonus, streak: streak);
  }

  static String _yesterday() {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return '${y.year.toString().padLeft(4, '0')}-'
        '${y.month.toString().padLeft(2, '0')}-'
        '${y.day.toString().padLeft(2, '0')}';
  }

  // Reading session timing -------------------------------------------------

  void startReadingSession() {
    _sessionStart = DateTime.now();
  }

  void endReadingSession() {
    final delta = DateTime.now().difference(_sessionStart).inSeconds;
    // Ignore obviously bogus deltas.
    if (delta > 0 && delta < 4 * 60 * 60) {
      addReadingSeconds(delta);
    }
  }

  // Derived accessors ------------------------------------------------------

  int get totalChapters => ChaptersData.chapters.length;
  int get totalFacts => FactsData.count;

  double get readerProgress =>
      totalChapters == 0 ? 0 : readChapters.length / totalChapters;

  /// Chapters unlock strictly in order: the first is always open, and each
  /// subsequent chapter opens once the previous one is finished. This gives a
  /// clear sense of progression through the timeline.
  bool isChapterUnlockedAt(int index) {
    if (index <= 0) return true;
    if (index >= ChaptersData.chapters.length) return false;
    return readChapters.contains(ChaptersData.chapters[index - 1].id);
  }

  bool isChapterUnlocked(String id) =>
      isChapterUnlockedAt(ChaptersData.indexOf(id));

  /// 1-based position of the next chapter the reader should tackle.
  int get nextChapterIndex {
    for (var i = 0; i < ChaptersData.chapters.length; i++) {
      if (!readChapters.contains(ChaptersData.chapters[i].id)) return i;
    }
    return ChaptersData.chapters.length - 1;
  }

  double get codexProgress =>
      totalFacts == 0 ? 0 : unlockedFacts.length / totalFacts;

  int get level {
    // 100 XP per level, capped at 20.
    return min(20, xp ~/ 100 + 1);
  }

  int get xpToNextLevel {
    final next = level * 100;
    return max(0, next - xp);
  }

  double get levelProgress {
    final low = (level - 1) * 100;
    final high = level * 100;
    return ((xp - low) / (high - low)).clamp(0.0, 1.0);
  }

  String get henriettaRankKey {
    if (level >= 15) return 'rank_legend';
    if (level >= 10) return 'rank_rooster';
    if (level >= 6) return 'rank_hen';
    if (level >= 3) return 'rank_pullet';
    return 'rank_chick';
  }
}

@immutable
class DailyReward {
  const DailyReward({
    required this.factId,
    required this.xp,
    required this.streak,
  });
  final String factId;
  final int xp;
  final int streak;
}
