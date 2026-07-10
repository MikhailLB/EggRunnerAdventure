import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/chapters_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../widgets/parchment_background.dart';
import '../widgets/xp_gauge.dart';

/// Home hub: branding, a warm greeting from Henrietta, a "continue reading"
/// hook and a clean list of the four content modes. Mode taps switch the
/// bottom-nav tab via [onSelectTab].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onSelectTab});

  final void Function(int index)? onSelectTab;

  void _go(int index) => onSelectTab?.call(index);

  void _continueReading(BuildContext context) {
    final store = ProgressStore.instance;
    final idx = store.nextChapterIndex.clamp(0, ChaptersData.chapters.length - 1);
    Navigator.pushNamed(context, Routes.reader, arguments: ChaptersData.chapters[idx].id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      body: ParchmentBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
                children: [
                  _TopBar(l10n: l10n),
                  const SizedBox(height: 8),
                  _HeroCard(l10n: l10n, store: store, onContinue: () => _continueReading(context)),
                  const SizedBox(height: 14),
                  const XpGauge(),
                  const SizedBox(height: 20),
                  Text(
                    l10n.t('home_explore').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ModeCard(
                    icon: Icons.auto_stories_rounded,
                    color: AppColors.rust,
                    titleKey: 'menu_chapters',
                    subKey: 'menu_chapters_sub',
                    trailing: _CountChip(text: '${store.readChapters.length}/${store.totalChapters}', color: AppColors.rust),
                    onTap: () => _go(1),
                  ),
                  const SizedBox(height: 12),
                  _ModeCard(
                    icon: Icons.wb_sunny_rounded,
                    color: AppColors.sunrise,
                    titleKey: 'menu_daily',
                    subKey: 'menu_daily_sub',
                    trailing: store.canClaimDaily
                        ? _DotChip(color: AppColors.rust, label: '1')
                        : const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                    onTap: () => _go(2),
                  ),
                  const SizedBox(height: 12),
                  _ModeCard(
                    icon: Icons.menu_book_rounded,
                    color: AppColors.meadow,
                    titleKey: 'menu_facts',
                    subKey: 'menu_facts_sub',
                    trailing: _CountChip(text: '${store.unlockedFacts.length}/${store.totalFacts}', color: AppColors.meadow),
                    onTap: () => _go(3),
                  ),
                  const SizedBox(height: 12),
                  _ModeCard(
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.sky,
                    titleKey: 'menu_trophies',
                    subKey: 'menu_trophies_sub',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                    onTap: () => _go(4),
                  ),
                  const SizedBox(height: 20),
                  _AuthorFootnote(l10n: l10n),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.l10n});
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _HomeTitle()),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, Routes.settings),
          icon: const Icon(Icons.settings_rounded, size: 26, color: AppColors.ink),
          tooltip: l10n.t('menu_settings'),
        ),
      ],
    );
  }
}

class _HomeTitle extends StatelessWidget {
  const _HomeTitle();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Egg Runner ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF6E3A1D),
              letterSpacing: 0.2,
            ),
          ),
          TextSpan(
            text: 'Adventure',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFFE8612A),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.l10n, required this.store, required this.onContinue});
  final AppL10n l10n;
  final ProgressStore store;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE7A8), Color(0xFFFFC46B), Color(0xFFFF9F5A)],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.rust.withValues(alpha: 0.22), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 10, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.t('home_greeting'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.t('home_intro'),
                  style: const TextStyle(color: AppColors.ink, fontSize: 13.5, height: 1.35),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onContinue,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.t('home_continue'), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppColors.rust, size: 18),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${store.dailyStreak} ${l10n.t('home_streak')}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Mascot(),
        ],
      ),
    );
  }
}

class _Mascot extends StatelessWidget {
  const _Mascot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 150,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Soft ground shadow so the cut-out mascot feels grounded.
          Positioned(
            bottom: 6,
            child: Container(
              width: 92,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.rust.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Image.asset(
            'assets/mascot/henrietta.png',
            width: 140,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(Icons.egg_rounded, size: 90, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.color,
    required this.titleKey,
    required this.subKey,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String titleKey;
  final String subKey;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t(titleKey),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.t(subKey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class _DotChip extends StatelessWidget {
  const _DotChip({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)],
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

class _AuthorFootnote extends StatelessWidget {
  const _AuthorFootnote({required this.l10n});
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded, color: AppColors.rust, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.t('author_line'),
              style: const TextStyle(color: AppColors.muted, fontStyle: FontStyle.italic, fontSize: 13.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
