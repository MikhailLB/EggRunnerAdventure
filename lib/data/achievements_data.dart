import 'package:flutter/material.dart';

import '../models/achievement.dart';
import 'progress_store.dart';

/// Registry of all trophies. Definitions are cheap to enumerate; UI reads
/// `progressGetter` at build time.
class AchievementsData {
  static List<Achievement> all() {
    final store = ProgressStore.instance;
    return <Achievement>[
      Achievement(
        id: 'ach_origin',
        titleKey: 'ach_origin_title',
        descriptionKey: 'ach_origin_desc',
        goal: 1,
        progressGetter: () => store.readChapters.length,
        icon: Icons.auto_stories_rounded,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'ach_time_traveler',
        titleKey: 'ach_time_traveler_title',
        descriptionKey: 'ach_time_traveler_desc',
        goal: 3,
        progressGetter: () => store.readChapters.length,
        icon: Icons.hourglass_top_rounded,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'ach_historian',
        titleKey: 'ach_historian_title',
        descriptionKey: 'ach_historian_desc',
        goal: store.totalChapters,
        progressGetter: () => store.readChapters.length,
        icon: Icons.workspace_premium_rounded,
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: 'ach_daily',
        titleKey: 'ach_daily_title',
        descriptionKey: 'ach_daily_desc',
        goal: 3,
        progressGetter: () => store.dailyStreak,
        icon: Icons.calendar_today_rounded,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'ach_streak_week',
        titleKey: 'ach_streak_week_title',
        descriptionKey: 'ach_streak_week_desc',
        goal: 7,
        progressGetter: () => store.dailyStreak,
        icon: Icons.local_fire_department_rounded,
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 'ach_facts_5',
        titleKey: 'ach_facts_5_title',
        descriptionKey: 'ach_facts_5_desc',
        goal: 5,
        progressGetter: () => store.unlockedFacts.length,
        icon: Icons.lightbulb_rounded,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 'ach_codex',
        titleKey: 'ach_codex_title',
        descriptionKey: 'ach_codex_desc',
        goal: store.totalFacts,
        progressGetter: () => store.unlockedFacts.length,
        icon: Icons.menu_book_rounded,
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: 'ach_reader_100',
        titleKey: 'ach_reader_100_title',
        descriptionKey: 'ach_reader_100_desc',
        goal: 100 * 60,
        progressGetter: () => store.readingSeconds,
        icon: Icons.timer_rounded,
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 'ach_hello',
        titleKey: 'ach_hello_title',
        descriptionKey: 'ach_hello_desc',
        goal: 1,
        progressGetter: () => store.launchCount,
        icon: Icons.pets_rounded,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 'ach_returner',
        titleKey: 'ach_returner_title',
        descriptionKey: 'ach_returner_desc',
        goal: 5,
        progressGetter: () => store.launchCount,
        icon: Icons.autorenew_rounded,
        rarity: AchievementRarity.rare,
      ),
    ];
  }
}
