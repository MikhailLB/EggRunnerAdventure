import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Subtle, painter-drawn parchment texture with tiny drifting feathers.
/// Used behind every regular screen so the app feels like an old book.
class ParchmentBackground extends StatefulWidget {
  const ParchmentBackground({super.key, required this.child, this.tint});

  final Widget child;
  final Color? tint;

  @override
  State<ParchmentBackground> createState() => _ParchmentBackgroundState();
}

class _ParchmentBackgroundState extends State<ParchmentBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.tint?.withValues(alpha: 0.20) ?? AppColors.parchment,
                  AppColors.parchment,
                ],
              ),
            ),
          ),
          CustomPaint(painter: _FeatherPainter(_ctrl.value), size: Size.infinite),
          child!,
        ],
      ),
      child: widget.child,
    );
  }
}

class _FeatherPainter extends CustomPainter {
  _FeatherPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // A grid of feathers slowly drifting sideways/downwards.
    final rng = math.Random(41);
    final paint = Paint()
      ..color = AppColors.rust.withValues(alpha: 0.06)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 24; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final drift = (t + i * 0.13) % 1.0;
      final x = (baseX + drift * 30) % size.width;
      final y = (baseY + drift * 60) % size.height;

      final len = 24.0 + rng.nextInt(20);
      final angle = -math.pi / 2 + rng.nextDouble() * 0.4;
      final tip = Offset(x + math.cos(angle) * len, y + math.sin(angle) * len);
      canvas.drawLine(Offset(x, y), tip, paint);

      final perpAngle = angle + math.pi / 2;
      for (double s = 0.15; s <= 0.85; s += 0.15) {
        final p = Offset.lerp(Offset(x, y), tip, s)!;
        final barbLen = (len * 0.28) * (1 - (s - 0.5).abs() * 1.4);
        final barbTip1 = p + Offset(math.cos(perpAngle) * barbLen, math.sin(perpAngle) * barbLen);
        final barbTip2 = p - Offset(math.cos(perpAngle) * barbLen, math.sin(perpAngle) * barbLen);
        canvas.drawLine(p, barbTip1, paint);
        canvas.drawLine(p, barbTip2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FeatherPainter old) => old.t != t;
}
