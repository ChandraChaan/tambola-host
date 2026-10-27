import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/core/seeded_random.dart';
import 'package:tambola_host/features/game/domain/call_phrases.dart';
import 'package:tambola_host/features/game/domain/game_code.dart';
import 'package:tambola_host/features/game/domain/settings.dart';

void main() {
  group('CallPhrases', () {
    test('there is a distinct rhyme for every number', () {
      final rhymes = [for (var n = 1; n <= 90; n++) CallPhrases.rhyme(n)];
      expect(rhymes.every((r) => r.trim().isNotEmpty), isTrue);
      expect(rhymes.toSet(), hasLength(90));
    });

    test('there are Hindi words for every number', () {
      final words = [for (var n = 1; n <= 90; n++) CallPhrases.hindiWords(n)];
      expect(words.toSet(), hasLength(90));
      expect(CallPhrases.hindiWords(42), 'बयालीस');
      expect(CallPhrases.hindiWords(90), 'नब्बे');
    });

    test('English words', () {
      expect(CallPhrases.englishWords(7), 'seven');
      expect(CallPhrases.englishWords(13), 'thirteen');
      expect(CallPhrases.englishWords(40), 'forty');
      expect(CallPhrases.englishWords(42), 'forty-two');
      expect(CallPhrases.englishWords(90), 'ninety');
    });

    test('spoken calls', () {
      expect(
        CallPhrases.spoken(42, VoiceLanguage.english),
        'four and two, forty-two.',
      );
      expect(
        CallPhrases.spoken(7, VoiceLanguage.english),
        'Single number seven, seven.',
      );
      expect(
        CallPhrases.spoken(42, VoiceLanguage.english, rhyme: true),
        startsWith('${CallPhrases.rhyme(42)}. '),
      );
      expect(CallPhrases.spoken(42, VoiceLanguage.hindi), 'चार और दो, बयालीस.');
      expect(
        CallPhrases.spoken(50, VoiceLanguage.hindi),
        'पाँच और शून्य, पचास.',
      );
      expect(CallPhrases.spoken(42, VoiceLanguage.off), isEmpty);
    });
  });

  group('GameCode', () {
    test('generated codes are valid and use the safe alphabet', () {
      final random = SeededRandom(1);
      for (var i = 0; i < 500; i++) {
        final code = GameCode.generate(random.nextInt);
        expect(GameCode.isValid(code), isTrue, reason: code);
        expect(code, isNot(matches(RegExp('[01OIL]'))));
      }
    });

    test('normalize and isValid', () {
      expect(GameCode.normalize(' k7qx2m '), 'K7QX2M');
      expect(GameCode.isValid('K7QX2M'), isTrue);
      expect(GameCode.isValid('K7QX2'), isFalse);
      expect(GameCode.isValid('K7QX2O'), isFalse);
    });
  });

  group('CallerSettings', () {
    test('JSON round trip', () {
      const settings = CallerSettings(
        intervalSeconds: 12,
        voice: VoiceLanguage.hindi,
        rhymes: false,
        theme: ThemeChoice.dark,
      );
      expect(CallerSettings.fromJson(settings.toJson()), settings);
    });

    test('bad values fall back to defaults', () {
      final settings = CallerSettings.fromJson({
        'intervalSeconds': 999,
        'voice': 'klingon',
        'rhymes': 'yes',
      });
      expect(settings.intervalSeconds, CallerSettings.maxInterval);
      expect(settings.voice, const CallerSettings().voice);
      expect(settings.rhymes, const CallerSettings().rhymes);
      expect(settings.theme, ThemeChoice.system);
    });
  });
}
