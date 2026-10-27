/// A small deterministic random generator (mulberry32).
///
/// `dart:math`'s `Random(seed)` is not guaranteed to give the same sequence
/// on the Dart VM and on the web, and tickets must be identical everywhere,
/// so every step here is done in 32-bit arithmetic that behaves the same on
/// both.
class SeededRandom {
  SeededRandom(int seed) : _state = seed & _mask;

  static const int _mask = 0xFFFFFFFF;

  int _state;

  /// The next value in `0 .. 2^32 - 1`.
  int nextUint32() {
    _state = (_state + 0x6D2B79F5) & _mask;
    var t = _state;
    t = imul32(t ^ (t >>> 15), t | 1);
    t ^= (t + imul32(t ^ (t >>> 7), t | 61)) & _mask;
    return (t ^ (t >>> 14)) & _mask;
  }

  /// A uniform value in `0 .. max - 1`, without modulo bias.
  int nextInt(int max) {
    assert(max > 0 && max <= 0x100000000, 'max out of range: $max');
    final limit = 0x100000000 - (0x100000000 % max);
    while (true) {
      final value = nextUint32();
      if (value < limit) return value % max;
    }
  }

  /// Shuffles [items] in place (Fisher–Yates).
  void shuffle<T>(List<T> items) {
    for (var i = items.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = items[i];
      items[i] = items[j];
      items[j] = tmp;
    }
  }
}

/// 32-bit multiplication that gives the same low 32 bits on the VM and on
/// the web (where plain `*` would lose precision above 2^53).
int imul32(int a, int b) {
  final aHi = (a >>> 16) & 0xFFFF;
  final aLo = a & 0xFFFF;
  final bHi = (b >>> 16) & 0xFFFF;
  final bLo = b & 0xFFFF;
  final high = ((aHi * bLo + aLo * bHi) & 0xFFFF) << 16;
  return (aLo * bLo + high) & 0xFFFFFFFF;
}

/// 32-bit FNV-1a hash of [text], used to turn a game code into a seed.
int fnv1a32(String text) {
  var hash = 0x811C9DC5;
  for (final unit in text.codeUnits) {
    hash = imul32(hash ^ unit, 0x01000193);
  }
  return hash;
}
