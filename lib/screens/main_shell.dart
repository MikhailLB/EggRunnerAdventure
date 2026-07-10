import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import 'chapters_screen.dart';
import 'codex_screen.dart';
import 'daily_reward_screen.dart';
import 'home_screen.dart';
import 'trophies_screen.dart';

/// Persistent bottom-navigation shell. Hosts the five primary destinations
/// in an [IndexedStack] so each keeps its scroll position and state while the
/// user hops between tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  void _select(int i) {
    if (_index == i) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    final pages = <Widget>[
      HomeScreen(onSelectTab: _select),
      const ChaptersScreen(embedded: true),
      const DailyRewardScreen(embedded: true),
      const CodexScreen(embedded: true),
      const TrophiesScreen(embedded: true),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, -2)),
              ],
              border: const Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: l10n.t('menu_home'),
                      selected: _index == 0,
                      onTap: () => _select(0),
                    ),
                    _NavItem(
                      icon: Icons.auto_stories_rounded,
                      label: l10n.t('menu_chapters'),
                      selected: _index == 1,
                      onTap: () => _select(1),
                    ),
                    _NavItem(
                      icon: Icons.wb_sunny_rounded,
                      label: l10n.t('menu_daily'),
                      selected: _index == 2,
                      badge: store.canClaimDaily,
                      onTap: () => _select(2),
                    ),
                    _NavItem(
                      icon: Icons.menu_book_rounded,
                      label: l10n.t('menu_facts'),
                      selected: _index == 3,
                      onTap: () => _select(3),
                    ),
                    _NavItem(
                      icon: Icons.emoji_events_rounded,
                      label: l10n.t('menu_trophies'),
                      selected: _index == 4,
                      onTap: () => _select(4),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.rust : AppColors.muted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.rust.withValues(alpha: 0.14) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (badge)
                    Positioned(
                      top: -2,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.rust,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.card, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
