import '../models/fact.dart';

/// A curated deck of chicken facts. The Codex screen renders them as cards;
/// the Daily Reward screen picks one per calendar day.
class FactsData {
  static const List<ChickenFact> facts = <ChickenFact>[
    ChickenFact(
      id: 'fact_trex_cousin',
      titleKey: 'fact_trex_cousin_title',
      bodyKey: 'fact_trex_cousin_body',
      category: FactCategory.biology,
      emoji: '🦖',
    ),
    ChickenFact(
      id: 'fact_archaeopteryx',
      titleKey: 'fact_archaeopteryx_title',
      bodyKey: 'fact_archaeopteryx_body',
      category: FactCategory.history,
      emoji: '🪶',
    ),
    ChickenFact(
      id: 'fact_feathered_dinos',
      titleKey: 'fact_feathered_dinos_title',
      bodyKey: 'fact_feathered_dinos_body',
      category: FactCategory.biology,
      emoji: '🦕',
    ),
    ChickenFact(
      id: 'fact_survivors',
      titleKey: 'fact_survivors_title',
      bodyKey: 'fact_survivors_body',
      category: FactCategory.history,
      emoji: '☄️',
    ),
    ChickenFact(
      id: 'fact_galliformes',
      titleKey: 'fact_galliformes_title',
      bodyKey: 'fact_galliformes_body',
      category: FactCategory.biology,
      emoji: '🐦',
    ),
    ChickenFact(
      id: 'fact_junglefowl',
      titleKey: 'fact_junglefowl_title',
      bodyKey: 'fact_junglefowl_body',
      category: FactCategory.biology,
      emoji: '🌴',
    ),
    ChickenFact(
      id: 'fact_species_count',
      titleKey: 'fact_species_count_title',
      bodyKey: 'fact_species_count_body',
      category: FactCategory.genetics,
      emoji: '🧬',
    ),
    ChickenFact(
      id: 'fact_first_farm',
      titleKey: 'fact_first_farm_title',
      bodyKey: 'fact_first_farm_body',
      category: FactCategory.history,
      emoji: '🏺',
    ),
    ChickenFact(
      id: 'fact_oracle',
      titleKey: 'fact_oracle_title',
      bodyKey: 'fact_oracle_body',
      category: FactCategory.folklore,
      emoji: '🔮',
    ),
    ChickenFact(
      id: 'fact_egyptian_incubator',
      titleKey: 'fact_egyptian_incubator_title',
      bodyKey: 'fact_egyptian_incubator_body',
      category: FactCategory.history,
      emoji: '🥚',
    ),
    ChickenFact(
      id: 'fact_rooster_cross',
      titleKey: 'fact_rooster_cross_title',
      bodyKey: 'fact_rooster_cross_body',
      category: FactCategory.folklore,
      emoji: '⛪',
    ),
    ChickenFact(
      id: 'fact_new_world',
      titleKey: 'fact_new_world_title',
      bodyKey: 'fact_new_world_body',
      category: FactCategory.history,
      emoji: '⛵',
    ),
    ChickenFact(
      id: 'fact_leghorn',
      titleKey: 'fact_leghorn_title',
      bodyKey: 'fact_leghorn_body',
      category: FactCategory.genetics,
      emoji: '🐔',
    ),
    ChickenFact(
      id: 'fact_chicken_of_tomorrow',
      titleKey: 'fact_chicken_of_tomorrow_title',
      bodyKey: 'fact_chicken_of_tomorrow_body',
      category: FactCategory.history,
      emoji: '🏆',
    ),
    ChickenFact(
      id: 'fact_25_billion',
      titleKey: 'fact_25_billion_title',
      bodyKey: 'fact_25_billion_body',
      category: FactCategory.biology,
      emoji: '🌍',
    ),
    ChickenFact(
      id: 'fact_space_egg',
      titleKey: 'fact_space_egg_title',
      bodyKey: 'fact_space_egg_body',
      category: FactCategory.history,
      emoji: '🚀',
    ),
    ChickenFact(
      id: 'fact_dream',
      titleKey: 'fact_dream_title',
      bodyKey: 'fact_dream_body',
      category: FactCategory.behavior,
      emoji: '💤',
    ),
    ChickenFact(
      id: 'fact_face_recognition',
      titleKey: 'fact_face_recognition_title',
      bodyKey: 'fact_face_recognition_body',
      category: FactCategory.behavior,
      emoji: '👁️',
    ),
    ChickenFact(
      id: 'fact_sounds',
      titleKey: 'fact_sounds_title',
      bodyKey: 'fact_sounds_body',
      category: FactCategory.behavior,
      emoji: '📣',
    ),
    ChickenFact(
      id: 'fact_pores',
      titleKey: 'fact_pores_title',
      bodyKey: 'fact_pores_body',
      category: FactCategory.biology,
      emoji: '🥚',
    ),
    ChickenFact(
      id: 'fact_color_vision',
      titleKey: 'fact_color_vision_title',
      bodyKey: 'fact_color_vision_body',
      category: FactCategory.biology,
      emoji: '🌈',
    ),
    ChickenFact(
      id: 'fact_math',
      titleKey: 'fact_math_title',
      bodyKey: 'fact_math_body',
      category: FactCategory.behavior,
      emoji: '🧮',
    ),
  ];

  static ChickenFact byId(String id) => facts.firstWhere((f) => f.id == id);
  static int get count => facts.length;
}
