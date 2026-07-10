import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/chapters_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/chapter.dart';
import '../widgets/parchment_background.dart';

/// Scrollable, gated list of the illustrated evolutionary chapters.
///
/// Chapters are grouped into Acts of five and unlock strictly in order, so the
/// reader always has a clear "next step" and a visible sense of progression.
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
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
                children: _buildItems(context, l10n, store),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, AppL10n l10n, ProgressStore store) {
    final items = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
        child: Text(
          l10n.t('chapters_subtitle'),
          style: const TextStyle(fontSize: 15, color: AppColors.muted, fontStyle: FontStyle.italic),
        ),
      ),
    ];

    for (var i = 0; i < ChaptersData.chapters.length; i++) {
      if (i % ChaptersData.actSize == 0) {
        final act = i ~/ ChaptersData.actSize;
        items.add(_ActHeader(act: act, l10n: l10n, store: store));
      }
      final chapter = ChaptersData.chapters[i];
      final read = store.readChapters.contains(chapter.id);
      final unlocked = store.isChapterUnlockedAt(i);
      items.add(Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _ChapterCard(
          index: i + 1,
          chapter: chapter,
          read: read,
          unlocked: unlocked,
          l10n: l10n,
        ),
      ));
    }
    return items;
  }
}

class _ActHeader extends StatelessWidget {
  const _ActHeader({required this.act, required this.l10n, required this.store});
  final int act;
  final AppL10n l10n;
  final ProgressStore store;

  @override
  Widget build(BuildContext context) {
    final start = act * ChaptersData.actSize;
    final end = (start + ChaptersData.actSize).clamp(0, ChaptersData.chapters.length);
    var readInAct = 0;
    for (var i = start; i < end; i++) {
      if (store.readChapters.contains(ChaptersData.chapters[i].id)) readInAct++;
    }
    final total = end - start;
    final label = l10n.t('chapters_act${act + 1}');

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.rust,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.rust.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$readInAct / $total',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.rust),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.index,
    required this.chapter,
    required this.read,
    required this.unlocked,
    required this.l10n,
  });

  final int index;
  final Chapter chapter;
  final bool read;
  final bool unlocked;
  final AppL10n l10n;

  void _onTap(BuildContext context) {
    if (!unlocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.t('chapters_locked'))));
      return;
    }
    Navigator.pushNamed(context, Routes.reader, arguments: chapter.id);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _onTap(context),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: unlocked ? chapter.palette.accent.withValues(alpha: 0.35) : AppColors.divider,
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Banner(index: index, chapter: chapter, read: read, unlocked: unlocked, l10n: l10n),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 13,
                            color: unlocked ? chapter.palette.accent : AppColors.muted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.t(chapter.periodKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: unlocked ? chapter.palette.accent : AppColors.muted,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      unlocked ? l10n.t(chapter.titleKey) : '• • • • •',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: unlocked ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unlocked ? l10n.t(chapter.subtitleKey) : l10n.t('chapters_locked'),
                      style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (unlocked ? chapter.palette.accent : AppColors.muted).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 13,
                                  color: unlocked ? chapter.palette.accent : AppColors.muted),
                              const SizedBox(width: 4),
                              Text('+${chapter.xpReward} XP',
                                  style: TextStyle(
                                      color: unlocked ? chapter.palette.accent : AppColors.muted,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _ActionPill(chapter: chapter, read: read, unlocked: unlocked, l10n: l10n),
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

class _Banner extends StatelessWidget {
  const _Banner({
    required this.index,
    required this.chapter,
    required this.read,
    required this.unlocked,
    required this.l10n,
  });

  final int index;
  final Chapter chapter;
  final bool read;
  final bool unlocked;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      chapter.image,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: chapter.palette.bottom),
    );
    if (!unlocked) {
      // Desaturate + dim locked chapters to keep them mysterious.
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: image,
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
          child: AspectRatio(aspectRatio: 16 / 9, child: image),
        ),
        if (!unlocked)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
          ),
        // Number / lock badge.
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(colors: [chapter.palette.accent, chapter.palette.bottom])
                  : const LinearGradient(colors: [AppColors.muted, Color(0xFF9A8B7A)]),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.4),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6)],
            ),
            alignment: Alignment.center,
            child: unlocked
                ? Text('$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14))
                : const Icon(Icons.lock_rounded, color: Colors.white, size: 16),
          ),
        ),
        if (read)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.meadow,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6)],
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
        if (!unlocked)
          const Positioned.fill(
            child: Center(
              child: Icon(Icons.lock_rounded, color: Colors.white, size: 40),
            ),
          ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.chapter,
    required this.read,
    required this.unlocked,
    required this.l10n,
  });

  final Chapter chapter;
  final bool read;
  final bool unlocked;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    if (!unlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, size: 13, color: AppColors.muted),
            const SizedBox(width: 4),
            Text(l10n.t('chapters_locked_short'),
                style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800, fontSize: 12)),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: chapter.palette.accent, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(read ? l10n.t('chapters_reread') : l10n.t('chapters_start'),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
        ],
      ),
    );
  }
}
