import 'dart:io';

import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/progress_store.dart';

/// Circular avatar for the reader profile. Renders (in priority order):
///   1. the user-picked photo (from camera or gallery), if the file exists;
///   2. the initial of the reader's name over a warm gradient;
///   3. a generic person icon as final fallback.
///
/// Rebuilds whenever [ProgressStore] notifies, so tapping the source once
/// updates every place the avatar is shown.
class ReaderAvatar extends StatelessWidget {
  const ReaderAvatar({
    super.key,
    this.size = 44,
    this.showEditBadge = false,
    this.onTap,
    this.borderColor,
    this.borderWidth = 0,
  });

  final double size;
  final bool showEditBadge;
  final VoidCallback? onTap;

  /// Optional outer ring color. Defaults to no ring so the picked photo
  /// fills the entire circle instead of being cropped by an inner border.
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => _build(context, store),
    );
  }

  Widget _build(BuildContext context, ProgressStore store) {
    final path = store.readerAvatarPath;
    final hasFile = path != null && path.isNotEmpty && File(path).existsSync();

    // The photo (or gradient placeholder) is drawn inside a ClipOval so the
    // image fills the circle edge-to-edge. Any optional ring is drawn *on top*
    // as an overlay — that way we never eat into the visible photo area.
    final Widget inner = SizedBox(
      width: size,
      height: size,
      child: hasFile
          ? Image.file(
              File(path),
              width: size,
              height: size,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _gradientFallback(store),
            )
          : _gradientFallback(store),
    );

    final Widget content = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipOval(child: inner),
            if (borderColor != null && borderWidth > 0)
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor!,
                      width: borderWidth,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final Widget avatar = showEditBadge
        ? SizedBox(
            width: size,
            height: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: content),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: size * 0.36,
                    height: size * 0.36,
                    decoration: BoxDecoration(
                      color: AppColors.rust,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.parchment, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: size * 0.20,
                    ),
                  ),
                ),
              ],
            ),
          )
        : content;

    if (onTap == null) return avatar;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: avatar,
      ),
    );
  }

  Widget _gradientFallback(ProgressStore store) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFC46B), Color(0xFFE8612A)],
        ),
      ),
      child: Center(child: _fallbackGlyph(store)),
    );
  }

  Widget _fallbackGlyph(ProgressStore store) {
    final name = store.readerName?.trim();
    if (name != null && name.isNotEmpty) {
      return Text(
        String.fromCharCode(name.runes.first).toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.42,
        ),
      );
    }
    return Icon(
      Icons.person_rounded,
      color: Colors.white,
      size: size * 0.55,
    );
  }
}
