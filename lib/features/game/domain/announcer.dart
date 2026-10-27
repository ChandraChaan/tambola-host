import 'settings.dart';

/// Speaks a called number aloud.
abstract interface class Announcer {
  Future<void> speak(String text, VoiceLanguage language);
  Future<void> stop();
}
