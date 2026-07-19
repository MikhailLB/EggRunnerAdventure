import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/routes.dart';
import '../data/chapters_data.dart';
import '../hatchway/core/hatch_models.dart';
import '../hatchway/hatch_coordinator.dart';
import '../hatchway/pages/empty_air_page.dart';
import '../hatchway/pages/feather_invitation.dart';
import '../hatchway/pages/roost_portal.dart';
import '../l10n/app_l10n.dart';

/// Splash / boot screen.
///
/// Behaviour mirrors the loading experience in LavaPickRun: the screen adapts
/// to device orientation and swaps between portrait and landscape artwork.
///
/// Crucially, the progress bar reflects *real* loading work — we precache
/// every chapter illustration and the mascot before entering the app, and the
/// bar advances as each asset finishes decoding. Navigation only happens once
/// everything is ready (and a small minimum time has passed for polish).
class BootScreen extends StatefulWidget {
  const BootScreen({super.key, this.hatchCoordinator});

  final HatchCoordinator? hatchCoordinator;

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> _assetsToLoad = [
    'assets/mascot/henrietta.png',
    ...ChaptersData.allImages(),
  ];

  int _loaded = 0;
  double _hatchProgress = 0;
  HatchDestination? _destination;
  bool _started = false;
  bool _navigating = false;
  late final DateTime _startTime;
  Timer? _hardDeadline;
  static const Duration _minSplash = Duration(milliseconds: 1600);

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // Boot screen supports both orientations, per requirements.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hard deadline: even if precache hangs, navigate after 8 s.
    _hardDeadline = Timer(const Duration(seconds: 8), () {
      if (mounted && !_navigating) {
        setState(() => _loaded = _assetsToLoad.length);
        _maybeNavigate();
      }
    });
  }

  @override
  void dispose() {
    _hardDeadline?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _beginLaunchWork();
    }
  }

  Future<void> _beginLaunchWork() async {
    await Future.wait<void>(<Future<void>>[
      _preloadAll(),
      _resolveHatchDestination(),
    ]);
    _maybeNavigate();
  }

  Future<void> _preloadAll() async {
    for (final asset in _assetsToLoad) {
      try {
        await precacheImage(AssetImage(asset), context);
      } catch (_) {
        // Ignore individual failures — bar still advances so we never hang.
      }
      if (!mounted) return;
      if (_loaded < _assetsToLoad.length) {
        setState(() => _loaded++);
      }
    }
    _hardDeadline?.cancel();
    _maybeNavigate();
  }

  Future<void> _resolveHatchDestination() async {
    final coordinator = widget.hatchCoordinator;
    if (coordinator == null) {
      _destination = const NativeNest();
      _hatchProgress = 1;
      return;
    }
    try {
      _destination = await coordinator.decide(
        onProgress: (value) {
          if (mounted) {
            setState(() => _hatchProgress = value.clamp(0.0, 1.0));
          }
        },
      );
    } catch (_) {
      _destination = const NativeNest();
    }
    if (mounted) setState(() => _hatchProgress = 1);
  }

  void _maybeNavigate() async {
    if (_navigating || _destination == null || _loaded < _assetsToLoad.length) {
      return;
    }
    // Respect a minimum splash duration for a smooth reveal.
    final elapsed = DateTime.now().difference(_startTime);
    if (elapsed < _minSplash) {
      await Future<void>.delayed(_minSplash - elapsed);
    }
    if (!mounted || _navigating) return;
    _navigating = true;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (!mounted) return;
    await _openDestination(_destination!);
  }

  Future<void> _openDestination(HatchDestination destination) async {
    final coordinator = widget.hatchCoordinator;
    if (destination is NativeNest || coordinator == null) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
      return;
    }
    if (destination is OfflineNest) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => EmptyAirPage(
            probe: coordinator.probe,
            retryBuilder: (_) => BootScreen(hatchCoordinator: coordinator),
          ),
        ),
      );
      return;
    }
    if (destination is PortalNest) {
      Widget portalBuilder(BuildContext _) => RoostPortal(
        url: destination.url,
        coldLaunch: destination.coldLaunch,
        vault: coordinator.vault,
        probe: coordinator.probe,
        notifications: coordinator.notifications,
        agent: coordinator.agent,
      );

      void openPortal() {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute<void>(builder: portalBuilder));
      }

      if (coordinator.vault.shouldShowPushInvite &&
          await coordinator.notifications.canOfferPermission()) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => FeatherInvitation(
              vault: coordinator.vault,
              notifications: coordinator.notifications,
              nextBuilder: portalBuilder,
            ),
          ),
        );
      } else {
        openPortal();
      }
    }
  }

  double get _progress {
    final assetProgress = _assetsToLoad.isEmpty
        ? 1.0
        : _loaded / _assetsToLoad.length;
    return (assetProgress * 0.58 + _hatchProgress * 0.42).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final asset = isLandscape
        ? 'assets/loading/loading_landscape.png'
        : 'assets/loading/loading_portrait.png';

    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE9BF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) =>
                Container(color: const Color(0xFFFFE9BF)),
          ),
          // Game title, horizontally centered near the top in both orientations.
          Align(
            alignment: isLandscape
                ? Alignment.topCenter
                : const Alignment(0, -0.72),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: isLandscape ? 10 : 24),
                child: _GameTitle(
                  fontSize: isLandscape ? screenW * 0.045 : screenW * 0.085,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLandscape ? 18 : 54),
                child: _LoadingBar(
                  progress: _progress,
                  width: isLandscape ? screenW * 0.42 : screenW * 0.74,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.progress, required this.width});

  final double progress;
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
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF6E3A1D), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
                  builder: (context, value, _) {
                    return FractionallySizedBox(
                      widthFactor: value <= 0 ? 0.001 : value,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF8A2E),
                              Color(0xFFFFCB47),
                              Color(0xFF7EE05B),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _LoadingLabel(),
      ],
    );
  }
}

/// Stylised text logo for the game title shown on the boot screen.
class _GameTitle extends StatelessWidget {
  const _GameTitle({required this.fontSize});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stroke('Egg Runner', fontSize),
        _stroke('Adventure', fontSize * 0.72),
      ],
    );
  }

  Widget _stroke(String text, double size) {
    return Stack(
      children: [
        // Outline / shadow
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: size,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = size * 0.14
              ..strokeJoin = StrokeJoin.round
              ..color = const Color(0xFF6E3A1D),
            height: 1.05,
          ),
        ),
        // Fill
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Baloo2',
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: Color(0xFFFFF8E7),
            height: 1.05,
            shadows: [
              Shadow(
                color: Color(0xFFFF8A2E),
                offset: Offset(1.5, 2.5),
                blurRadius: 0,
              ),
            ],
          ).copyWith(fontSize: size),
        ),
      ],
    );
  }
}

/// "Loading" with three dots that animate in sequence.
class _LoadingLabel extends StatefulWidget {
  @override
  State<_LoadingLabel> createState() => _LoadingLabelState();
}

class _LoadingLabelState extends State<_LoadingLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppL10n>(context, AppL10n);
    final label = l10n?.t('loading') ?? 'Loading';
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final phase = (_ctrl.value * 3).floor() % 3;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.6,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: i <= phase ? 1.0 : 0.3,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
