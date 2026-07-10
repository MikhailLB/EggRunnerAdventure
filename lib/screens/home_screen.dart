import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../widgets/henrietta_avatar.dart';
import '../widgets/parchment_background.dart';
import '../widgets/xp_gauge.dart';

/// Home hub with a warm greeting, quick stats and tile-based navigation to
/// the four content modes (Chronicles, Daily Fact, Codex, Trophies).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _TopBar(l10n: l10n)),
                  SliverToBoxAdapter(child: _HeroCard(l10n: l10n, store: store)),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: XpGauge(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.98,
                      ),
                      delegate: SliverChildListDelegate([
                        _NavTile(
                          icon: Icons.auto_stories_rounded,
                          titleKey: 'menu_chapters',
                          gradient: const [AppColors.rust, Color(0xFFFF7E5F)],
                          progress: store.readerProgress,
                          progressLabel: '${store.readChapters.length}/${store.totalChapters}',
                          onTap: () => Navigator.pushNamed(context, Routes.chapters),
                        ),
                        _NavTile(
                          icon: Icons.wb_sunny_rounded,
                          titleKey: 'menu_daily',
                          gradient: const [AppColors.sunrise, AppColors.yolk],
                          progress: null,
                          badge: store.canClaimDaily ? '!' : null,
                          badgeColor: AppColors.rust,
                          onTap: () => Navigator.pushNamed(context, Routes.daily),
                        ),
                        _NavTile(
                          icon: Icons.menu_book_rounded,
                          titleKey: 'menu_facts',
                          gradient: const [AppColors.meadow, Color(0xFF89D0AA)],
                          progress: store.codexProgress,
                          progressLabel: '${store.unlockedFacts.length}/${store.totalFacts}',
                          onTap: () => Navigator.pushNamed(context, Routes.codex),
                        ),
                        _NavTile(
                          icon: Icons.emoji_events_rounded,
                          titleKey: 'menu_trophies',
                          gradient: const [AppColors.sky, Color(0xFF7ECBE7)],
                          progress: null,
                          onTap: () => Navigator.pushNamed(context, Routes.trophies),
                        ),
                      ]),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(child: _AuthorFootnote(l10n: l10n)),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.t('app_title'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.t('app_tagline'),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
            icon: const Icon(Icons.settings_rounded, size: 26, color: AppColors.ink),
            tooltip: l10n.t('menu_settings'),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.l10n, required this.store});
  final AppL10n l10n;
  final ProgressStore store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE7A8), Color(0xFFFFC46B), Color(0xFFFF9F5A)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.rust.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('home_greeting'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.t('home_intro'),
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(context, Routes.chapters),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(l10n.t('home_cta_chapters')),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColors.rust, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${store.dailyStreak} ${l10n.t('home_streak')}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const HenriettaAvatar(size: 130),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.titleKey,
    required this.gradient,
    required this.onTap,
    this.progress,
    this.progressLabel,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final String titleKey;
  final List<Color> gradient;
  final double? progress;
  final String? progressLabel;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.t(titleKey),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (progress != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.35),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      progressLabel ?? '',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
              if (badge != null)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: badgeColor ?? Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badge!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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
              style: const TextStyle(
                color: AppColors.muted,
                fontStyle: FontStyle.italic,
                fontSize: 13.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
