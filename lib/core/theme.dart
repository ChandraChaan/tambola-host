import 'package:flutter/material.dart';

import '../features/game/domain/settings.dart';

/// Marigold orange: festive, and readable on a TV across a room.
const Color _seed = Color(0xFFE8710A);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  );
}

ThemeMode themeModeFor(ThemeChoice choice) => switch (choice) {
  ThemeChoice.system => ThemeMode.system,
  ThemeChoice.light => ThemeMode.light,
  ThemeChoice.dark => ThemeMode.dark,
};
