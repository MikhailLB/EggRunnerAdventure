import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/routes.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';

/// Splash / boot screen.
///
/// Behaviour mirrors the loading experience in LavaPickRun: the screen tracks
/// device orientation live and swaps between the portrait and landscape
/// artwork. A four-stage bar fills over ~3.5s, then we navigate to home and
/// lock the app back to portrait for the reader experience.
class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  final List<Timer> _timers = [];
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    // Boot screen supports both orientations, like requested.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..forward();

    _timers.add(Timer(const Duration(milliseconds: 3600), () {
      if (!_navigating && mounted) _navigate();
    }));
  }

  void _navigate() {
    _navigating = true;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Small delay so the orientation lock takes effect before navigation.
    Future.delayed(const Duration(milliseconds: 60), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.home);
    });
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final asset = isLandscape
        ? 'assets/loading/loading_landscape.png'
        : 'assets/loading/loading_portrait.png';

    return Scaffold(
      backgroundColor: const Color(0xFFFFE9BF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => Container(color: const Color(0xFFFFE9BF)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLandscape ? 20 : 60),
                child: _LoadingBar(
                  animation: _progressCtrl,
                  hint: _hint(context),
                  width: isLandscape
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.72,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hint(BuildContext context) {
    // AppL10n is available because we mount localisation delegates before boot.
    final l10n = Localizations.of<AppL10n>(context, AppL10n);
    if (l10n == null) return 'Preparing timeline...';
    return l10n.t('boot_hint');
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({
    required this.animation,
    required this.hint,
    required this.width,
  });

  final Animation<double> animation;
  final String hint;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF6E3A1D), width: 2.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  return Row(
                    children: [
                      Expanded(
                        flex: (animation.value * 100).round(),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF8A2E), Color(0xFFFFCB47), Color(0xFF7EE05B)],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100 - (animation.value * 100).round(),
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          hint,
          style: const TextStyle(
            color: Color(0xFF6E3A1D),
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

/// A convenience wrapper we use before ProgressStore is available. The class
/// is exported so the app root can call it during warm-up.
class BootBridge {
  static Future<void> ensureStore() => ProgressStore.init();
}
