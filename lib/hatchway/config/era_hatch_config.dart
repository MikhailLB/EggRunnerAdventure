import '../core/feather_codec.dart';

/// ════════════════════════════════════════════════════════════
/// ⚠️  TEMPLATE — fill every credential before shipping.
/// ════════════════════════════════════════════════════════════
///
/// All secrets are stored as obfuscated byte arrays (never plaintext):
///   1. Put your plaintext values into tool/encode_era_values.dart.
///   2. Change the cipher salt in lib/hatchway/core/feather_codec.dart
///      (`_nestSalt`) to something unique for THIS app.
///   3. Run `dart run tool/encode_era_values.dart`.
///   4. Paste the printed byte arrays below. The VERIFY block must
///      round-trip EXACTLY (a stray/missing byte silently corrupts the
///      URL — that bug cost real debugging time; always re-verify).
///
/// The gray gate stays disabled (white part only) until `endpoint`,
/// `appsFlyerKey` and `firebaseProjectNumber` are all non-empty.
abstract final class EraHatchConfig {
  // TODO: your app identity.
  static const String appTitle = 'Gray Flow Template';
  static const String bundleId = 'com.example.grayflow';

  /// iOS App Store numeric id (used for GCD + store_id). TODO: replace.
  static const String iosStoreId = '0000000000';

  static const int pushSnoozeSeconds = 259200; // 3 days
  static const int organicRecheckSeconds = 6;

  // ── Encoded secrets (paste from tool/encode_era_values.dart) ──────────
  // TODO: config endpoint, e.g. https://yourdomain.com/config.php
  static const List<int> _endpoint = <int>[];
  // TODO: privacy policy URL
  static const List<int> _privacy = <int>[];
  // TODO: support URL
  static const List<int> _support = <int>[];
  // TODO: AppsFlyer Dev Key
  static const List<int> _appsFlyerKey = <int>[];
  // TODO: Firebase project number (GCM_SENDER_ID)
  static const List<int> _firebaseProject = <int>[];

  // AppsFlyer GCD base — generic, safe to keep across projects.
  static const List<int> _gcd = <int>[
    118, 79, 247, 184, 89, 211, 154, 208, 23, 166, 239, 82, 162, 216, 111,
    218, 222, 206, 148, 40, 144, 140, 178, 28, 220, 5, 8, 241, 107, 171, 236,
    25, 252, 166, 207, 221, 200, 152, 163, 72, 175, 250, 74, 131, 193, 182, 55,
  ];

  // User-Agent version fragments — vary per project (see gray_user_agent).
  static const List<int> _webkit = <int>[68, 11, 184, 118, 23, 199, 156, 214];
  static const List<int> _safari = <int>[63, 19, 177, 126];
  static const List<int> _safariTail = <int>[68, 11, 183, 118, 23];

  // OneLink is OPTIONAL — it must NEVER be part of the gate-enable check.
  static const List<int> _oneLinkHost = <int>[];

  static String get endpoint => unfoldFeathers(_endpoint);
  static String get privacyUrl => unfoldFeathers(_privacy);
  static String get supportUrl => unfoldFeathers(_support);
  static String get gcdBase => unfoldFeathers(_gcd);
  static String get webKitVersion => unfoldFeathers(_webkit);
  static String get safariVersion => unfoldFeathers(_safari);
  static String get safariTail => unfoldFeathers(_safariTail);
  static String get appsFlyerKey => unfoldFeathers(_appsFlyerKey);
  static String get firebaseProjectNumber => unfoldFeathers(_firebaseProject);
  static String get oneLinkHost => unfoldFeathers(_oneLinkHost);

  static String get storeToken => 'id$iosStoreId';

  /// Gate needs config endpoint + AF key + Firebase project number.
  /// ⚠️ Do NOT add optional fields (e.g. OneLink) here — a missing optional
  /// value would silently disable the whole gray flow.
  static bool get grayCredentialsReady =>
      endpoint.isNotEmpty &&
      appsFlyerKey.isNotEmpty &&
      firebaseProjectNumber.isNotEmpty;
}
