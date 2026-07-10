import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/chapters_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/chapter.dart';
import '../widgets/parchment_background.dart';

/// Scrollable list of the eleven illustrated evolutionary chapters. Each row
/// is a rich card showing the chapter's illustration, era, title and reward.
class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key, this.embedded = false});

  /// When embedded in the bottom-nav shell we drop the AppBar back button.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('chapters_title')),
        automaticallyImplyLeading: !embedded,
      ),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
                itemCount: ChaptersData.chapters.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 16),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ChapterCard(index: i, chapter: chapter, read: isRead, l10n: l10n),
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

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.index,
    required this.chapter,
    required this.read,
    required this.l10n,
  });

  final int index;
  final Chapter chapter;
  final bool read;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.pushNamed(context, Routes.reader, arguments: chapter.id),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: chapter.palette.accent.withValues(alpha: 0.35), width: 1.4),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration banner.
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        chapter.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: chapter.palette.bottom),
                      ),
                    ),
                  ),
                  // Number badge.
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [chapter.palette.accent, chapter.palette.bottom]),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text('$index',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                  ),
                  // Read ribbon.
                  if (read)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.meadow,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 3),
                            Text(l10n.t('chapters_read'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 13, color: chapter.palette.accent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.t(chapter.periodKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: chapter.palette.accent,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.t(chapter.titleKey),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.ink),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.t(chapter.subtitleKey),
                      style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: chapter.palette.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 13, color: chapter.palette.accent),
                              const SizedBox(width: 4),
                              Text('+${chapter.xpReward} XP',
                                  style: TextStyle(color: chapter.palette.accent, fontWeight: FontWeight.w800, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: chapter.palette.accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                read ? l10n.t('chapters_reread') : l10n.t('chapters_start'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
