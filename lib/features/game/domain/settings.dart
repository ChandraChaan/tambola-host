/// Language used to call numbers aloud.
enum VoiceLanguage { off, english, hindi }

/// Light, dark or follow the device.
enum ThemeChoice { system, light, dark }

/// The host's caller preferences.
class CallerSettings {
  const CallerSettings({
    this.intervalSeconds = defaultInterval,
    this.voice = VoiceLanguage.english,
    this.rhymes = true,
    this.theme = ThemeChoice.system,
  });

  static const int minInterval = 3;
  static const int maxInterval = 30;
  static const int defaultInterval = 8;

  /// Seconds between calls while auto-play is on.
  final int intervalSeconds;
  final VoiceLanguage voice;

  /// Whether to show and say the rhyming call for each number.
  final bool rhymes;
  final ThemeChoice theme;

  CallerSettings copyWith({
    int? intervalSeconds,
    VoiceLanguage? voice,
    bool? rhymes,
    ThemeChoice? theme,
  }) => CallerSettings(
    intervalSeconds: intervalSeconds ?? this.intervalSeconds,
    voice: voice ?? this.voice,
    rhymes: rhymes ?? this.rhymes,
    theme: theme ?? this.theme,
  );

  Map<String, Object> toJson() => {
    'intervalSeconds': intervalSeconds,
    'voice': voice.name,
    'rhymes': rhymes,
    'theme': theme.name,
  };

  /// Reads saved settings, falling back to defaults for anything missing.
  factory CallerSettings.fromJson(Map<String, Object?> json) {
    const defaults = CallerSettings();
    final interval = json['intervalSeconds'];
    final rhymes = json['rhymes'];
    return CallerSettings(
      intervalSeconds: interval is int
          ? interval.clamp(minInterval, maxInterval)
          : defaults.intervalSeconds,
      voice: VoiceLanguage.values.asNameMap()[json['voice']] ?? defaults.voice,
      rhymes: rhymes is bool ? rhymes : defaults.rhymes,
      theme: ThemeChoice.values.asNameMap()[json['theme']] ?? defaults.theme,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CallerSettings &&
      other.intervalSeconds == intervalSeconds &&
      other.voice == voice &&
      other.rhymes == rhymes &&
      other.theme == theme;

  @override
  int get hashCode => Object.hash(intervalSeconds, voice, rhymes, theme);
}
