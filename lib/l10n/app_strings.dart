/// Simple, dependency-free localisation table. English is the canonical
/// content; other locales fall back to English for any missing key so the
/// app never renders blank strings.
///
/// We chose a static map (over ARB codegen) because the story chapters
/// consist of long-form prose which is easier to author here and gives us
/// full control over line breaks and punctuation.
class AppStrings {
  static const String defaultLocale = 'en';
  static const List<String> supportedLocales = <String>['en', 'es', 'fr', 'de', 'pt'];

  static String label(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
    }
    return code;
  }

  static String flag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'pt':
        return '🇵🇹';
    }
    return '🏳️';
  }

  static String get(String key, String locale) {
    final bucket = _tables[locale] ?? _tables[defaultLocale]!;
    return bucket[key] ?? _tables[defaultLocale]![key] ?? key;
  }

  static const Map<String, Map<String, String>> _tables = <String, Map<String, String>>{
    'en': _en,
    'es': _es,
    'fr': _fr,
    'de': _de,
    'pt': _pt,
  };

  // === English (canonical) ================================================

  static const Map<String, String> _en = <String, String>{
    // App
    'app_title': 'Egg Runner Adventure',
    'app_tagline': 'The illustrated story of chicken evolution',
    'author_line': 'Narrated by Henrietta Rex, 3rd of her name',

    // Bottom navigation / home tiles
    'menu_home': 'Home',
    'menu_chapters': 'Chronicles',
    'menu_daily': 'Daily Fact',
    'menu_facts': 'Codex',
    'menu_trophies': 'Trophies',
    'menu_settings': 'Settings',

    // Home
    'home_greeting': 'Hi, I\'m Henrietta.',
    'home_intro': 'A modern hen with 150 million years of family history. Ready to travel the timeline with me?',
    'home_cta_chapters': 'Read the Chronicles',
    'home_continue': 'Continue reading',
    'home_explore': 'Explore',
    'menu_chapters_sub': 'Read the illustrated timeline',
    'menu_daily_sub': 'A new fact every day',
    'menu_facts_sub': 'Your chicken-fact collection',
    'menu_trophies_sub': 'Milestones and rewards',
    'home_cta_daily': 'Claim your daily fact',
    'home_cta_daily_done': 'Come back tomorrow',
    'home_progress_reader': 'Reader progress',
    'home_progress_codex': 'Codex unlocked',
    'home_progress_level': 'Rank',
    'home_progress_xp': 'XP',
    'home_streak': 'Day streak',
    'home_next_reward_in': 'Next reward available today',

    // Ranks
    'rank_chick': 'Curious Chick',
    'rank_pullet': 'Pullet Explorer',
    'rank_hen': 'Wise Hen',
    'rank_rooster': 'Historian Rooster',
    'rank_legend': 'Legendary Elder',

    // Chapters list
    'chapters_title': 'The Chronicles',
    'chapters_subtitle': 'Eleven eras that shaped who I am today.',
    'chapters_page_of': 'Page {current} of {total}',
    'chapters_read': 'Read',
    'chapters_unread': 'Unread',
    'chapters_start': 'Start',
    'chapters_reread': 'Re-read',
    'chapters_next': 'Next page',
    'chapters_prev': 'Previous page',
    'chapters_finish': 'Finish chapter',
    'loading': 'Loading',
    'chapters_act1': 'Act I · Deep Time',
    'chapters_act2': 'Act II · Meeting Humans',
    'chapters_act3': 'Act III · The Modern World',
    'chapters_locked': 'Finish the previous chapter to unlock',
    'chapters_locked_short': 'Locked',
    'chapters_reward_title': 'Chapter unlocked!',
    'chapters_reward_xp': 'You earned {xp} XP.',
    'chapters_reward_close': 'Continue',

    // Daily
    'daily_title': 'Daily Fact',
    'daily_subtitle': 'A new discovery every day.',
    'daily_claim': 'Reveal today\'s fact',
    'daily_already_title': 'You are all caught up',
    'daily_already_body': 'Come back after midnight for the next revelation from Henrietta\'s notebook.',
    'daily_streak': 'Streak',
    'daily_days': 'days',
    'daily_reward_xp': '+{xp} XP',

    // Codex
    'codex_title': 'Feather Codex',
    'codex_subtitle': '{unlocked} of {total} unlocked',
    'codex_locked': 'Locked — read chapters to unlock',
    'codex_category_biology': 'Biology',
    'codex_category_history': 'History',
    'codex_category_behavior': 'Behavior',
    'codex_category_genetics': 'Genetics',
    'codex_category_folklore': 'Folklore',

    // Trophies
    'trophies_title': 'Trophy Coop',
    'trophies_subtitle': 'Milestones on your journey with Henrietta.',
    'trophies_locked': 'Locked',
    'trophies_unlocked': 'Unlocked',
    'trophies_progress': '{current} / {goal}',
    'rarity_common': 'Common',
    'rarity_rare': 'Rare',
    'rarity_epic': 'Epic',
    'rarity_legendary': 'Legendary',

    // Settings
    'settings_title': 'Settings',
    'settings_language': 'Language',
    'settings_language_hint': 'The story is written in English. Interface labels are translated.',
    'settings_reset': 'Reset progress',
    'settings_reset_hint': 'Erases XP, streaks and unlocked facts.',
    'settings_reset_confirm': 'Reset everything?',
    'settings_reset_confirm_body': 'This cannot be undone.',
    'settings_reset_confirm_yes': 'Yes, reset',
    'settings_reset_confirm_no': 'Cancel',
    'settings_about': 'About',
    'settings_about_body': 'Egg Runner Adventure is a popular-science illustrated storybook about the 150-million-year journey of the humble chicken, narrated by Henrietta the hen.',
    'settings_version': 'Version 1.0.0',

    // Boot
    'boot_hint': 'Preparing timeline...',

    // Chapters — Meet Henrietta
    'chapter_meet_title': 'Meet Henrietta',
    'chapter_meet_period': 'Today',
    'chapter_meet_subtitle': 'A modern hen with an ancient family tree.',
    'chapter_meet_p1': 'Hi, I\'m Henrietta Rex — a Rhode Island Red with a suspiciously grand middle name. Every rooster on the block calls me "the historian", and honestly, they\'re not wrong. I keep a leather notebook in the henhouse where I sketch feathers and jot down family stories.',
    'chapter_meet_p2': 'Most folks look at me and see a friendly barnyard bird. But if you rewind the clock 150 million years, my great-great-great (imagine a hundred more of those) grandparents were terrifying, tooth-toting theropod dinosaurs. Yes, really.',
    'chapter_meet_p3': 'Grab your favourite mug of tea. Over the next few chapters I\'ll walk you through eras of thunder, extinction, oceans, jungles, temples and factories — and how I somehow ended up laying eggs behind the compost bin.',

    // Chapters — The Thunder Age
    'chapter_thunder_title': 'The Thunder Age',
    'chapter_thunder_period': '150 – 66 million years ago',
    'chapter_thunder_subtitle': 'How my dinosaur cousins invented feathers.',
    'chapter_thunder_p1': 'The Mesozoic was loud. Volcanoes belched sulphur, ferns crowded every shoreline, and the biggest predators walked on two legs — a group called theropods. Modern genetics has confirmed the twist: I\'m a theropod too. My chest bone, wishbone and hollow leg bones are all identical in structure to the ones found in T. rex fossils.',
    'chapter_thunder_p2': 'The star of this era, at least in our family album, is Archaeopteryx — a magpie-sized creature that fluttered through Bavarian lagoons around 150 million years ago. It had asymmetric flight feathers like me, but also sharp teeth and a bony tail. Half bird, half lizard, entirely legendary.',
    'chapter_thunder_p3': 'Feathers didn\'t appear so my cousins could fly. They arrived long before flight, probably for warmth and display. Some theropods, like Anchiornis, sported striking black-and-orange plumage — the peacocks of the Jurassic.',
    'chapter_thunder_p4': 'Small feathered dinosaurs scampered under the giants\' feet, ate insects, hoarded seeds, and learned to leap from branch to branch. That branch — literally — is where the family tree of every living bird begins.',

    // Chapters — The Great Extinction
    'chapter_extinction_title': 'When the Sky Fell',
    'chapter_extinction_period': '66 million years ago',
    'chapter_extinction_subtitle': 'The asteroid, the dark years, and a tiny survivor.',
    'chapter_extinction_p1': 'One awful afternoon 66 million years ago, an asteroid roughly the size of Manhattan slammed into what is now the Yucatán Peninsula. The sky burned, then went dark for years. Global temperatures crashed. Three-quarters of every species on Earth vanished, including nearly all dinosaurs.',
    'chapter_extinction_p2': 'But not all of them. A handful of small, feathered, seed-eating theropods squeezed through the bottleneck. Being tiny and beak-equipped turned out to be a survival superpower — you can crack a fallen seed even when the forest is ash.',
    'chapter_extinction_p3': 'So next time somebody says "chickens are dinosaurs", they mean it in the most literal way possible. Every chicken alive today is a direct descendant of a survivor of that dark decade. I like to think of my ancient ancestor sitting on a smoking log, eating a spruce seed and refusing to give up.',

    // Chapters — Cenozoic Feathers
    'chapter_cenozoic_title': 'A New Sky',
    'chapter_cenozoic_period': '60 – 25 million years ago',
    'chapter_cenozoic_subtitle': 'Birds inherit the Earth.',
    'chapter_cenozoic_p1': 'With the giants gone, the survivors radiated wildly. Within a few million years, ancestors of ducks, pigeons, parrots and — most importantly for us — the order Galliformes appeared. Galliformes means "chicken-like": stout, ground-loving birds that would rather run than fly.',
    'chapter_cenozoic_p2': 'These are the true great-great-grandparents of every partridge, turkey, pheasant, quail and — eventually — jungle fowl on Earth. If you look at my wide feet and my terrible flying skills, that history is written all over me.',
    'chapter_cenozoic_p3': 'Fossilised Galliform bones show up on every continent except Antarctica. Wherever forests grew, the chicken-like birds followed, scratching leaf litter for insects and seeds — a habit I inherited without any training whatsoever.',

    // Chapters — Junglefowl
    'chapter_jungle_title': 'The Red Junglefowl',
    'chapter_jungle_period': '~8 000 BCE, Southeast Asia',
    'chapter_jungle_subtitle': 'The direct ancestor of every chicken on Earth.',
    'chapter_jungle_p1': 'Fast-forward to the Southeast Asian jungle around 10 000 years ago. In the bamboo thickets of what we now call Thailand, Vietnam and Malaysia, a bright-red bird with a metallic voice patrolled the forest floor. Meet Gallus gallus — the red junglefowl. That\'s my direct ancestor.',
    'chapter_jungle_p2': 'Junglefowl males are stunning: emerald-green tail feathers, a scarlet comb and a call so piercing it can travel a kilometre through dense forest. Females are the colour of dry leaves — near-invisible on the forest floor while brooding.',
    'chapter_jungle_p3': 'DNA studies published in 2020 pinned down the chicken\'s origin story to a specific subspecies, Gallus gallus spadiceus, and a specific region — northern Thailand and Myanmar. Every chicken from Alaska to Argentina traces its lineage there.',
    'chapter_jungle_p4': 'Even after millennia of domestication, junglefowl DNA still shows up in me. It\'s why I dust-bathe, roost in trees when I can, and get thoroughly grumpy about strange sounds in the yard.',

    // Chapters — Indus Valley
    'chapter_indus_title': 'The First Farm',
    'chapter_indus_period': '~3200 BCE, Indus Valley',
    'chapter_indus_subtitle': 'A partnership begins.',
    'chapter_indus_p1': 'Somewhere in the Indus Valley — likely in the Harappa or Mohenjo-daro region — humans and junglefowl began an unusual friendship. Archaeologists have unearthed clay figurines of roosters and painted seals showing chickens as early as 3200 BCE.',
    'chapter_indus_p2': 'Curiously, the first "domesticated" chickens may not have been raised for eggs or meat at all. Evidence suggests they were kept for cockfighting and religious ritual first, with agriculture following centuries later.',
    'chapter_indus_p3': 'From the Indus, chickens hopped along trade routes to Mesopotamia and eventually the Mediterranean. Every farmyard hen in the world can trace her family tree back to a South Asian ancestor with an appetite for rice grains and a fondness for humans who provided them.',

    // Chapters — Classical
    'chapter_classical_title': 'Sacred and Prophetic',
    'chapter_classical_period': '1500 – 500 BCE, Egypt, Greece, Rome',
    'chapter_classical_subtitle': 'When my ancestors were oracles.',
    'chapter_classical_p1': 'The ancient Egyptians were the first to invent something extraordinary: the artificial incubator. Long clay ovens, warmed by fires and tended by masters called "the chicken doctors", could hatch tens of thousands of eggs at a time. This technology was so precious it stayed a state secret for two thousand years.',
    'chapter_classical_p2': 'In Greece and Rome, chickens became oracles. Before every important battle, a priest would offer grain to sacred chickens; if the birds ate greedily, victory was assured. In 249 BCE, Roman consul Publius Claudius Pulcher famously threw the sacred chickens overboard when they refused to eat — and promptly lost the sea battle.',
    'chapter_classical_p3': 'My distant relatives were also fashion icons. Wealthy Romans bred chickens for spectacular plumage, and Julius Caesar himself is credited with introducing chickens to Britain during his conquests around 55 BCE.',

    // Chapters — Medieval
    'chapter_medieval_title': 'Medieval Farmyards',
    'chapter_medieval_period': '500 – 1500 CE',
    'chapter_medieval_subtitle': 'A quiet, essential millennium.',
    'chapter_medieval_p1': 'The Middle Ages weren\'t glamorous for us. Chickens were the peasant\'s protein — cheap to keep, unfussy about food, and productive. A single hen might lay a hundred eggs a year (compare that to the 320+ a modern layer produces).',
    'chapter_medieval_p2': 'Roosters, though, became powerful symbols. In the 9th century, Pope Nicholas I decreed that every church should be topped with a rooster weathervane, referencing the Gospel story of Peter\'s denial. That is why to this day so many old European churches wear a metal chicken on the spire.',
    'chapter_medieval_p3': 'It was also during this era that specific breeds began to appear. Silky-feathered "silkies" arrived from China (probably brought back by Marco Polo, according to legend), while French farmers began selecting for the meaty Bresse hen, still one of the world\'s most prized breeds.',

    // Chapters — Colonial
    'chapter_colonial_title': 'The Voyage Age',
    'chapter_colonial_period': '1500 – 1800 CE',
    'chapter_colonial_subtitle': 'How my ancestors conquered the New World.',
    'chapter_colonial_p1': 'When European ships crossed the Atlantic, chickens sailed with them. Christopher Columbus\'s second voyage in 1493 brought chickens to the Caribbean, but here\'s a plot twist: DNA evidence suggests Polynesian chickens may have reached Chile a century before Columbus arrived.',
    'chapter_colonial_p2': 'By the 1700s, chickens had become the world\'s most cosmopolitan farm animal. Sailors kept them aboard for eggs; explorers traded them at every port; and each region began to develop its own breeds — the sturdy American Dominique, the massive Shanghai (later renamed Cochin), the tiny Serama of Malaysia.',
    'chapter_colonial_p3': 'Chicken keeping became fashionable. Queen Victoria was famously gifted a flock of Cochin chickens in 1842 and started a "hen fever" that swept Britain and America — the Victorian era\'s Beanie Baby craze.',

    // Chapters — Industrial
    'chapter_industrial_title': 'Industrial Reinvention',
    'chapter_industrial_period': '1900 – 1960 CE',
    'chapter_industrial_subtitle': 'The chicken becomes a modern product.',
    'chapter_industrial_p1': 'The twentieth century transformed us. In 1911, the "trap nest" was invented — a device that recorded which hens laid which eggs — allowing breeders to select for productivity with astonishing precision. A hen that laid 150 eggs a year in 1900 could lay 300 by 1960.',
    'chapter_industrial_p2': 'In 1948, an American competition called "Chicken of Tomorrow" set out to design the ideal broiler. The winning cross became the ancestor of nearly every meat chicken alive today. Broiler chickens now reach market weight in six weeks — a quarter of the time it took in 1950.',
    'chapter_industrial_p3': 'Not all industrial history is happy. The rise of factory farming during this period changed how humans relate to chickens, sparking modern welfare movements and, more recently, a global embrace of free-range and heritage breeds. My own flock is the barnyard kind — thankfully.',

    // Chapters — Modern
    'chapter_modern_title': 'Twenty-Five Billion',
    'chapter_modern_period': 'Today',
    'chapter_modern_subtitle': 'The most successful bird in the history of Earth.',
    'chapter_modern_p1': 'At any given moment, roughly 25 billion chickens are alive on Earth — more than every other bird species combined. If we counted the total biomass of birds, chickens alone would outweigh all wild birds put together, by three times over.',
    'chapter_modern_p2': 'We\'ve been to space. In 1989, a shuttle mission carried chicken embryos into orbit to study zero-gravity development. Astronaut John Glenn later called us "the most well-travelled birds in history".',
    'chapter_modern_p3': 'We dream. Yes, seriously. Chickens have REM sleep, and studies with tiny EEG caps show that our brains produce dream-like activity, especially after a busy day of foraging. What do we dream of? Probably corn.',
    'chapter_modern_p4': 'And we\'re not done. Geneticists are already sequencing every major breed, restoring endangered heritage lines, and studying the deep dinosaur genes that could — if switched on — give some future chicken descendant a fine tail of scales again. My family story, it turns out, is far from finished.',

    // Chapters — The Incredible Egg
    'chapter_egg_title': 'The Incredible Egg',
    'chapter_egg_period': 'Science spotlight',
    'chapter_egg_subtitle': 'The clever package that made it all possible.',
    'chapter_egg_p1': 'Time for a science break! Before we meet the humans, let me show you my family\'s proudest invention: the egg. Animals were laying hard-shelled "amniotic" eggs for over 300 million years — long before the first dinosaur roared. That egg was a revolution: it let animals raise their young on dry land instead of in water.',
    'chapter_egg_p2': 'An egg is a complete life-support pod. The yolk is the food pantry. The clear white (albumen) is a shock-absorbing water supply. A pocket of air at the blunt end gives the chick its first breath. And the shell? It looks solid, but it is dotted with up to 17,000 microscopic pores so oxygen can seep in and carbon dioxide can escape.',
    'chapter_egg_p3': 'A hen turns her eggs gently and keeps them at a cosy 37.5°C. In just 21 days a single cell becomes a fully formed chick — with a heart, eyes, feathers and a special "egg tooth" to chip its way out. Not bad for something you can hold in one hand!',

    // Chapters — The Silk Road
    'chapter_silkroad_title': 'A Long Journey',
    'chapter_silkroad_period': '1000 BCE – 500 CE, Asia',
    'chapter_silkroad_subtitle': 'How my family clucked its way across a continent.',
    'chapter_silkroad_p1': 'From the first farms of the Indus, my relatives became world travellers. Merchants discovered that a chicken was the perfect travelling companion: small, cheap to feed, and she produced fresh eggs along the way. Who needs a refrigerator?',
    'chapter_silkroad_p2': 'Along the great trade routes — later nicknamed the Silk Road — chickens spread east into China and Korea and south across the islands of the Pacific. Polynesian voyagers even carried them thousands of kilometres by canoe to settle the most remote islands on Earth.',
    'chapter_silkroad_p3': 'Everywhere they landed, people fell in love with them. Different lands shaped different birds: silky-feathered fowls in China, spirited game birds in Southeast Asia, tiny ornamental bantams. My family tree was branching out beautifully.',

    // Chapters — Darwin's Favourite Birds
    'chapter_darwin_title': 'Darwin\'s Favourite Birds',
    'chapter_darwin_period': '1850s, England',
    'chapter_darwin_subtitle': 'How chickens helped explain all of life.',
    'chapter_darwin_p1': 'Here is one that makes me proud. When Charles Darwin was working out his theory of evolution, he did not only study finches on faraway islands — he studied chickens and pigeons right at home in England.',
    'chapter_darwin_p2': 'The Victorians were mad for fancy breeds — a craze called "hen fever". Darwin noticed that by choosing which birds to breed, people could create wildly different chickens in just a few generations: giant Cochins, crested Polish, fluffy Silkies. If humans could reshape a bird so quickly, he reasoned, imagine what nature could do over millions of years.',
    'chapter_darwin_p3': 'So my funny-looking cousins became living proof for one of the biggest ideas in all of science. Darwin wrote about domestic fowl in his famous books. Not bad for a barnyard bird, eh?',

    // Chapters — The Dinosaur Within
    'chapter_future_title': 'The Dinosaur Within',
    'chapter_future_period': 'Tomorrow',
    'chapter_future_subtitle': 'Could a chicken become a dinosaur again?',
    'chapter_future_p1': 'We have travelled 150 million years together — but my story is not over. Today scientists read my DNA to understand exactly how dinosaurs became birds. And some of them are asking a wild question: could we switch those ancient genes back on?',
    'chapter_future_p2': 'It is real science. Researchers have already grown chicken embryos with more dinosaur-like snouts instead of beaks, and leg bones closer to those of Archaeopteryx. The playful nickname for this work is the "chickenosaurus". Do not worry — nobody is hatching raptors; it is simply a way to read the instructions hidden in my genes.',
    'chapter_future_p3': 'Every time you crack an egg you are holding a living dinosaur descendant — one that survived an asteroid, crossed oceans, sat beside emperors and helped explain life itself. From a tiny survivor on a smoking log to 25 billion friends worldwide: what a journey. Thank you for walking the timeline with me. — Henrietta',

    // Facts
    'fact_trex_cousin_title': 'A T. rex Cousin',
    'fact_trex_cousin_body': 'Molecular studies of collagen preserved in T. rex bones show chickens are its closest living relatives — closer than any living reptile.',

    'fact_archaeopteryx_title': 'Meet Archaeopteryx',
    'fact_archaeopteryx_body': 'Discovered in 1861 in Bavarian limestone, Archaeopteryx had feathers AND teeth. It is often called "the first bird", though scientists still debate whether it truly flew.',

    'fact_feathered_dinos_title': 'Feathers Before Flight',
    'fact_feathered_dinos_body': 'Feathers evolved at least 25 million years before flight. Their original purpose was probably insulation and courtship display — think of them as dinosaur peacocks.',

    'fact_survivors_title': 'Beak Was the Key',
    'fact_survivors_body': 'A 2022 study of the Chicxulub extinction concluded that having a beak (instead of teeth) let small dinosaurs eat hardy seeds during the years without sunlight. That single trait may be why birds exist today.',

    'fact_galliformes_title': 'The Chicken Order',
    'fact_galliformes_body': 'Chickens belong to the order Galliformes, along with turkeys, pheasants, grouse, quail and peacocks. Galliformes fossils appear on every continent except Antarctica.',

    'fact_junglefowl_title': 'One Ancestor',
    'fact_junglefowl_body': 'Every domestic chicken descends from the red junglefowl (Gallus gallus) of Southeast Asia. A 2020 study narrowed the origin further, to the subspecies Gallus gallus spadiceus.',

    'fact_species_count_title': 'Three Billion Genomes',
    'fact_species_count_body': 'The chicken genome was fully sequenced in 2004 — the first bird ever. Chickens have about a billion base pairs, roughly a third of the human genome.',

    'fact_first_farm_title': 'The Very First Coop',
    'fact_first_farm_body': 'Clay figurines of roosters unearthed at Mohenjo-daro (Indus Valley) date to around 3200 BCE and represent some of the oldest evidence of chicken keeping.',

    'fact_oracle_title': 'Sacred Chickens',
    'fact_oracle_body': 'Roman commanders consulted sacred chickens before battle. The birds\' appetite predicted victory or defeat — a practice still commemorated on coins from the Republic.',

    'fact_egyptian_incubator_title': 'Ancient Incubators',
    'fact_egyptian_incubator_body': 'Egyptians built massive clay incubators that could hatch 10 000 eggs at once, keeping the temperature within 0.5°C — using nothing but firewood and expertise. The technology stayed secret for 2 000 years.',

    'fact_rooster_cross_title': 'Rooster on the Steeple',
    'fact_rooster_cross_body': 'In 826 CE, Pope Nicholas I ordered that every church be crowned with a rooster weather-vane — a reference to Peter\'s denial of Jesus at cock-crow.',

    'fact_new_world_title': 'Ocean-Going Chickens',
    'fact_new_world_body': 'DNA from bones found in Chile suggests Polynesian sailors brought chickens to South America nearly a century before Columbus — a "chicken before the ship".',

    'fact_leghorn_title': 'The Racing Layer',
    'fact_leghorn_body': 'The Leghorn breed, imported to America from the port of Livorno (Leghorn in English) in the 1850s, is behind almost every commercial egg layer today.',

    'fact_chicken_of_tomorrow_title': 'Chicken of Tomorrow',
    'fact_chicken_of_tomorrow_body': 'A 1948 competition of the same name selected the parent stock for the modern broiler. Its winner grew twice as fast as its 1900 ancestor.',

    'fact_25_billion_title': 'The Most Common Bird',
    'fact_25_billion_body': 'There are more chickens than any other bird on Earth — around 25 billion at any moment. Combined, they outweigh every wild bird species by a factor of three.',

    'fact_space_egg_title': 'Chickens in Orbit',
    'fact_space_egg_body': 'In 1989 the STS-29 mission carried 32 fertilised chicken eggs into space to study embryonic development in microgravity.',

    'fact_dream_title': 'Chickens Dream',
    'fact_dream_body': 'EEG recordings show that chickens have REM sleep — the phase where dreams occur in humans. What they dream of is anybody\'s guess (corn, probably).',

    'fact_face_recognition_title': 'Face Memory',
    'fact_face_recognition_body': 'Studies at the University of Bristol show that chickens can recognise more than 100 distinct human and chicken faces, and remember them for years.',

    'fact_sounds_title': 'Thirty Words',
    'fact_sounds_body': 'Chickens use at least 24-30 distinct calls with specific meanings, from "food found" to "there\'s a hawk overhead". They pass this vocabulary down to their chicks.',

    'fact_pores_title': 'Breathing Shells',
    'fact_pores_body': 'A chicken egg\'s shell has between 7 000 and 17 000 microscopic pores that let air in — critical for the developing embryo.',

    'fact_color_vision_title': 'Four-Colour Vision',
    'fact_color_vision_body': 'Chickens are tetrachromats — they see red, green, blue AND ultraviolet. Their world is more colourful than ours.',

    'fact_math_title': 'Little Mathematicians',
    'fact_math_body': 'Chicks as young as five days old have been shown to perform simple addition and subtraction in laboratory experiments.',

    'fact_wishbone_title': 'Make a Wish',
    'fact_wishbone_body': 'The wishbone you pull at dinner is the furcula — a fused collarbone. Predatory dinosaurs like Velociraptor had one too, and it helps power the wingbeat in birds.',

    'fact_flight_record_title': 'The Longest Flight',
    'fact_flight_record_body': 'Chickens can fly, just not far. The longest recorded chicken flight lasted 13 seconds and covered about 91 metres (301 feet).',

    'fact_comb_title': 'The Living Radiator',
    'fact_comb_body': 'A chicken\'s comb and wattles aren\'t just for show — they shed body heat to keep her cool, and their bright red colour signals good health to the flock.',

    'fact_earlobe_title': 'Read the Earlobes',
    'fact_earlobe_body': 'You can often guess an egg\'s shell colour from a hen\'s earlobes: white lobes usually mean white eggs, red lobes usually mean brown eggs.',

    'fact_rooster_clock_title': 'A Clock Inside',
    'fact_rooster_clock_body': 'A 2013 study showed roosters crow at dawn thanks to an internal circadian clock — even in constant dim light, they still crow roughly every 24 hours.',

    'fact_pecking_order_title': 'The Real Pecking Order',
    'fact_pecking_order_body': 'The phrase comes from real chicken society. Norwegian scientist Thorleif Schjelderup-Ebbe described the strict social ladder of a flock in the 1920s.',

    // Achievements
    'ach_origin_title': 'Origin Story',
    'ach_origin_desc': 'Finish your first chapter.',
    'ach_time_traveler_title': 'Time Traveller',
    'ach_time_traveler_desc': 'Finish three chapters.',
    'ach_historian_title': 'Feathered Historian',
    'ach_historian_desc': 'Finish every chapter.',
    'ach_daily_title': 'Daily Devotee',
    'ach_daily_desc': 'Claim three daily facts.',
    'ach_streak_week_title': 'A Week of Wisdom',
    'ach_streak_week_desc': 'Claim seven daily facts in a row.',
    'ach_facts_5_title': 'Fact Finder',
    'ach_facts_5_desc': 'Unlock five fun facts.',
    'ach_codex_title': 'Codex Complete',
    'ach_codex_desc': 'Unlock every fact in the codex.',
    'ach_reader_100_title': 'Century Reader',
    'ach_reader_100_desc': 'Spend a hundred minutes reading.',
    'ach_hello_title': 'First Hello',
    'ach_hello_desc': 'Open the app for the first time.',
    'ach_returner_title': 'Loyal Reader',
    'ach_returner_desc': 'Open the app five times.',
  };

  // === Spanish ============================================================

  static const Map<String, String> _es = <String, String>{
    'app_title': 'Egg Runner Adventure',
    'app_tagline': 'La historia ilustrada de la evolución de la gallina',
    'author_line': 'Narrado por Henrietta Rex, tercera de su nombre',
    'menu_home': 'Inicio',
    'menu_chapters': 'Crónicas',
    'menu_daily': 'Dato del día',
    'menu_facts': 'Códice',
    'menu_trophies': 'Trofeos',
    'menu_settings': 'Ajustes',
    'home_greeting': 'Hola, soy Henrietta.',
    'home_intro': 'Una gallina moderna con 150 millones de años de historia familiar. ¿Lista para viajar en el tiempo conmigo?',
    'home_cta_chapters': 'Leer las Crónicas',
    'home_cta_daily': 'Descubrir el dato del día',
    'home_cta_daily_done': 'Vuelve mañana',
    'home_progress_reader': 'Progreso de lectura',
    'home_progress_codex': 'Códice desbloqueado',
    'home_progress_level': 'Rango',
    'home_progress_xp': 'PE',
    'home_streak': 'Racha diaria',
    'home_next_reward_in': 'Recompensa disponible hoy',
    'rank_chick': 'Pollito Curioso',
    'rank_pullet': 'Polla Exploradora',
    'rank_hen': 'Gallina Sabia',
    'rank_rooster': 'Gallo Historiador',
    'rank_legend': 'Anciana Legendaria',
    'chapters_title': 'Las Crónicas',
    'chapters_subtitle': 'Once eras que me hicieron quien soy hoy.',
    'chapters_page_of': 'Página {current} de {total}',
    'chapters_read': 'Leído',
    'chapters_unread': 'Sin leer',
    'chapters_start': 'Empezar',
    'chapters_reread': 'Releer',
    'loading': 'Cargando',
    'chapters_next': 'Siguiente',
    'chapters_prev': 'Anterior',
    'chapters_finish': 'Terminar capítulo',
    'chapters_reward_title': '¡Capítulo desbloqueado!',
    'chapters_reward_xp': 'Has ganado {xp} PE.',
    'chapters_reward_close': 'Continuar',
    'daily_title': 'Dato del día',
    'daily_subtitle': 'Un descubrimiento nuevo cada día.',
    'daily_claim': 'Revelar el dato de hoy',
    'daily_already_title': 'Ya lo has visto',
    'daily_already_body': 'Vuelve después de medianoche para la próxima revelación del cuaderno de Henrietta.',
    'daily_streak': 'Racha',
    'daily_days': 'días',
    'daily_reward_xp': '+{xp} PE',
    'codex_title': 'Códice de Plumas',
    'codex_subtitle': '{unlocked} de {total} desbloqueados',
    'codex_locked': 'Bloqueado — lee capítulos para desbloquear',
    'codex_category_biology': 'Biología',
    'codex_category_history': 'Historia',
    'codex_category_behavior': 'Comportamiento',
    'codex_category_genetics': 'Genética',
    'codex_category_folklore': 'Folclore',
    'trophies_title': 'Corral de Trofeos',
    'trophies_subtitle': 'Hitos de tu viaje con Henrietta.',
    'trophies_locked': 'Bloqueado',
    'trophies_unlocked': 'Desbloqueado',
    'trophies_progress': '{current} / {goal}',
    'rarity_common': 'Común',
    'rarity_rare': 'Raro',
    'rarity_epic': 'Épico',
    'rarity_legendary': 'Legendario',
    'settings_title': 'Ajustes',
    'settings_language': 'Idioma',
    'settings_language_hint': 'La historia está escrita en inglés. La interfaz está traducida.',
    'settings_reset': 'Reiniciar progreso',
    'settings_reset_hint': 'Borra PE, rachas y datos desbloqueados.',
    'settings_reset_confirm': '¿Reiniciar todo?',
    'settings_reset_confirm_body': 'Esta acción no se puede deshacer.',
    'settings_reset_confirm_yes': 'Sí, reiniciar',
    'settings_reset_confirm_no': 'Cancelar',
    'settings_about': 'Acerca de',
    'settings_about_body': 'Orígenes con Plumas es un libro ilustrado de divulgación sobre 150 millones de años de la humilde gallina.',
    'settings_version': 'Versión 1.0.0',
    'boot_hint': 'Preparando la línea del tiempo...',
  };

  // === French =============================================================

  static const Map<String, String> _fr = <String, String>{
    'app_title': 'Egg Runner Adventure',
    'app_tagline': 'L\'histoire illustrée de l\'évolution de la poule',
    'author_line': 'Raconté par Henrietta Rex, troisième du nom',
    'menu_home': 'Accueil',
    'menu_chapters': 'Chroniques',
    'menu_daily': 'Fait du jour',
    'menu_facts': 'Codex',
    'menu_trophies': 'Trophées',
    'menu_settings': 'Réglages',
    'home_greeting': 'Salut, je suis Henrietta.',
    'home_intro': 'Une poule moderne avec 150 millions d\'années d\'histoire familiale. Prêt·e à voyager dans le temps ?',
    'home_cta_chapters': 'Lire les Chroniques',
    'home_cta_daily': 'Découvrir le fait du jour',
    'home_cta_daily_done': 'Revenez demain',
    'home_progress_reader': 'Progression',
    'home_progress_codex': 'Codex débloqué',
    'home_progress_level': 'Rang',
    'home_progress_xp': 'XP',
    'home_streak': 'Série',
    'home_next_reward_in': 'Récompense disponible aujourd\'hui',
    'rank_chick': 'Poussin Curieux',
    'rank_pullet': 'Poulette Exploratrice',
    'rank_hen': 'Poule Sage',
    'rank_rooster': 'Coq Historien',
    'rank_legend': 'Ancienne Légendaire',
    'chapters_title': 'Les Chroniques',
    'chapters_subtitle': 'Onze ères qui ont fait ce que je suis.',
    'chapters_page_of': 'Page {current} sur {total}',
    'chapters_read': 'Lu',
    'chapters_unread': 'Non lu',
    'chapters_start': 'Lire',
    'chapters_reread': 'Relire',
    'loading': 'Chargement',
    'chapters_next': 'Suivant',
    'chapters_prev': 'Précédent',
    'chapters_finish': 'Terminer',
    'chapters_reward_title': 'Chapitre débloqué !',
    'chapters_reward_xp': 'Vous gagnez {xp} XP.',
    'chapters_reward_close': 'Continuer',
    'daily_title': 'Fait du jour',
    'daily_subtitle': 'Une découverte par jour.',
    'daily_claim': 'Révéler le fait',
    'daily_already_title': 'Déjà vu aujourd\'hui',
    'daily_already_body': 'Revenez après minuit pour la prochaine page du carnet d\'Henrietta.',
    'daily_streak': 'Série',
    'daily_days': 'jours',
    'daily_reward_xp': '+{xp} XP',
    'codex_title': 'Codex Plumes',
    'codex_subtitle': '{unlocked} / {total} débloqués',
    'codex_locked': 'Verrouillé — lisez des chapitres',
    'codex_category_biology': 'Biologie',
    'codex_category_history': 'Histoire',
    'codex_category_behavior': 'Comportement',
    'codex_category_genetics': 'Génétique',
    'codex_category_folklore': 'Folklore',
    'trophies_title': 'Poulailler des Trophées',
    'trophies_subtitle': 'Étapes de votre aventure.',
    'trophies_locked': 'Verrouillé',
    'trophies_unlocked': 'Débloqué',
    'trophies_progress': '{current} / {goal}',
    'rarity_common': 'Commun',
    'rarity_rare': 'Rare',
    'rarity_epic': 'Épique',
    'rarity_legendary': 'Légendaire',
    'settings_title': 'Réglages',
    'settings_language': 'Langue',
    'settings_language_hint': 'L\'histoire est en anglais. L\'interface est traduite.',
    'settings_reset': 'Réinitialiser',
    'settings_reset_hint': 'Efface XP, séries et faits débloqués.',
    'settings_reset_confirm': 'Tout réinitialiser ?',
    'settings_reset_confirm_body': 'Action irréversible.',
    'settings_reset_confirm_yes': 'Oui',
    'settings_reset_confirm_no': 'Annuler',
    'settings_about': 'À propos',
    'settings_about_body': 'Origines à Plumes est un livre illustré sur 150 millions d\'années d\'évolution.',
    'settings_version': 'Version 1.0.0',
    'boot_hint': 'Préparation de la chronologie...',
  };

  // === German =============================================================

  static const Map<String, String> _de = <String, String>{
    'app_title': 'Egg Runner Adventure',
    'app_tagline': 'Die illustrierte Geschichte der Huhn-Evolution',
    'author_line': 'Erzählt von Henrietta Rex, der Dritten ihres Namens',
    'menu_home': 'Start',
    'menu_chapters': 'Chroniken',
    'menu_daily': 'Tagesfakt',
    'menu_facts': 'Codex',
    'menu_trophies': 'Trophäen',
    'menu_settings': 'Einstellungen',
    'home_greeting': 'Hallo, ich bin Henrietta.',
    'home_intro': 'Eine moderne Henne mit 150 Millionen Jahren Familiengeschichte. Reisen wir gemeinsam durch die Zeit?',
    'home_cta_chapters': 'Chroniken lesen',
    'home_cta_daily': 'Heutigen Fakt anzeigen',
    'home_cta_daily_done': 'Komm morgen wieder',
    'home_progress_reader': 'Lesefortschritt',
    'home_progress_codex': 'Codex freigeschaltet',
    'home_progress_level': 'Rang',
    'home_progress_xp': 'XP',
    'home_streak': 'Tages-Streak',
    'home_next_reward_in': 'Belohnung heute verfügbar',
    'rank_chick': 'Neugieriges Küken',
    'rank_pullet': 'Junghenne',
    'rank_hen': 'Weise Henne',
    'rank_rooster': 'Historiker-Hahn',
    'rank_legend': 'Legendäre Älteste',
    'chapters_title': 'Die Chroniken',
    'chapters_subtitle': 'Elf Epochen, die mich geformt haben.',
    'chapters_page_of': 'Seite {current} von {total}',
    'chapters_read': 'Gelesen',
    'chapters_unread': 'Ungelesen',
    'chapters_start': 'Start',
    'chapters_reread': 'Erneut lesen',
    'loading': 'Laden',
    'chapters_next': 'Weiter',
    'chapters_prev': 'Zurück',
    'chapters_finish': 'Abschließen',
    'chapters_reward_title': 'Kapitel abgeschlossen!',
    'chapters_reward_xp': 'Du erhältst {xp} XP.',
    'chapters_reward_close': 'Weiter',
    'daily_title': 'Tagesfakt',
    'daily_subtitle': 'Jeden Tag eine neue Entdeckung.',
    'daily_claim': 'Heutigen Fakt enthüllen',
    'daily_already_title': 'Heute schon erhalten',
    'daily_already_body': 'Nach Mitternacht wartet die nächste Seite in Henriettas Notizbuch.',
    'daily_streak': 'Streak',
    'daily_days': 'Tage',
    'daily_reward_xp': '+{xp} XP',
    'codex_title': 'Federn-Codex',
    'codex_subtitle': '{unlocked} von {total} freigeschaltet',
    'codex_locked': 'Gesperrt — Kapitel lesen',
    'codex_category_biology': 'Biologie',
    'codex_category_history': 'Geschichte',
    'codex_category_behavior': 'Verhalten',
    'codex_category_genetics': 'Genetik',
    'codex_category_folklore': 'Folklore',
    'trophies_title': 'Trophäen-Stall',
    'trophies_subtitle': 'Meilensteine auf deiner Reise.',
    'trophies_locked': 'Gesperrt',
    'trophies_unlocked': 'Erhalten',
    'trophies_progress': '{current} / {goal}',
    'rarity_common': 'Gewöhnlich',
    'rarity_rare': 'Selten',
    'rarity_epic': 'Episch',
    'rarity_legendary': 'Legendär',
    'settings_title': 'Einstellungen',
    'settings_language': 'Sprache',
    'settings_language_hint': 'Die Geschichte ist auf Englisch. Die Oberfläche ist übersetzt.',
    'settings_reset': 'Zurücksetzen',
    'settings_reset_hint': 'Löscht XP, Streaks und Fakten.',
    'settings_reset_confirm': 'Alles zurücksetzen?',
    'settings_reset_confirm_body': 'Diese Aktion ist unumkehrbar.',
    'settings_reset_confirm_yes': 'Ja',
    'settings_reset_confirm_no': 'Abbrechen',
    'settings_about': 'Über',
    'settings_about_body': 'Gefiederte Ursprünge ist ein illustriertes Sachbuch über 150 Millionen Jahre Hühnergeschichte.',
    'settings_version': 'Version 1.0.0',
    'boot_hint': 'Zeitleiste wird vorbereitet...',
  };

  // === Portuguese =========================================================

  static const Map<String, String> _pt = <String, String>{
    'app_title': 'Egg Runner Adventure',
    'app_tagline': 'A história ilustrada da evolução da galinha',
    'author_line': 'Narrado por Henrietta Rex, a terceira do seu nome',
    'menu_home': 'Início',
    'menu_chapters': 'Crônicas',
    'menu_daily': 'Fato do dia',
    'menu_facts': 'Códice',
    'menu_trophies': 'Troféus',
    'menu_settings': 'Ajustes',
    'home_greeting': 'Oi, sou a Henrietta.',
    'home_intro': 'Uma galinha moderna com 150 milhões de anos de história familiar. Pronto para viajar comigo?',
    'home_cta_chapters': 'Ler as Crônicas',
    'home_cta_daily': 'Descobrir o fato do dia',
    'home_cta_daily_done': 'Volte amanhã',
    'home_progress_reader': 'Progresso',
    'home_progress_codex': 'Códice liberado',
    'home_progress_level': 'Posto',
    'home_progress_xp': 'XP',
    'home_streak': 'Sequência',
    'home_next_reward_in': 'Recompensa disponível hoje',
    'rank_chick': 'Pintinho Curioso',
    'rank_pullet': 'Franga Exploradora',
    'rank_hen': 'Galinha Sábia',
    'rank_rooster': 'Galo Historiador',
    'rank_legend': 'Anciã Lendária',
    'chapters_title': 'As Crônicas',
    'chapters_subtitle': 'Onze eras que me tornaram quem sou.',
    'chapters_page_of': 'Página {current} de {total}',
    'chapters_read': 'Lido',
    'chapters_unread': 'Não lido',
    'chapters_start': 'Começar',
    'chapters_reread': 'Reler',
    'loading': 'Carregando',
    'chapters_next': 'Próxima',
    'chapters_prev': 'Anterior',
    'chapters_finish': 'Terminar',
    'chapters_reward_title': 'Capítulo desbloqueado!',
    'chapters_reward_xp': 'Você ganhou {xp} XP.',
    'chapters_reward_close': 'Continuar',
    'daily_title': 'Fato do dia',
    'daily_subtitle': 'Uma descoberta por dia.',
    'daily_claim': 'Revelar o fato',
    'daily_already_title': 'Já visto hoje',
    'daily_already_body': 'Volte após a meia-noite para a próxima página do caderno da Henrietta.',
    'daily_streak': 'Sequência',
    'daily_days': 'dias',
    'daily_reward_xp': '+{xp} XP',
    'codex_title': 'Códice das Penas',
    'codex_subtitle': '{unlocked} de {total} desbloqueados',
    'codex_locked': 'Bloqueado — leia capítulos',
    'codex_category_biology': 'Biologia',
    'codex_category_history': 'História',
    'codex_category_behavior': 'Comportamento',
    'codex_category_genetics': 'Genética',
    'codex_category_folklore': 'Folclore',
    'trophies_title': 'Galinheiro dos Troféus',
    'trophies_subtitle': 'Marcos da sua jornada.',
    'trophies_locked': 'Bloqueado',
    'trophies_unlocked': 'Desbloqueado',
    'trophies_progress': '{current} / {goal}',
    'rarity_common': 'Comum',
    'rarity_rare': 'Raro',
    'rarity_epic': 'Épico',
    'rarity_legendary': 'Lendário',
    'settings_title': 'Ajustes',
    'settings_language': 'Idioma',
    'settings_language_hint': 'A história está em inglês. A interface é traduzida.',
    'settings_reset': 'Redefinir progresso',
    'settings_reset_hint': 'Apaga XP, sequências e fatos.',
    'settings_reset_confirm': 'Redefinir tudo?',
    'settings_reset_confirm_body': 'Ação irreversível.',
    'settings_reset_confirm_yes': 'Sim',
    'settings_reset_confirm_no': 'Cancelar',
    'settings_about': 'Sobre',
    'settings_about_body': 'Origens Emplumadas é um livro ilustrado sobre 150 milhões de anos das galinhas.',
    'settings_version': 'Versão 1.0.0',
    'boot_hint': 'Preparando a linha do tempo...',
  };
}
