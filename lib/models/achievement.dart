import 'package:flutter/material.dart';

/// Static definition of a trophy. Progress is calculated at read-time from
/// [ProgressStore]; keeps definitions purely declarative.
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.goal,
    required this.progressGetter,
    required this.icon,
    required this.rarity,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;

  /// Target value to reach.
  final int goal;

  /// Function that returns current progress from the app state.
  final int Function() progressGetter;

  final IconData icon;
  final AchievementRarity rarity;

  double get percent => goal == 0 ? 0 : (progressGetter().clamp(0, goal) / goal).toDouble();
  bool get unlocked => progressGetter() >= goal;
  int get current => progressGetter().clamp(0, goal);
}

enum AchievementRarity { common, rare, epic, legendary }
