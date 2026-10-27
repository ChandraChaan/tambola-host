import 'dart:convert';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/game.dart';
import '../domain/game_repository.dart';
import '../domain/settings.dart';

/// Keeps the game in the browser's local storage (or app preferences on
/// Android), so a refresh or restart doesn't lose the calls.
class PrefsGameRepository implements GameRepository {
  PrefsGameRepository(this._prefs);

  static const String gameKey = 'game.v1';
  static const String settingsKey = 'settings.v1';

  final SharedPreferences _prefs;

  @override
  Game? loadGame() {
    final json = _readJson(gameKey);
    return json == null ? null : Game.fromJson(json);
  }

  @override
  Future<void> saveGame(Game game) =>
      _prefs.setString(gameKey, jsonEncode(game.toJson()));

  @override
  CallerSettings loadSettings() {
    final json = _readJson(settingsKey);
    return json == null
        ? const CallerSettings()
        : CallerSettings.fromJson(json);
  }

  @override
  Future<void> saveSettings(CallerSettings settings) =>
      _prefs.setString(settingsKey, jsonEncode(settings.toJson()));

  Map<String, Object?>? _readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, Object?> ? decoded : null;
    } on FormatException catch (e, stack) {
      developer.log(
        'Ignoring unreadable saved $key',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }
}
