import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/domain/settings.dart';
import '../../game/presentation/auto_play_controller.dart';
import '../../game/presentation/game_controller.dart';
import '../../game/presentation/settings_controller.dart';

class CallerControls extends ConsumerWidget {
  const CallerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (count, finished) = ref.watch(
      gameProvider.select((g) => (g.calledCount, g.isFinished)),
    );
    final playing = ref.watch(autoPlayProvider);
    final interval = ref.watch(
      settingsProvider.select((s) => s.intervalSeconds),
    );
    final game = ref.read(gameProvider.notifier);
    final autoPlay = ref.read(autoPlayProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          key: const Key('next-number'),
          onPressed: finished ? null : game.callNext,
          icon: const Icon(Icons.skip_next),
          label: Text(l10n.nextNumber),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(64),
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            FilledButton.tonalIcon(
              key: const Key('auto-play'),
              onPressed: finished && !playing ? null : autoPlay.toggle,
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              label: Text(playing ? l10n.pause : l10n.autoPlay),
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            ),
            IconButton.outlined(
              key: const Key('undo'),
              tooltip: l10n.undoLast,
              onPressed: count == 0 ? null : game.undo,
              icon: const Icon(Icons.undo),
            ),
            IconButton.outlined(
              key: const Key('repeat'),
              tooltip: l10n.repeatCall,
              onPressed: count == 0 ? null : game.announceCurrent,
              icon: const Icon(Icons.record_voice_over_outlined),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer_outlined),
            Expanded(
              child: Slider(
                key: const Key('interval'),
                value: interval.toDouble(),
                min: CallerSettings.minInterval.toDouble(),
                max: CallerSettings.maxInterval.toDouble(),
                divisions:
                    CallerSettings.maxInterval - CallerSettings.minInterval,
                label: l10n.intervalLabel(interval),
                semanticFormatterCallback: (v) => l10n.intervalLabel(v.round()),
                onChanged: (v) =>
                    ref.read(settingsProvider.notifier).setInterval(v.round()),
              ),
            ),
            Text(l10n.intervalLabel(interval)),
          ],
        ),
      ],
    );
  }
}
