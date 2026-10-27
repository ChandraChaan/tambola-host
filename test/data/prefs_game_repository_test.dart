import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tambola_host/features/game/data/prefs_game_repository.dart';
import 'package:tambola_host/features/game/domain/settings.dart';

import '../support/fakes.dart';

void main() {
  Future<PrefsGameRepository> repository([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return PrefsGameRepository(await SharedPreferences.getInstance());
  }

  test('starts empty with default settings', () async {
    final repo = await repository();
    expect(repo.loadGame(), isNull);
    expect(repo.loadSettings(), const CallerSettings());
  });

  test('saves and loads the game and settings', () async {
    final repo = await repository();
    final game = sampleGame(calledCount: 17);
    const settings = CallerSettings(voice: VoiceLanguage.hindi, rhymes: false);
    await repo.saveGame(game);
    await repo.saveSettings(settings);

    final reloaded = PrefsGameRepository(await SharedPreferences.getInstance());
    expect(reloaded.loadGame(), game);
    expect(reloaded.loadSettings(), settings);
  });

  test('ignores unreadable saved data', () async {
    final repo = await repository({
      PrefsGameRepository.gameKey: '{not json',
      PrefsGameRepository.settingsKey: '[1, 2]',
    });
    expect(repo.loadGame(), isNull);
    expect(repo.loadSettings(), const CallerSettings());
  });
}
