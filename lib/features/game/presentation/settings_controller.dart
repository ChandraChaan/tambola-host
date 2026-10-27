import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/settings.dart';
import 'providers.dart';

final settingsProvider = NotifierProvider<SettingsController, CallerSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<CallerSettings> {
  @override
  CallerSettings build() => ref.read(gameRepositoryProvider).loadSettings();

  void update(CallerSettings settings) {
    state = settings;
    unawaited(ref.read(gameRepositoryProvider).saveSettings(settings));
  }

  void setInterval(int seconds) => update(
    state.copyWith(
      intervalSeconds: seconds.clamp(
        CallerSettings.minInterval,
        CallerSettings.maxInterval,
      ),
    ),
  );

  void setVoice(VoiceLanguage voice) => update(state.copyWith(voice: voice));

  void setRhymes(bool rhymes) => update(state.copyWith(rhymes: rhymes));

  void setTheme(ThemeChoice theme) => update(state.copyWith(theme: theme));
}
