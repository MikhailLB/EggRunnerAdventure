import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Henrietta as a friendly, code-drawn mascot. Optional gentle bob animation
/// keeps her feeling alive on the home screen.
class HenriettaAvatar extends StatefulWidget {
  const HenriettaAvatar({super.key, this.size = 130, this.animate = true});

  final double size;
  final bool animate;

  @override
  State<HenriettaAvatar> createState() => _HenriettaAvatarState();
}

class _HenriettaAvatarState extends State<HenriettaAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
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
      builder: (context, _) {
        final t = widget.animate ? _ctrl.value : 0.0;
        final dy = math.sin(t * math.pi * 2) * 3;
        return Transform.translate(
          offset: Offset(0, dy),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(painter: _HenriettaPainter()),
          ),
        );
      },
    );
  }
}

class _HenriettaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Warm halo.
    final halo = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.yolk.withValues(alpha: 0.55), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w * 0.55));
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.55, halo);

    // Body.
    final body = Path()
      ..moveTo(w * 0.20, h * 0.72)
      ..cubicTo(w * 0.05, h * 0.55, w * 0.15, h * 0.30, w * 0.42, h * 0.28)
      ..cubicTo(w * 0.75, h * 0.28, w * 0.95, h * 0.55, w * 0.85, h * 0.78)
      ..cubicTo(w * 0.75, h * 0.95, w * 0.35, h * 0.98, w * 0.20, h * 0.72)
      ..close();
    canvas.drawPath(body, Paint()..color = Colors.white);
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.ink.withValues(alpha: 0.6),
    );

    // Wing.
    final wing = Path()
      ..moveTo(w * 0.55, h * 0.55)
      ..cubicTo(w * 0.72, h * 0.55, w * 0.80, h * 0.65, w * 0.72, h * 0.80)
      ..cubicTo(w * 0.60, h * 0.78, w * 0.50, h * 0.70, w * 0.55, h * 0.55)
      ..close();
    canvas.drawPath(wing, Paint()..color = AppColors.parchment);
    canvas.drawPath(
      wing,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.ink.withValues(alpha: 0.5),
    );

    // Comb on head.
    final comb = Path()
      ..moveTo(w * 0.40, h * 0.27)
      ..arcToPoint(Offset(w * 0.48, h * 0.18), radius: const Radius.circular(10))
      ..arcToPoint(Offset(w * 0.56, h * 0.27), radius: const Radius.circular(10))
      ..close();
    canvas.drawPath(comb, Paint()..color = AppColors.rust);
    final comb2 = Path()
      ..moveTo(w * 0.52, h * 0.25)
      ..arcToPoint(Offset(w * 0.60, h * 0.18), radius: const Radius.circular(10))
      ..arcToPoint(Offset(w * 0.66, h * 0.28), radius: const Radius.circular(10))
      ..close();
    canvas.drawPath(comb2, Paint()..color = AppColors.rust);

    // Eye.
    canvas.drawCircle(Offset(w * 0.36, h * 0.42), 5, Paint()..color = AppColors.ink);
    canvas.drawCircle(Offset(w * 0.34, h * 0.40), 1.6, Paint()..color = Colors.white);

    // Cheek blush.
    canvas.drawCircle(
      Offset(w * 0.30, h * 0.55),
      6,
      Paint()..color = AppColors.rust.withValues(alpha: 0.35),
    );

    // Beak.
    final beak = Path()
      ..moveTo(w * 0.24, h * 0.48)
      ..lineTo(w * 0.12, h * 0.52)
      ..lineTo(w * 0.24, h * 0.56)
      ..close();
    canvas.drawPath(beak, Paint()..color = AppColors.sunrise);
    canvas.drawPath(
      beak,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.ink,
    );

    // Feet.
    final foot = Paint()
      ..color = AppColors.sunrise
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.40, h * 0.92), Offset(w * 0.35, h * 0.99), foot);
    canvas.drawLine(Offset(w * 0.40, h * 0.92), Offset(w * 0.42, h * 0.99), foot);
    canvas.drawLine(Offset(w * 0.62, h * 0.92), Offset(w * 0.58, h * 0.99), foot);
    canvas.drawLine(Offset(w * 0.62, h * 0.92), Offset(w * 0.66, h * 0.99), foot);

    // Wattle.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.30, h * 0.60), width: 10, height: 14),
      Paint()..color = AppColors.rust.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
