import 'dart:developer' as developer;

import 'package:flutter_tts/flutter_tts.dart';

import '../domain/announcer.dart';
import '../domain/settings.dart';

/// Speaks calls with the device's (or browser's) text-to-speech voices.
class TtsAnnouncer implements Announcer {
  TtsAnnouncer([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  VoiceLanguage? _language;

  @override
  Future<void> speak(String text, VoiceLanguage language) async {
    if (language == VoiceLanguage.off || text.isEmpty) return;
    try {
      if (_language != language) {
        await _tts.setLanguage(switch (language) {
          VoiceLanguage.hindi => 'hi-IN',
          _ => 'en-IN',
        });
        await _tts.setSpeechRate(0.45);
        _language = language;
      }
      await _tts.stop();
      await _tts.speak(text);
    } on Object catch (e, stack) {
      // Speech is a nice-to-have: a missing voice must never stop the game.
      developer.log('Text-to-speech failed', error: e, stackTrace: stack);
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Object catch (e, stack) {
      developer.log('Text-to-speech stop failed', error: e, stackTrace: stack);
    }
  }
}
