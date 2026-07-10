import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/chapters_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/chapter.dart';
import '../widgets/parchment_background.dart';

/// Vertical timeline of the eleven evolutionary chapters. Each row is a
/// mini-card with era colours, subtitle and a "read" ribbon when finished.
class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('chapters_title'))),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                itemCount: ChaptersData.chapters.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Text(
                        l10n.t('chapters_subtitle'),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }
                  final chapter = ChaptersData.chapters[i - 1];
                  final isRead = store.readChapters.contains(chapter.id);
                  return _ChapterRow(
                    index: i,
                    chapter: chapter,
                    read: isRead,
                    l10n: l10n,
                    isLast: i == ChaptersData.chapters.length,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.index,
    required this.chapter,
    required this.read,
    required this.l10n,
    required this.isLast,
  });

  final int index;
  final Chapter chapter;
  final bool read;
  final AppL10n l10n;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _TimelineDot(active: read, palette: chapter.palette, index: index),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: read
                        ? chapter.palette.accent.withValues(alpha: 0.5)
                        : AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ChapterCard(chapter: chapter, read: read, l10n: l10n),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.active, required this.palette, required this.index});
  final bool active;
  final ChapterPalette palette;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [palette.accent, palette.bottom],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: palette.accent.withValues(alpha: 0.35), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: active
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : Text('$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.read, required this.l10n});
  final Chapter chapter;
  final bool read;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, Routes.reader, arguments: chapter.id),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: chapter.palette.accent.withValues(alpha: 0.35), width: 1.4),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: chapter.palette.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.t(chapter.periodKey),
                      style: TextStyle(
                        fontSize: 11,
                        color: chapter.palette.accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (read)
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.meadow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          l10n.t('chapters_read'),
                          style: const TextStyle(color: AppColors.meadow, fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Icon(Icons.circle_outlined, color: AppColors.muted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          l10n.t('chapters_unread'),
                          style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.t(chapter.titleKey),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.t(chapter.subtitleKey),
                style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 14, color: chapter.palette.accent),
                  const SizedBox(width: 4),
                  Text(
                    '+${chapter.xpReward} XP',
                    style: TextStyle(color: chapter.palette.accent, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: chapter.palette.accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
