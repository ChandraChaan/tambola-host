import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/game_code.dart';
import 'package:tambola_host/features/game/domain/settings.dart';
import 'package:tambola_host/features/game/presentation/game_controller.dart';
import 'package:tambola_host/features/game/presentation/settings_controller.dart';

import '../support/fakes.dart';

void main() {
  late FakeGameRepository repository;
  late FakeAnnouncer announcer;
  late ProviderContainer container;

  setUp(() {
    repository = FakeGameRepository();
    announcer = FakeAnnouncer();
    container = ProviderContainer.test(
      overrides: testOverrides(repository: repository, announcer: announcer),
    );
  });

  test('creates and saves a new game when nothing is saved', () {
    final game = container.read(gameProvider);
    expect(GameCode.isValid(game.code), isTrue);
    expect(game.calledCount, 0);
    expect(game.ticketCount, 60);
    expect(repository.game, game);
  });

  test('restores a saved game', () {
    repository.game = sampleGame(calledCount: 12);
    final restored = ProviderContainer.test(
      overrides: testOverrides(repository: repository),
    );
    expect(restored.read(gameProvider), sampleGame(calledCount: 12));
  });

  test('callNext saves and announces in the chosen language', () {
    repository.settings = const CallerSettings(
      voice: VoiceLanguage.hindi,
      rhymes: false,
    );
    container.read(gameProvider.notifier).callNext();
    final game = container.read(gameProvider);
    expect(game.calledCount, 1);
    expect(repository.game, game);
    expect(announcer.spoken.single.$2, VoiceLanguage.hindi);
  });

  test('voice off stays silent', () {
    repository.settings = const CallerSettings(voice: VoiceLanguage.off);
    container.read(gameProvider.notifier).callNext();
    expect(announcer.spoken, isEmpty);
  });

  test('undo, then next, repeats the same number', () {
    final controller = container.read(gameProvider.notifier)
      ..callNext()
      ..callNext();
    final second = container.read(gameProvider).current;
    controller.undo();
    expect(container.read(gameProvider).calledCount, 1);
    controller.callNext();
    expect(container.read(gameProvider).current, second);
  });

  test('new game can keep the old code to reuse printed tickets', () {
    final old = container.read(gameProvider);
    container.read(gameProvider.notifier)
      ..callNext()
      ..newGame(ticketCount: 30, code: old.code);
    final game = container.read(gameProvider);
    expect(game.code, old.code);
    expect(game.ticketCount, 30);
    expect(game.calledCount, 0);
    expect(game.callSeed, isNot(old.callSeed));
  });

  test('settings are saved', () {
    container.read(settingsProvider.notifier)
      ..setInterval(99)
      ..setRhymes(false);
    expect(repository.settings.intervalSeconds, CallerSettings.maxInterval);
    expect(repository.settings.rhymes, isFalse);
  });
}
