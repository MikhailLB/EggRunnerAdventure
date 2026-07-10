import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';

/// Compact rank + XP gauge shown at the top of Home and Trophies screens.
class XpGauge extends StatelessWidget {
  const XpGauge({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    final l10n = AppL10n.of(context);

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              _LevelBadge(level: store.level),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.t(store.henriettaRankKey),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Text(
                          '${store.xp} ${l10n.t('home_progress_xp')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.rust,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: store.levelProgress,
                        minHeight: 8,
                        backgroundColor: AppColors.divider,
                        valueColor: const AlwaysStoppedAnimation(AppColors.sunrise),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sunrise, AppColors.rust],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.rust.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$level',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }
}
