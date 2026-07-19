import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'hatchway/config/era_hatch_config.dart';
import 'hatchway/hatch_coordinator.dart';
import 'hatchway/infra/airway_probe.dart';
import 'hatchway/infra/egg_signal_hub.dart';
import 'hatchway/infra/flight_attribution.dart';
import 'hatchway/infra/hatch_exchange.dart';
import 'hatchway/infra/nest_vault.dart';
import 'hatchway/infra/roost_agent.dart';

/// Entrypoint. Warms up the gray-flow services and sets a friendly system-UI
/// overlay before mounting the app. Orientation is left flexible so the boot
/// screen can render in both portrait and landscape.
///
/// TEMPLATE: initialise your white-part game (storage/audio/etc.) here, before
/// runApp — never inside the gray flow.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final vault = NestVault();
  final agent = RoostAgent();
  await Future.wait<void>(<Future<void>>[
    // TODO: add your game init futures here (e.g. StorageService.init()).
    vault.initialize(),
    agent.prepare(),
  ]);

  assert(() {
    debugPrint(
      '[ERA.BOOT] credentialsReady=${EraHatchConfig.grayCredentialsReady} '
      'endpoint=${EraHatchConfig.endpoint} '
      'afKeyLen=${EraHatchConfig.appsFlyerKey.length} '
      'fbNum=${EraHatchConfig.firebaseProjectNumber}',
    );
    return true;
  }());

  var productionServicesReady = false;
  if (EraHatchConfig.grayCredentialsReady) {
    try {
      await Firebase.initializeApp();
      productionServicesReady = true;
      assert(() {
        debugPrint('[ERA.BOOT] Firebase.initializeApp OK');
        return true;
      }());
    } catch (error) {
      assert(() {
        debugPrint('[ERA.BOOT] Firebase.initializeApp failed: $error');
        return true;
      }());
    }
    if (productionServicesReady) {
      try {
        await FirebaseAppCheck.instance.activate(
          providerApple: kDebugMode
              ? const AppleDebugProvider()
              : const AppleAppAttestWithDeviceCheckFallbackProvider(),
        );
      } catch (error) {
        // App Check must never block FCM / gray routing.
        assert(() {
          debugPrint('[ERA.BOOT] AppCheck skipped: $error');
          return true;
        }());
      }
    }
  } else {
    assert(() {
      debugPrint(
        '[ERA.BOOT] gray gate DISABLED — missing credentials '
        '(endpoint/af/firebase). White part only.',
      );
      return true;
    }());
  }

  final probe = AirwayProbe();
  // Attribution + config POST must run even if Firebase failed to init;
  // only push/FCM needs productionServicesReady.
  final notifications = EggSignalHub(vault, enabled: productionServicesReady);
  final attribution = FlightAttribution(agent);
  final coordinator = HatchCoordinator(
    vault: vault,
    probe: probe,
    attribution: attribution,
    exchange: HatchExchange(agent, vault),
    notifications: notifications,
    agent: agent,
    runtimeEnabled: EraHatchConfig.grayCredentialsReady,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFF6E1),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(FeatheredOriginsApp(hatchCoordinator: coordinator));
}
