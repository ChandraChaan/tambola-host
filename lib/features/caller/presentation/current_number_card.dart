import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/domain/call_phrases.dart';
import '../../game/presentation/game_controller.dart';
import '../../game/presentation/settings_controller.dart';

/// The number just called, as large as the space allows.
class CurrentNumberCard extends ConsumerWidget {
  const CurrentNumberCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (current, count, finished) = ref.watch(
      gameProvider.select((g) => (g.current, g.calledCount, g.isFinished)),
    );
    final rhymes = ref.watch(settingsProvider.select((s) => s.rhymes));
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final rhymeStyle = text.titleLarge?.copyWith(
      fontStyle: FontStyle.italic,
      color: scheme.onPrimaryContainer,
    );

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _SteadyText(
              switch ((current, finished)) {
                (null, _) => l10n.waitingForFirstCall,
                (_, true) => l10n.allCalled,
                _ => l10n.callProgress(count),
              },
              style: text.titleMedium?.copyWith(
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.6,
              child: Semantics(
                liveRegion: true,
                label: current == null
                    ? null
                    : l10n.currentNumberSemantics(current),
                child: ExcludeSemantics(
                  child: current == null
                      ? Icon(
                          Icons.campaign_outlined,
                          size: 96,
                          color: scheme.onPrimaryContainer,
                        )
                      : FittedBox(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Text(
                              '$current',
                              key: ValueKey(current),
                              style: text.displayLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onPrimaryContainer,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            if (rhymes)
              _SteadyText(
                current == null ? '' : CallPhrases.rhyme(current),
                key: const Key('current-rhyme'),
                style: rhymeStyle,
              ),
          ],
        ),
      ),
    );
  }
}

/// Centered text that always takes two lines of height, so the buttons
/// below don't move when the text changes between calls.
class _SteadyText extends StatelessWidget {
  const _SteadyText(this.text, {required this.style, super.key});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ExcludeSemantics(child: Text('\n', style: style)),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ],
    );
  }
}
