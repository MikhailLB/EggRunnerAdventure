import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/chapters_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/chapter.dart';

/// Immersive page-turn reader for a single chapter.
///
/// The upper part is the chapter's full illustration; the lower part is a
/// scrollable text panel with a page indicator and prev/next controls.
class ChapterReaderScreen extends StatefulWidget {
  const ChapterReaderScreen({super.key, required this.chapterId});

  final String chapterId;

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  bool _completedCelebrated = false;

  late final Chapter chapter = ChaptersData.byId(widget.chapterId);

  @override
  void initState() {
    super.initState();
    ProgressStore.instance.markChapterOpened();
    ProgressStore.instance.startReadingSession();
  }

  @override
  void dispose() {
    ProgressStore.instance.endReadingSession();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < chapter.pageKeys.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _finish() async {
    if (_completedCelebrated) {
      Navigator.pop(context);
      return;
    }
    _completedCelebrated = true;
    ProgressStore.instance.completeChapter(chapter.id);
    await _showRewardSheet();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _showRewardSheet() {
    final l10n = AppL10n.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RewardSheet(
        chapter: chapter,
        title: l10n.t('chapters_reward_title'),
        subtitle: l10n.t('chapters_reward_xp', {
          'xp': chapter.xpReward.toString(),
        }),
        buttonLabel: l10n.t('chapters_reward_close'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final palette = chapter.palette;
    final topInset = MediaQuery.of(context).padding.top;
    // Illustration height scales with the screen but stays within sensible bounds.
    final illoHeight = (MediaQuery.of(context).size.height * 0.34).clamp(
      200.0,
      320.0,
    );

    return Scaffold(
      backgroundColor: palette.top,
      body: Column(
        children: [
          _TopIllustration(
            chapter: chapter,
            height: illoHeight,
            topInset: topInset,
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.parchment,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.t(chapter.periodKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.accent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.t(chapter.titleKey),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.t(chapter.subtitleKey),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageCtrl,
                        itemCount: chapter.pageKeys.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (context, i) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              l10n.t(chapter.pageKeys[i]),
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.55,
                                color: AppColors.ink,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _PageIndicator(
                      current: _currentPage,
                      total: chapter.pageKeys.length,
                      accent: palette.accent,
                      label: l10n.t('chapters_page_of', {
                        'current': (_currentPage + 1).toString(),
                        'total': chapter.pageKeys.length.toString(),
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _currentPage == 0 ? null : _prev,
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                            ),
                            label: Text(
                              l10n.t('chapters_prev'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _next,
                            style: FilledButton.styleFrom(
                              backgroundColor: palette.accent,
                            ),
                            icon: Icon(
                              _currentPage == chapter.pageKeys.length - 1
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                            label: Text(
                              _currentPage == chapter.pageKeys.length - 1
                                  ? l10n.t('chapters_finish')
                                  : l10n.t('chapters_next'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopIllustration extends StatelessWidget {
  const _TopIllustration({
    required this.chapter,
    required this.height,
    required this.topInset,
  });
  final Chapter chapter;
  final double height;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            chapter.image,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: chapter.palette.bottom),
          ),
          // Subtle bottom scrim so the rounded parchment panel blends in.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    chapter.palette.top.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: topInset + 6,
            left: 6,
            child: _RoundIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.ink, size: 22),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.current,
    required this.total,
    required this.accent,
    required this.label,
  });

  final int current;
  final int total;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (i) {
            final active = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 22 : 6,
              decoration: BoxDecoration(
                color: active ? accent : accent.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class _RewardSheet extends StatelessWidget {
  const _RewardSheet({
    required this.chapter,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
  });
  final Chapter chapter;
  final String title;
  final String subtitle;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [chapter.palette.accent, chapter.palette.bottom],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: chapter.palette.accent,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
