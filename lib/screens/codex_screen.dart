import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/facts_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/fact.dart';
import '../widgets/parchment_background.dart';

/// Grid of collectible facts. Unlocked cards flip open on tap; locked ones
/// show only the category and a hint.
class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('codex_title')),
        automaticallyImplyLeading: !embedded,
      ),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        tint: AppColors.meadow,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 8),
                      child: Text(
                        l10n.t('codex_subtitle', {
                          'unlocked': store.unlockedFacts.length.toString(),
                          'total': store.totalFacts.toString(),
                        }),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.muted, fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _ProgressStrip(percent: store.codexProgress)),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.86,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final fact = FactsData.facts[index];
                          final unlocked = store.unlockedFacts.contains(fact.id);
                          return _FactCard(fact: fact, unlocked: unlocked, l10n: l10n);
                        },
                        childCount: FactsData.count,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation(AppColors.meadow),
            ),
          ),
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact, required this.unlocked, required this.l10n});
  final ChickenFact fact;
  final bool unlocked;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: unlocked ? () => _showDetail(context) : null,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: unlocked ? AppColors.card : AppColors.card.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: unlocked ? _categoryColor(fact.category).withValues(alpha: 0.6) : AppColors.divider, width: 1.4),
            boxShadow: unlocked
                ? [
                    BoxShadow(
                      color: _categoryColor(fact.category).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (unlocked ? _categoryColor(fact.category) : AppColors.divider).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: unlocked
                    ? Text(fact.emoji, style: const TextStyle(fontSize: 28))
                    : const Icon(Icons.lock_rounded, color: AppColors.muted),
              ),
              const Spacer(),
              Text(
                unlocked ? l10n.t(fact.titleKey) : l10n.t('codex_locked'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: unlocked ? AppColors.ink : AppColors.muted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _categoryLabel(fact.category, l10n),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: unlocked ? _categoryColor(fact.category) : AppColors.muted,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: _categoryColor(fact.category).withValues(alpha: 0.2), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(fact.emoji, style: const TextStyle(fontSize: 46)),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.t(fact.titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.t(fact.bodyKey),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.ink, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _categoryColor(fact.category).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _categoryLabel(fact.category, l10n),
                style: TextStyle(color: _categoryColor(fact.category), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(FactCategory c) {
    switch (c) {
      case FactCategory.biology:
        return AppColors.meadow;
      case FactCategory.history:
        return AppColors.sky;
      case FactCategory.behavior:
        return AppColors.sunrise;
      case FactCategory.genetics:
        return AppColors.rust;
      case FactCategory.folklore:
        return const Color(0xFF9C6BC7);
    }
  }

  String _categoryLabel(FactCategory c, AppL10n l10n) {
    switch (c) {
      case FactCategory.biology:
        return l10n.t('codex_category_biology').toUpperCase();
      case FactCategory.history:
        return l10n.t('codex_category_history').toUpperCase();
      case FactCategory.behavior:
        return l10n.t('codex_category_behavior').toUpperCase();
      case FactCategory.genetics:
        return l10n.t('codex_category_genetics').toUpperCase();
      case FactCategory.folklore:
        return l10n.t('codex_category_folklore').toUpperCase();
    }
  }
}
