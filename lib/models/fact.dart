import 'package:flutter/material.dart';

/// Bite-sized, popular-science fact shown in the Codex and daily rewards.
@immutable
class ChickenFact {
  const ChickenFact({
    required this.id,
    required this.titleKey,
    required this.bodyKey,
    required this.category,
    required this.emoji,
  });

  final String id;
  final String titleKey;
  final String bodyKey;
  final FactCategory category;

  /// Text glyph used as a lightweight icon (works everywhere, no assets).
  final String emoji;
}

enum FactCategory { biology, history, behavior, genetics, folklore }
