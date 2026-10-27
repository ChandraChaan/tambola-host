import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/presentation/game_controller.dart';

/// The five calls before the current one, newest first.
class PreviousCalls extends ConsumerWidget {
  const PreviousCalls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final numbers = ref.watch(gameProvider).recent(6).skip(1).toList();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.previousCalls, style: text.titleSmall),
        const SizedBox(height: 8),
        if (numbers.isEmpty)
          Text(l10n.noPreviousCalls, style: text.bodyMedium)
        else
          Wrap(
            key: const Key('previous-calls'),
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in numbers)
                CircleAvatar(
                  key: ValueKey('previous-$n'),
                  radius: 26,
                  backgroundColor: scheme.secondaryContainer,
                  foregroundColor: scheme.onSecondaryContainer,
                  child: Text('$n', style: text.titleLarge),
                ),
            ],
          ),
      ],
    );
  }
}
