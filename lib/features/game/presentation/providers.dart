import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tts_announcer.dart';
import '../domain/announcer.dart';
import '../domain/game_repository.dart';

/// Overridden in `main` with the shared-preferences repository, and in tests
/// with an in-memory fake.
final gameRepositoryProvider = Provider<GameRepository>(
  (ref) =>
      throw UnimplementedError('gameRepositoryProvider must be overridden'),
);

final announcerProvider = Provider<Announcer>((ref) => TtsAnnouncer());

/// Source of randomness for new game codes and call orders: returns a value
/// in `0 .. max - 1`. Tests replace it with a seeded one.
final randomProvider = Provider<int Function(int max)>(
  (ref) => Random.secure().nextInt,
);

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
