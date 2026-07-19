import 'package:flutter/material.dart';

import '../models/chapter.dart';

/// The complete Egg Runner Adventure storyline, in chronological order.
///
/// The narrative deliberately blends established palaeontology with playful
/// storytelling around Henrietta Rex — a fictional narrator who guides the
/// reader through her ancestors' journey. Only translation keys live here;
/// the actual prose lives in `l10n/app_strings.dart` so it can be localised.
///
/// Chapters are grouped into three "Acts" of five for a clear sense of
/// progression, and unlock sequentially (finish one to open the next).
class ChaptersData {
  static const List<Chapter> chapters = <Chapter>[
    // ===== ACT I — DEEP TIME =====
    Chapter(
      id: 'ch_meet',
      era: ChapterEra.modern,
      titleKey: 'chapter_meet_title',
      periodKey: 'chapter_meet_period',
      subtitleKey: 'chapter_meet_subtitle',
      pageKeys: ['chapter_meet_p1', 'chapter_meet_p2', 'chapter_meet_p3'],
      factKeys: ['fact_trex_cousin', 'fact_wishbone'],
      palette: ChapterPalette(
        top: Color(0xFFFFF4CC),
        bottom: Color(0xFFFFD07A),
        accent: Color(0xFFD64545),
        ink: Color(0xFF3E2A1F),
      ),
      symbol: ChapterSymbol.globe,
      xpReward: 20,
      image: 'assets/chapters/ch_meet.webp',
    ),
    Chapter(
      id: 'ch_thunder',
      era: ChapterEra.mesozoic,
      titleKey: 'chapter_thunder_title',
      periodKey: 'chapter_thunder_period',
      subtitleKey: 'chapter_thunder_subtitle',
      pageKeys: [
        'chapter_thunder_p1',
        'chapter_thunder_p2',
        'chapter_thunder_p3',
        'chapter_thunder_p4',
      ],
      factKeys: ['fact_archaeopteryx', 'fact_feathered_dinos'],
      palette: ChapterPalette(
        top: Color(0xFFDDF3E4),
        bottom: Color(0xFF7CB78A),
        accent: Color(0xFF264653),
        ink: Color(0xFF1F2A2E),
      ),
      symbol: ChapterSymbol.archaeopteryx,
      xpReward: 30,
      image: 'assets/chapters/ch_thunder.webp',
    ),
    Chapter(
      id: 'ch_extinction',
      era: ChapterEra.extinction,
      titleKey: 'chapter_extinction_title',
      periodKey: 'chapter_extinction_period',
      subtitleKey: 'chapter_extinction_subtitle',
      pageKeys: [
        'chapter_extinction_p1',
        'chapter_extinction_p2',
        'chapter_extinction_p3',
      ],
      factKeys: ['fact_survivors'],
      palette: ChapterPalette(
        top: Color(0xFFFFE0B2),
        bottom: Color(0xFFD35400),
        accent: Color(0xFF6E1F00),
        ink: Color(0xFF2A0A00),
      ),
      symbol: ChapterSymbol.asteroid,
      xpReward: 30,
      image: 'assets/chapters/ch_extinction.webp',
    ),
    Chapter(
      id: 'ch_cenozoic',
      era: ChapterEra.cenozoic,
      titleKey: 'chapter_cenozoic_title',
      periodKey: 'chapter_cenozoic_period',
      subtitleKey: 'chapter_cenozoic_subtitle',
      pageKeys: [
        'chapter_cenozoic_p1',
        'chapter_cenozoic_p2',
        'chapter_cenozoic_p3',
      ],
      factKeys: ['fact_galliformes'],
      palette: ChapterPalette(
        top: Color(0xFFD9F0FF),
        bottom: Color(0xFF6EC1E4),
        accent: Color(0xFF1B6E9C),
        ink: Color(0xFF0E2B3E),
      ),
      symbol: ChapterSymbol.fossilFeather,
      xpReward: 30,
      image: 'assets/chapters/ch_cenozoic.webp',
    ),
    Chapter(
      id: 'ch_egg',
      era: ChapterEra.cenozoic,
      titleKey: 'chapter_egg_title',
      periodKey: 'chapter_egg_period',
      subtitleKey: 'chapter_egg_subtitle',
      pageKeys: ['chapter_egg_p1', 'chapter_egg_p2', 'chapter_egg_p3'],
      factKeys: ['fact_pores', 'fact_color_vision'],
      palette: ChapterPalette(
        top: Color(0xFFFFF7D6),
        bottom: Color(0xFFFFD24D),
        accent: Color(0xFFE08A00),
        ink: Color(0xFF4A3210),
      ),
      symbol: ChapterSymbol.fossilFeather,
      xpReward: 35,
      image: 'assets/chapters/ch_egg.webp',
    ),

    // ===== ACT II — MEETING HUMANS =====
    Chapter(
      id: 'ch_jungle',
      era: ChapterEra.ancient,
      titleKey: 'chapter_jungle_title',
      periodKey: 'chapter_jungle_period',
      subtitleKey: 'chapter_jungle_subtitle',
      pageKeys: [
        'chapter_jungle_p1',
        'chapter_jungle_p2',
        'chapter_jungle_p3',
        'chapter_jungle_p4',
      ],
      factKeys: [
        'fact_junglefowl',
        'fact_species_count',
        'fact_flight_record',
        'fact_comb',
      ],
      palette: ChapterPalette(
        top: Color(0xFFE8FBD8),
        bottom: Color(0xFF2E8B57),
        accent: Color(0xFFC0392B),
        ink: Color(0xFF1A3D26),
      ),
      symbol: ChapterSymbol.jungleTree,
      xpReward: 35,
      image: 'assets/chapters/ch_jungle.webp',
    ),
    Chapter(
      id: 'ch_indus',
      era: ChapterEra.ancient,
      titleKey: 'chapter_indus_title',
      periodKey: 'chapter_indus_period',
      subtitleKey: 'chapter_indus_subtitle',
      pageKeys: ['chapter_indus_p1', 'chapter_indus_p2', 'chapter_indus_p3'],
      factKeys: ['fact_first_farm'],
      palette: ChapterPalette(
        top: Color(0xFFFFF3D6),
        bottom: Color(0xFFE7A72E),
        accent: Color(0xFF8B4A00),
        ink: Color(0xFF3A2200),
      ),
      symbol: ChapterSymbol.wheatBundle,
      xpReward: 35,
      image: 'assets/chapters/ch_indus.webp',
    ),
    Chapter(
      id: 'ch_silkroad',
      era: ChapterEra.ancient,
      titleKey: 'chapter_silkroad_title',
      periodKey: 'chapter_silkroad_period',
      subtitleKey: 'chapter_silkroad_subtitle',
      pageKeys: [
        'chapter_silkroad_p1',
        'chapter_silkroad_p2',
        'chapter_silkroad_p3',
      ],
      factKeys: ['fact_sounds'],
      palette: ChapterPalette(
        top: Color(0xFFFFEFC7),
        bottom: Color(0xFFE0A040),
        accent: Color(0xFF9C3B1B),
        ink: Color(0xFF3A2410),
      ),
      symbol: ChapterSymbol.sailingShip,
      xpReward: 40,
      image: 'assets/chapters/ch_silkroad.webp',
    ),
    Chapter(
      id: 'ch_classical',
      era: ChapterEra.classical,
      titleKey: 'chapter_classical_title',
      periodKey: 'chapter_classical_period',
      subtitleKey: 'chapter_classical_subtitle',
      pageKeys: [
        'chapter_classical_p1',
        'chapter_classical_p2',
        'chapter_classical_p3',
      ],
      factKeys: ['fact_oracle', 'fact_egyptian_incubator'],
      palette: ChapterPalette(
        top: Color(0xFFF5EFD3),
        bottom: Color(0xFFD9C384),
        accent: Color(0xFF6B4423),
        ink: Color(0xFF2F1F0E),
      ),
      symbol: ChapterSymbol.laurelWreath,
      xpReward: 40,
      image: 'assets/chapters/ch_classical.webp',
    ),
    Chapter(
      id: 'ch_medieval',
      era: ChapterEra.medieval,
      titleKey: 'chapter_medieval_title',
      periodKey: 'chapter_medieval_period',
      subtitleKey: 'chapter_medieval_subtitle',
      pageKeys: [
        'chapter_medieval_p1',
        'chapter_medieval_p2',
        'chapter_medieval_p3',
      ],
      factKeys: ['fact_rooster_cross', 'fact_rooster_clock'],
      palette: ChapterPalette(
        top: Color(0xFFEDE1D1),
        bottom: Color(0xFF8E7A5A),
        accent: Color(0xFF3E2C1B),
        ink: Color(0xFF241708),
      ),
      symbol: ChapterSymbol.medievalCoop,
      xpReward: 40,
      image: 'assets/chapters/ch_medieval.webp',
    ),

    // ===== ACT III — INTO THE MODERN WORLD =====
    Chapter(
      id: 'ch_colonial',
      era: ChapterEra.colonial,
      titleKey: 'chapter_colonial_title',
      periodKey: 'chapter_colonial_period',
      subtitleKey: 'chapter_colonial_subtitle',
      pageKeys: [
        'chapter_colonial_p1',
        'chapter_colonial_p2',
        'chapter_colonial_p3',
      ],
      factKeys: ['fact_new_world'],
      palette: ChapterPalette(
        top: Color(0xFFDCEEF9),
        bottom: Color(0xFF3A7CA5),
        accent: Color(0xFFEEB93A),
        ink: Color(0xFF0F2A3F),
      ),
      symbol: ChapterSymbol.sailingShip,
      xpReward: 40,
      image: 'assets/chapters/ch_colonial.webp',
    ),
    Chapter(
      id: 'ch_darwin',
      era: ChapterEra.industrial,
      titleKey: 'chapter_darwin_title',
      periodKey: 'chapter_darwin_period',
      subtitleKey: 'chapter_darwin_subtitle',
      pageKeys: ['chapter_darwin_p1', 'chapter_darwin_p2', 'chapter_darwin_p3'],
      factKeys: ['fact_face_recognition'],
      palette: ChapterPalette(
        top: Color(0xFFEDE6D2),
        bottom: Color(0xFFA98D5E),
        accent: Color(0xFF3E5A3A),
        ink: Color(0xFF2A2416),
      ),
      symbol: ChapterSymbol.laurelWreath,
      xpReward: 45,
      image: 'assets/chapters/ch_darwin.webp',
    ),
    Chapter(
      id: 'ch_industrial',
      era: ChapterEra.industrial,
      titleKey: 'chapter_industrial_title',
      periodKey: 'chapter_industrial_period',
      subtitleKey: 'chapter_industrial_subtitle',
      pageKeys: [
        'chapter_industrial_p1',
        'chapter_industrial_p2',
        'chapter_industrial_p3',
      ],
      factKeys: ['fact_leghorn', 'fact_chicken_of_tomorrow', 'fact_earlobe'],
      palette: ChapterPalette(
        top: Color(0xFFDDE7EB),
        bottom: Color(0xFF6C7A83),
        accent: Color(0xFFB84A2C),
        ink: Color(0xFF1E2A31),
      ),
      symbol: ChapterSymbol.gear,
      xpReward: 45,
      image: 'assets/chapters/ch_industrial.webp',
    ),
    Chapter(
      id: 'ch_modern',
      era: ChapterEra.modern,
      titleKey: 'chapter_modern_title',
      periodKey: 'chapter_modern_period',
      subtitleKey: 'chapter_modern_subtitle',
      pageKeys: [
        'chapter_modern_p1',
        'chapter_modern_p2',
        'chapter_modern_p3',
        'chapter_modern_p4',
      ],
      factKeys: [
        'fact_25_billion',
        'fact_space_egg',
        'fact_dream',
        'fact_pecking_order',
      ],
      palette: ChapterPalette(
        top: Color(0xFFE9F6FF),
        bottom: Color(0xFF69B7FF),
        accent: Color(0xFFFF6B6B),
        ink: Color(0xFF0F2743),
      ),
      symbol: ChapterSymbol.globe,
      xpReward: 55,
      image: 'assets/chapters/ch_modern.webp',
    ),
    Chapter(
      id: 'ch_future',
      era: ChapterEra.modern,
      titleKey: 'chapter_future_title',
      periodKey: 'chapter_future_period',
      subtitleKey: 'chapter_future_subtitle',
      pageKeys: ['chapter_future_p1', 'chapter_future_p2', 'chapter_future_p3'],
      factKeys: ['fact_math'],
      palette: ChapterPalette(
        top: Color(0xFFE6F7FB),
        bottom: Color(0xFF57C8D6),
        accent: Color(0xFF1B7A8C),
        ink: Color(0xFF0E2E36),
      ),
      symbol: ChapterSymbol.gear,
      xpReward: 70,
      image: 'assets/chapters/ch_future.webp',
    ),
  ];

  static Chapter byId(String id) => chapters.firstWhere((c) => c.id == id);
  static int indexOf(String id) => chapters.indexWhere((c) => c.id == id);
  static int totalXp() => chapters.fold<int>(0, (a, c) => a + c.xpReward);

  /// All chapter image assets — used to precache during boot.
  static List<String> allImages() => chapters.map((c) => c.image).toList();

  /// Chapters are grouped into Acts of this size for the Chronicles list.
  static const int actSize = 5;
  static int get actCount => (chapters.length + actSize - 1) ~/ actSize;
}
