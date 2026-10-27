import 'game.dart';
import 'settings.dart';

/// Stores the current game and the caller settings on this device.
abstract interface class GameRepository {
  Game? loadGame();
  Future<void> saveGame(Game game);
  CallerSettings loadSettings();
  Future<void> saveSettings(CallerSettings settings);
}
