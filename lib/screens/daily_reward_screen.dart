import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/facts_data.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../models/fact.dart';
import '../widgets/parchment_background.dart';

/// Once-per-day fun-fact reveal with streak tracking.
///
/// If the user hasn't claimed yet, we render an interactive "egg" they can tap
/// to reveal a card. If they've already claimed today, we show the same fact
/// with a "come back tomorrow" note.
class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _shake;
  DailyReward? _revealed;
  bool _alreadyClaimed = false;
  ChickenFact? _todayFact;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _alreadyClaimed = !ProgressStore.instance.canClaimDaily;
    if (_alreadyClaimed) {
      // Show the same fact selected today.
      final doy = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final streak = ProgressStore.instance.dailyStreak;
      _todayFact = FactsData.facts[(doy + streak) % FactsData.count];
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  Future<void> _claim() async {
    final reward = ProgressStore.instance.claimDaily();
    if (reward == null) return;
    setState(() {
      _revealed = reward;
      _todayFact = FactsData.byId(reward.factId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('daily_title')),
        automaticallyImplyLeading: !widget.embedded,
      ),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        tint: AppColors.yolk,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.t('daily_subtitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 15, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),
                _StreakChip(streak: ProgressStore.instance.dailyStreak, l10n: l10n),
                const SizedBox(height: 22),
                Expanded(
                  child: Center(
                    child: _todayFact == null
                        ? _MysteryEgg(controller: _shake, onTap: _claim, l10n: l10n)
                        : _RewardCard(
                            fact: _todayFact!,
                            reward: _revealed,
                            alreadyClaimed: _alreadyClaimed && _revealed == null,
                            l10n: l10n,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak, required this.l10n});
  final int streak;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.rust.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department_rounded, size: 20, color: AppColors.rust),
            const SizedBox(width: 6),
            Text(
              '${l10n.t('daily_streak')}: $streak ${l10n.t('daily_days')}',
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}

class _MysteryEgg extends StatelessWidget {
  const _MysteryEgg({required this.controller, required this.onTap, required this.l10n});
  final AnimationController controller;
  final VoidCallback onTap;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final wobble = math.sin(controller.value * math.pi * 2) * 0.06;
            return Transform.rotate(
              angle: wobble,
              child: GestureDetector(
                onTap: onTap,
                child: SizedBox(
                  width: 190,
                  height: 240,
                  child: CustomPaint(painter: _EggPainter()),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 26),
        FilledButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.egg_alt_rounded),
          label: Text(l10n.t('daily_claim')),
        ),
      ],
    );
  }
}

class _EggPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Halo.
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w * 0.55,
      Paint()
        ..shader = RadialGradient(colors: [AppColors.sunrise.withValues(alpha: 0.6), Colors.transparent]).createShader(
          Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w * 0.55),
        ),
    );

    final path = Path()
      ..moveTo(w * 0.50, h * 0.05)
      ..cubicTo(w * 0.90, h * 0.10, w * 0.98, h * 0.75, w * 0.50, h * 0.95)
      ..cubicTo(w * 0.02, h * 0.75, w * 0.10, h * 0.10, w * 0.50, h * 0.05)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppColors.parchment, AppColors.yolk],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.ink.withValues(alpha: 0.4),
    );

    // Speckles.
    final rng = math.Random(7);
    final speckle = Paint()..color = AppColors.rust.withValues(alpha: 0.35);
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(w * (0.20 + rng.nextDouble() * 0.6), h * (0.15 + rng.nextDouble() * 0.75)),
        1.5 + rng.nextDouble() * 2,
        speckle,
      );
    }

    // A "?" mark.
    final tp = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: AppColors.rust.withValues(alpha: 0.75),
          fontSize: 84,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(w / 2 - tp.width / 2, h / 2 - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.fact,
    required this.reward,
    required this.alreadyClaimed,
    required this.l10n,
  });

  final ChickenFact fact;
  final DailyReward? reward;
  final bool alreadyClaimed;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.sunrise.withValues(alpha: 0.6), width: 1.4),
              boxShadow: [
                BoxShadow(color: AppColors.sunrise.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.sunrise, AppColors.yolk]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.sunrise.withValues(alpha: 0.5), blurRadius: 16),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(fact.emoji, style: const TextStyle(fontSize: 44)),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.t(fact.titleKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.t(fact.bodyKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.ink, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 18),
                if (reward != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.meadow.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.t('daily_reward_xp', {'xp': reward!.xp.toString()}),
                      style: const TextStyle(color: AppColors.meadow, fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                if (alreadyClaimed) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.t('daily_already_body'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted, fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
