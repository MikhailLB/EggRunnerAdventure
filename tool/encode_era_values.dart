// ignore_for_file: avoid_print

import 'dart:typed_data';

const List<int> _nestSalt = <int>[
  0x45,
  0x67,
  0x67,
  0x52,
  0x75,
  0x6E,
  0x2E,
  0x32,
  0x36,
  0x2E,
  0x68,
  0x65,
  0x6E,
];

Uint8List _buildFeatherStream(int length) {
  final state = List<int>.generate(256, (index) => index);
  var cursor = 0;
  for (var index = 0; index < state.length; index++) {
    cursor =
        (cursor + state[index] + _nestSalt[index % _nestSalt.length]) & 0xff;
    final swap = state[index];
    state[index] = state[cursor];
    state[cursor] = swap;
  }
  final result = Uint8List(length);
  var left = 0;
  var right = 0;
  for (var index = 0; index < length; index++) {
    left = (left + 1) & 0xff;
    right = (right + state[left] + index) & 0xff;
    final swap = state[left];
    state[left] = state[right];
    state[right] = swap;
    result[index] = state[(state[left] + state[right]) & 0xff];
  }
  return result;
}

List<int> fold(String value) {
  final bytes = Uint8List.fromList(value.codeUnits);
  final stream = _buildFeatherStream(bytes.length);
  return List<int>.generate(
    bytes.length,
    (index) => (bytes[index] + stream[index] + (index * 17)) & 0xff,
  );
}

String unfold(List<int> encoded) {
  final stream = _buildFeatherStream(encoded.length);
  return String.fromCharCodes(
    List<int>.generate(
      encoded.length,
      (index) => (encoded[index] - stream[index] - (index * 17)) & 0xff,
    ),
  );
}

void main() {
  const values = <String, String>{
    'config': 'https://eggrunneradventure.com/config.php',
    'privacy': 'https://eggrunneradventure.com/privacy-policy.html',
    'support': 'https://eggrunneradventure.com/support.html',
    'gcd': 'https://gcdsdk.appsflyer.com/install_data/v4.0/',
    'webkit': '605.1.15',
    'safari': '18.6',
    'safariTail': '604.1',
    'appsFlyerDevKey': '',
    'firebaseProjectNumber': '',
    'oneLinkHost': '',
  };

  for (final entry in values.entries) {
    final encoded = fold(entry.value);
    print('${entry.key}: <int>[${encoded.join(', ')}]');
    if (unfold(encoded) != entry.value) {
      throw StateError('Round-trip failed for ${entry.key}');
    }
  }
  print('VERIFY: all values round-tripped');
}
