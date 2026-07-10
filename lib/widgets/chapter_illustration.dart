import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/chapter.dart';

/// Painter-driven illustration for a chapter. Purely code-driven so we ship
/// no external artwork and every era gets a bespoke visual.
class ChapterIllustration extends StatelessWidget {
  const ChapterIllustration({
    super.key,
    required this.chapter,
    this.height = 220,
  });

  final Chapter chapter;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _ChapterPainter(chapter),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ChapterPainter extends CustomPainter {
  _ChapterPainter(this.chapter);

  final Chapter chapter;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    _paintSky(canvas, rect);

    switch (chapter.symbol) {
      case ChapterSymbol.archaeopteryx:
        _paintDinoScene(canvas, size);
      case ChapterSymbol.asteroid:
        _paintAsteroid(canvas, size);
      case ChapterSymbol.fossilFeather:
        _paintFeatherFossil(canvas, size);
      case ChapterSymbol.jungleTree:
        _paintJungle(canvas, size);
      case ChapterSymbol.wheatBundle:
        _paintWheat(canvas, size);
      case ChapterSymbol.laurelWreath:
        _paintLaurel(canvas, size);
      case ChapterSymbol.medievalCoop:
        _paintMedieval(canvas, size);
      case ChapterSymbol.sailingShip:
        _paintShip(canvas, size);
      case ChapterSymbol.gear:
        _paintGear(canvas, size);
      case ChapterSymbol.globe:
        _paintGlobe(canvas, size);
    }
  }

  void _paintSky(Canvas canvas, Rect rect) {
    final grad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [chapter.palette.top, chapter.palette.bottom],
    );
    canvas.drawRect(rect, Paint()..shader = grad.createShader(rect));

    // Soft sun.
    final sun = Paint()..color = Colors.white.withValues(alpha: 0.35);
    canvas.drawCircle(Offset(rect.right - 60, 60), 42, sun);
    canvas.drawCircle(Offset(rect.right - 60, 60), 24, Paint()..color = Colors.white.withValues(alpha: 0.55));

