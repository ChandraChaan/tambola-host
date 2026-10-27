import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/core/seeded_random.dart';

void main() {
  group('SeededRandom', () {
    // Reference values from the JavaScript mulberry32 implementation, so the
    // web build (and therefore every printed ticket) matches the VM.
    test('matches the reference mulberry32 sequence', () {
      final a = SeededRandom(12345);
      expect(
        [for (var i = 0; i < 5; i++) a.nextUint32()],
        [4207900869, 1317490944, 2079646450, 3513001552, 2187978186],
      );
      final b = SeededRandom(0xDEADBEEF);
      expect(
        [for (var i = 0; i < 3; i++) b.nextUint32()],
        [4043151706, 1147597007, 3315858022],
      );
    });

    test('same seed gives the same sequence', () {
      final a = SeededRandom(7);
      final b = SeededRandom(7);
      for (var i = 0; i < 1000; i++) {
        expect(a.nextInt(90), b.nextInt(90));
      }
    });

    test('nextInt stays in range and reaches every value', () {
      final random = SeededRandom(99);
      final seen = <int>{};
      for (var i = 0; i < 5000; i++) {
        final value = random.nextInt(10);
        expect(value, inInclusiveRange(0, 9));
        seen.add(value);
      }
      expect(seen, hasLength(10));
    });

    test('shuffle is a permutation', () {
      final items = List<int>.generate(90, (i) => i + 1);
      SeededRandom(3).shuffle(items);
      expect(items.toSet(), hasLength(90));
      expect(items, isNot(List<int>.generate(90, (i) => i + 1)));
    });
  });

  test('imul32 matches 32-bit multiplication', () {
    expect(imul32(0xFFFFFFFF, 0xFFFFFFFF), 1);
    expect(
      imul32(0x12345678, 0x9ABCDEF0),
      (0x12345678 * 0x9ABCDEF0) & 0xFFFFFFFF,
    );
    expect(imul32(3, 5), 15);
  });

  test('fnv1a32 matches the reference values', () {
    expect(fnv1a32(''), 2166136261);
    expect(fnv1a32('a'), 3826002220);
    expect(fnv1a32('K7QX2M'), 1600154363);
  });
}
