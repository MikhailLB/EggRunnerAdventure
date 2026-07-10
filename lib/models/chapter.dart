import 'package:flutter/material.dart';

/// Immutable evolutionary chapter in Henrietta's story.
///
/// Each chapter represents a distinct era in chicken lineage. Palettes and
/// symbols drive the illustrated backgrounds we paint inside the reader.
@immutable
class Chapter {
  const Chapter({
    required this.id,
    required this.era,
    required this.titleKey,
    required this.periodKey,
    required this.subtitleKey,
    required this.pageKeys,
    required this.factKeys,
    required this.palette,
    required this.symbol,
    required this.xpReward,
    required this.image,
  });

  final String id;
  final ChapterEra era;
  final String titleKey;
  final String periodKey;
  final String subtitleKey;

  /// Ordered translation keys for reader "pages" (a screenful of text each).
  final List<String> pageKeys;

  /// Fun-fact ids unlocked by finishing this chapter.
  final List<String> factKeys;

  final ChapterPalette palette;
  final ChapterSymbol symbol;
  final int xpReward;

  /// Full illustration asset for this chapter.
  final String image;
}

enum ChapterEra { mesozoic, extinction, cenozoic, ancient, classical, medieval, colonial, industrial, modern }

@immutable
class ChapterPalette {
  const ChapterPalette({
    required this.top,
    required this.bottom,
    required this.accent,
    required this.ink,
  });

  final Color top;
  final Color bottom;
  final Color accent;
  final Color ink;
}

/// Simple, painter-friendly symbols per chapter (no external art required).
enum ChapterSymbol {
  archaeopteryx,
  asteroid,
  fossilFeather,
  jungleTree,
  wheatBundle,
  laurelWreath,
  medievalCoop,
  sailingShip,
  gear,
  globe,
}