    // Ground.
    final ground = Path()
      ..moveTo(0, rect.height * 0.78)
      ..cubicTo(
        rect.width * 0.3, rect.height * 0.70,
        rect.width * 0.7, rect.height * 0.86,
        rect.width, rect.height * 0.76,
      )
      ..lineTo(rect.width, rect.height)
      ..lineTo(0, rect.height)
      ..close();
    canvas.drawPath(ground, Paint()..color = chapter.palette.ink.withValues(alpha: 0.20));
  }

  void _paintDinoScene(Canvas c, Size s) {
    final accent = chapter.palette.accent;
    final ink = chapter.palette.ink;

    // Silhouette of theropod.
    final body = Path()
      ..moveTo(s.width * 0.35, s.height * 0.62)
      ..quadraticBezierTo(s.width * 0.28, s.height * 0.55, s.width * 0.20, s.height * 0.60)
      ..quadraticBezierTo(s.width * 0.10, s.height * 0.70, s.width * 0.30, s.height * 0.78)
      ..quadraticBezierTo(s.width * 0.42, s.height * 0.80, s.width * 0.55, s.height * 0.72)
      ..quadraticBezierTo(s.width * 0.70, s.height * 0.65, s.width * 0.80, s.height * 0.75)
      ..quadraticBezierTo(s.width * 0.85, s.height * 0.80, s.width * 0.78, s.height * 0.84)
      ..quadraticBezierTo(s.width * 0.60, s.height * 0.90, s.width * 0.42, s.height * 0.86)
      ..quadraticBezierTo(s.width * 0.32, s.height * 0.82, s.width * 0.35, s.height * 0.62)
      ..close();
    c.drawPath(body, Paint()..color = ink.withValues(alpha: 0.65));

    // Head + eye.
    c.drawCircle(Offset(s.width * 0.22, s.height * 0.55), 10, Paint()..color = ink.withValues(alpha: 0.8));
    c.drawCircle(Offset(s.width * 0.20, s.height * 0.53), 2.2, Paint()..color = Colors.white);

    // Feathers along back.
    final feather = Paint()
      ..color = accent
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final x = s.width * (0.30 + i * 0.05);
      final y = s.height * 0.60;
      c.drawLine(Offset(x, y), Offset(x - 6, y - 12), feather);
    }

    // Silhouetted ferns.
    _paintFern(c, Offset(s.width * 0.10, s.height * 0.88), 22, ink);
    _paintFern(c, Offset(s.width * 0.90, s.height * 0.88), 20, ink);
  }

  void _paintFern(Canvas c, Offset base, double size, Color color) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = -3; i <= 3; i++) {
      final angle = -math.pi / 2 + i * 0.28;
      final tip = base + Offset(math.cos(angle) * size, math.sin(angle) * size);
      c.drawLine(base, tip, p);
    }
  }

  void _paintAsteroid(Canvas c, Size s) {
    final ink = chapter.palette.ink;
    final accent = chapter.palette.accent;

    // Trail of light.
    final trail = Paint()
      ..shader = LinearGradient(
        colors: [accent.withValues(alpha: 0.0), Colors.yellow.withValues(alpha: 0.9)],
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));
    final trailPath = Path()
      ..moveTo(s.width * 0.10, s.height * 0.10)
      ..lineTo(s.width * 0.75, s.height * 0.55)
      ..lineTo(s.width * 0.75, s.height * 0.65)
      ..lineTo(s.width * 0.10, s.height * 0.20)
      ..close();
    c.drawPath(trailPath, trail);

    // Asteroid.
    final ast = Offset(s.width * 0.75, s.height * 0.60);
    c.drawCircle(ast, 30, Paint()..color = ink);
    c.drawCircle(Offset(ast.dx - 6, ast.dy - 8), 6, Paint()..color = ink.withValues(alpha: 0.6));
    c.drawCircle(Offset(ast.dx + 8, ast.dy + 6), 4, Paint()..color = ink.withValues(alpha: 0.6));

    // Ash cloud.
    for (int i = 0; i < 8; i++) {
      c.drawCircle(
        Offset(s.width * (0.15 + i * 0.10), s.height * (0.80 + (i.isEven ? 0.03 : -0.03))),
        16 + i.toDouble(),
        Paint()..color = Colors.black.withValues(alpha: 0.25),
      );
    }
  }

  void _paintFeatherFossil(Canvas c, Size s) {
    final ink = chapter.palette.ink;

    // Layered rock.
    for (int i = 0; i < 4; i++) {
      c.drawRect(
        Rect.fromLTWH(0, s.height * (0.55 + i * 0.10), s.width, 8),
        Paint()..color = ink.withValues(alpha: 0.15 + i * 0.08),
      );
    }

    // Feather.
    final center = Offset(s.width / 2, s.height * 0.42);
    final spine = Paint()
      ..color = chapter.palette.accent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    c.drawLine(center - const Offset(0, 60), center + const Offset(0, 60), spine);

    final barb = Paint()
      ..color = chapter.palette.accent.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (double t = -55; t <= 55; t += 6) {
      final len = 22 - (t.abs() * 0.25);
      c.drawLine(Offset(center.dx, center.dy + t), Offset(center.dx + len, center.dy + t - 4), barb);
      c.drawLine(Offset(center.dx, center.dy + t), Offset(center.dx - len, center.dy + t - 4), barb);
    }
  }

  void _paintJungle(Canvas c, Size s) {
    final trunkPaint = Paint()..color = chapter.palette.ink.withValues(alpha: 0.7);
    for (int i = 0; i < 5; i++) {
      final x = s.width * (0.15 + i * 0.17);
      final h = s.height * (0.35 + (i.isEven ? 0.08 : 0));
      c.drawRect(Rect.fromLTWH(x - 4, s.height * 0.30, 8, h), trunkPaint);

      // Leaves.
      final leaf = Paint()..color = chapter.palette.accent.withValues(alpha: 0.65);
      for (int k = -2; k <= 2; k++) {
        c.drawOval(
          Rect.fromCenter(
            center: Offset(x + k * 12, s.height * 0.30 + (k.isEven ? 4 : -2)),
            width: 34,
            height: 14,
          ),
          leaf,
        );
      }
    }

    // Junglefowl silhouette.
    final bird = Offset(s.width * 0.55, s.height * 0.80);
    final body = Path()
      ..moveTo(bird.dx - 20, bird.dy)
      ..quadraticBezierTo(bird.dx - 30, bird.dy - 25, bird.dx, bird.dy - 30)
      ..quadraticBezierTo(bird.dx + 30, bird.dy - 25, bird.dx + 20, bird.dy)
      ..close();
    c.drawPath(body, Paint()..color = Colors.red.shade900);

    // Comb.
    c.drawCircle(Offset(bird.dx - 15, bird.dy - 35), 5, Paint()..color = Colors.red);
    c.drawCircle(Offset(bird.dx - 8, bird.dy - 38), 4, Paint()..color = Colors.red);

    // Legs.
    final legs = Paint()
      ..color = chapter.palette.ink
      ..strokeWidth = 2;
    c.drawLine(Offset(bird.dx - 6, bird.dy), Offset(bird.dx - 6, bird.dy + 10), legs);
    c.drawLine(Offset(bird.dx + 6, bird.dy), Offset(bird.dx + 6, bird.dy + 10), legs);
  }

  void _paintWheat(Canvas c, Size s) {
    // Adobe wall.
    c.drawRect(
      Rect.fromLTWH(0, s.height * 0.60, s.width, s.height * 0.40),
      Paint()..color = chapter.palette.ink.withValues(alpha: 0.35),
    );
    // Wheat stalks.
    final stalk = Paint()
      ..color = chapter.palette.accent
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final x = s.width * (0.15 + i * 0.14);
      c.drawLine(Offset(x, s.height * 0.55), Offset(x + 6, s.height * 0.30), stalk);
      // Grain heads.
      for (int k = 0; k < 3; k++) {
        c.drawOval(
          Rect.fromCenter(
            center: Offset(x + 6 - k * 3, s.height * (0.32 + k * 0.03)),
            width: 8,
            height: 4,
          ),
          Paint()..color = chapter.palette.accent,
        );
      }
    }
    // A little clay pot.
    final pot = Path()
      ..moveTo(s.width * 0.75, s.height * 0.75)
      ..lineTo(s.width * 0.85, s.height * 0.75)
      ..lineTo(s.width * 0.83, s.height * 0.92)
      ..lineTo(s.width * 0.77, s.height * 0.92)
      ..close();
    c.drawPath(pot, Paint()..color = chapter.palette.ink);
  }

  void _paintLaurel(Canvas c, Size s) {
    final center = Offset(s.width / 2, s.height * 0.5);
    final wreath = Paint()
      ..color = chapter.palette.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    c.drawCircle(center, 70, wreath);

    // Leaves.
    final leafPaint = Paint()..color = chapter.palette.accent;
    for (double a = 0; a < math.pi * 2; a += math.pi / 12) {
      final at = center + Offset(math.cos(a) * 70, math.sin(a) * 70);
      c.save();
      c.translate(at.dx, at.dy);
      c.rotate(a + math.pi / 2);
      c.drawOval(Rect.fromCenter(center: Offset.zero, width: 8, height: 20), leafPaint);
      c.restore();
    }

    // Column.
    c.drawRect(Rect.fromLTWH(s.width * 0.10, s.height * 0.35, 12, s.height * 0.60),
        Paint()..color = chapter.palette.ink.withValues(alpha: 0.5));
    c.drawRect(Rect.fromLTWH(s.width * 0.06, s.height * 0.32, 20, 6),
        Paint()..color = chapter.palette.ink.withValues(alpha: 0.6));
  }

  void _paintMedieval(Canvas c, Size s) {
    // Coop.
    c.drawRect(Rect.fromLTWH(s.width * 0.20, s.height * 0.50, s.width * 0.60, s.height * 0.35),
        Paint()..color = chapter.palette.ink.withValues(alpha: 0.55));
    final roof = Path()
      ..moveTo(s.width * 0.15, s.height * 0.50)
      ..lineTo(s.width * 0.50, s.height * 0.30)
      ..lineTo(s.width * 0.85, s.height * 0.50)
      ..close();
    c.drawPath(roof, Paint()..color = chapter.palette.accent);

    // Weathervane rooster.
    c.drawRect(Rect.fromLTWH(s.width * 0.49, s.height * 0.15, 2, s.height * 0.15),
        Paint()..color = chapter.palette.ink);
    final rooster = Path()
      ..moveTo(s.width * 0.45, s.height * 0.18)
      ..lineTo(s.width * 0.60, s.height * 0.15)
      ..lineTo(s.width * 0.58, s.height * 0.20)
      ..lineTo(s.width * 0.50, s.height * 0.18)
      ..close();
    c.drawPath(rooster, Paint()..color = chapter.palette.ink);

    // Little door.
    c.drawRect(Rect.fromLTWH(s.width * 0.47, s.height * 0.68, s.width * 0.06, s.height * 0.17),
        Paint()..color = chapter.palette.top);
  }

  void _paintShip(Canvas c, Size s) {
    // Waves.
    final wavePaint = Paint()..color = chapter.palette.ink.withValues(alpha: 0.5);
    for (int i = 0; i < 3; i++) {
      final path = Path()..moveTo(0, s.height * (0.75 + i * 0.06));
      for (double x = 0; x < s.width; x += 20) {
        path.relativeQuadraticBezierTo(10, -6, 20, 0);
      }
      c.drawPath(path, Paint()
        ..color = chapter.palette.ink.withValues(alpha: 0.35 - i * 0.10)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke);
      wavePaint;
    }

    // Hull.
    final hull = Path()
      ..moveTo(s.width * 0.30, s.height * 0.65)
      ..lineTo(s.width * 0.72, s.height * 0.65)
      ..lineTo(s.width * 0.66, s.height * 0.78)
      ..lineTo(s.width * 0.36, s.height * 0.78)
      ..close();
    c.drawPath(hull, Paint()..color = chapter.palette.ink);

    // Mast + sail.
    c.drawRect(Rect.fromLTWH(s.width * 0.50, s.height * 0.25, 3, s.height * 0.40),
        Paint()..color = chapter.palette.ink);
    final sail = Path()
      ..moveTo(s.width * 0.35, s.height * 0.30)
      ..lineTo(s.width * 0.66, s.height * 0.30)
      ..lineTo(s.width * 0.62, s.height * 0.60)
      ..lineTo(s.width * 0.40, s.height * 0.60)
      ..close();
    c.drawPath(sail, Paint()..color = chapter.palette.accent);
  }

  void _paintGear(Canvas c, Size s) {
    _drawGear(c, Offset(s.width * 0.35, s.height * 0.50), 55, chapter.palette.accent);
    _drawGear(c, Offset(s.width * 0.68, s.height * 0.68), 38, chapter.palette.ink);

    // Chicken silhouette.
    final bird = Offset(s.width * 0.75, s.height * 0.35);
    c.drawCircle(bird, 12, Paint()..color = Colors.white);
    c.drawCircle(bird + const Offset(-3, -3), 2, Paint()..color = chapter.palette.ink);
    final beak = Path()
      ..moveTo(bird.dx + 10, bird.dy)
      ..lineTo(bird.dx + 18, bird.dy)
      ..lineTo(bird.dx + 10, bird.dy + 4)
      ..close();
    c.drawPath(beak, Paint()..color = chapter.palette.accent);
    c.drawCircle(bird + const Offset(3, -14), 3, Paint()..color = Colors.red);
    c.drawCircle(bird + const Offset(-2, -14), 3, Paint()..color = Colors.red);
  }

  void _drawGear(Canvas c, Offset center, double radius, Color color) {
    final teethCount = 12;
    final paint = Paint()..color = color;
    for (int i = 0; i < teethCount; i++) {
      final a = i * (math.pi * 2 / teethCount);
      final tip = center + Offset(math.cos(a) * (radius + 6), math.sin(a) * (radius + 6));
      c.save();
      c.translate(tip.dx, tip.dy);
      c.rotate(a);
      c.drawRect(const Rect.fromLTWH(-4, -3, 8, 6), paint);
      c.restore();
    }
    c.drawCircle(center, radius, paint);
    c.drawCircle(center, radius * 0.4, Paint()..color = Colors.white.withValues(alpha: 0.9));
  }

  void _paintGlobe(Canvas c, Size s) {
    final center = Offset(s.width * 0.35, s.height * 0.55);
    final r = 55.0;
    c.drawCircle(center, r, Paint()..color = chapter.palette.top);
    // Longitudes.
    final line = Paint()
      ..color = chapter.palette.ink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      c.drawOval(
        Rect.fromCenter(center: center, width: r * 2 - i * 22, height: r * 2),
        line,
      );
    }
    c.drawLine(Offset(center.dx - r, center.dy), Offset(center.dx + r, center.dy), line);
    c.drawCircle(center, r, line);

    // Little continent blobs.
    c.drawPath(
      Path()
        ..moveTo(center.dx - 20, center.dy - 10)
        ..cubicTo(center.dx - 15, center.dy - 20, center.dx + 5, center.dy - 25, center.dx + 15, center.dy - 10)
        ..cubicTo(center.dx + 10, center.dy, center.dx - 10, center.dy + 5, center.dx - 20, center.dy - 10)
        ..close(),
      Paint()..color = chapter.palette.accent,
    );

    // A tiny happy chicken.
    final bird = Offset(s.width * 0.75, s.height * 0.55);
    c.drawCircle(bird, 22, Paint()..color = Colors.white);
    c.drawCircle(bird + const Offset(4, -6), 2.5, Paint()..color = chapter.palette.ink);
    final beak = Path()
      ..moveTo(bird.dx + 18, bird.dy - 2)
      ..lineTo(bird.dx + 30, bird.dy)
      ..lineTo(bird.dx + 18, bird.dy + 5)
      ..close();
    c.drawPath(beak, Paint()..color = chapter.palette.accent);
    c.drawCircle(bird + const Offset(6, -22), 5, Paint()..color = Colors.red);
    c.drawCircle(bird + const Offset(-2, -22), 5, Paint()..color = Colors.red);

    // Wing.
    c.drawArc(Rect.fromCenter(center: bird + const Offset(-2, 2), width: 20, height: 20),
        math.pi * 0.2, math.pi * 0.9, true, Paint()..color = chapter.palette.top.withValues(alpha: 0.9));
  }

  @override
  bool shouldRepaint(_ChapterPainter oldDelegate) => oldDelegate.chapter.id != chapter.id;
}
