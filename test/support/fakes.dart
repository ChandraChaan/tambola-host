import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/app.dart';
import 'package:tambola_host/core/seeded_random.dart';
import 'package:tambola_host/features/game/domain/announcer.dart';
import 'package:tambola_host/features/game/domain/game.dart';
import 'package:tambola_host/features/game/domain/game_repository.dart';
import 'package:tambola_host/features/game/domain/settings.dart';
import 'package:tambola_host/features/game/presentation/providers.dart';

class FakeGameRepository implements GameRepository {
  FakeGameRepository({this.game, this.settings = const CallerSettings()});

  Game? game;
  CallerSettings settings;
  int saves = 0;

  @override
  Game? loadGame() => game;

  @override
  Future<void> saveGame(Game game) async {
    this.game = game;
    saves++;
  }

  @override
  CallerSettings loadSettings() => settings;

  @override
  Future<void> saveSettings(CallerSettings settings) async =>
      this.settings = settings;
}

class FakeAnnouncer implements Announcer {
  final List<(String, VoiceLanguage)> spoken = [];
  int stops = 0;

  @override
  Future<void> speak(String text, VoiceLanguage language) async {
    if (language != VoiceLanguage.off) spoken.add((text, language));
  }

  @override
  Future<void> stop() async => stops++;
}

/// Provider overrides that keep tests off the real storage, speech, clock
/// and random source.
List<Override> testOverrides({
  required FakeGameRepository repository,
  FakeAnnouncer? announcer,
  int seed = 42,
}) {
  final random = SeededRandom(seed);
  return [
    gameRepositoryProvider.overrideWithValue(repository),
    announcerProvider.overrideWithValue(announcer ?? FakeAnnouncer()),
    randomProvider.overrideWithValue(random.nextInt),
    clockProvider.overrideWithValue(() => DateTime.utc(2026, 10, 27, 19)),
  ];
}

Game sampleGame({int calledCount = 0, int ticketCount = 60}) => Game(
  code: 'K7QX2M',
  callSeed: 20261027,
  ticketCount: ticketCount,
  calledCount: calledCount,
  startedAt: DateTime.utc(2026, 10, 27, 19),
);

Future<void> pumpApp(
  WidgetTester tester, {
  required FakeGameRepository repository,
  FakeAnnouncer? announcer,
  Size size = const Size(1280, 1000),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: testOverrides(repository: repository, announcer: announcer),
      child: const TambolaHostApp(),
    ),
  );
  await tester.pumpAndSettle();
}
