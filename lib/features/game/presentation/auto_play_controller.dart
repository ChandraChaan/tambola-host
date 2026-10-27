import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_controller.dart';
import 'settings_controller.dart';

final autoPlayProvider = NotifierProvider<AutoPlayController, bool>(
  AutoPlayController.new,
);

/// Calls a number every few seconds while on.
///
/// Any call (automatic or a manual "next") restarts the countdown, an undo or
/// a new game pauses auto-play, and it stops by itself after the 90th number.
class AutoPlayController extends Notifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen(gameProvider, (previous, next) {
      if (!state) return;
      final restarted = previous != null && previous.code != next.code;
      if (restarted || next.isFinished) {
        stop();
      } else if (previous != null && next.calledCount < previous.calledCount) {
        stop();
      } else {
        _schedule();
      }
    });
    ref.listen(settingsProvider.select((s) => s.intervalSeconds), (_, _) {
      if (state) _schedule();
    });
    return false;
  }

  /// Starts auto-play with an immediate call.
  void start() {
    if (state || ref.read(gameProvider).isFinished) return;
    state = true;
    ref.read(gameProvider.notifier).callNext();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = false;
  }

  void toggle() => state ? stop() : start();

  void _schedule() {
    _timer?.cancel();
    final seconds = ref.read(settingsProvider).intervalSeconds;
    _timer = Timer(Duration(seconds: seconds), () {
      if (state) ref.read(gameProvider.notifier).callNext();
    });
  }
}
