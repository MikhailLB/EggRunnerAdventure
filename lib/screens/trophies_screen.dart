import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/achievements_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/achievement.dart';
import '../widgets/parchment_background.dart';
import '../widgets/xp_gauge.dart';

/// List of trophies with rarity ribbons and real-time progress bars.
class TrophiesScreen extends StatelessWidget {
  const TrophiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('trophies_title'))),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        tint: AppColors.sky,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              final achievements = AchievementsData.all();
              final unlocked = achievements.where((a) => a.unlocked).length;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
                children: [
                  Text(
                    l10n.t('trophies_subtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const XpGauge(),
                  const SizedBox(height: 8),
                  _Summary(unlocked: unlocked, total: achievements.length),
                  const SizedBox(height: 10),
                  ...achievements.map((a) => _AchievementRow(a: a, l10n: l10n)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.unlocked, required this.total});
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppColors.sunrise),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$unlocked / $total',
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink),
            ),
          ),
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : unlocked / total,
                minHeight: 8,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.sunrise),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({required this.a, required this.l10n});
  final Achievement a;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _rarityColor(a.rarity).withValues(alpha: 0.55), width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_rarityColor(a.rarity), _rarityColor(a.rarity).withValues(alpha: 0.55)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(a.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.t(a.titleKey),
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink, fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _rarityColor(a.rarity).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.t('rarity_${a.rarity.name}'),
                        style: TextStyle(color: _rarityColor(a.rarity), fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.t(a.descriptionKey),
                  style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: a.percent,
                          minHeight: 8,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(_rarityColor(a.rarity)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.t('trophies_progress', {
                        'current': a.current.toString(),
                        'goal': a.goal.toString(),
                      }),
                      style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _rarityColor(AchievementRarity r) {
    switch (r) {
      case AchievementRarity.common:
        return AppColors.muted;
      case AchievementRarity.rare:
        return AppColors.sky;
      case AchievementRarity.epic:
        return const Color(0xFF9C6BC7);
      case AchievementRarity.legendary:
        return AppColors.rust;
    }
  }
}
