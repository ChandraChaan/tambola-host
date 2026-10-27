import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/presentation/game_controller.dart';

/// The 1–90 board: ten numbers per row, called numbers filled in.
class NumberBoard extends ConsumerWidget {
  const NumberBoard({super.key});

  static const int columns = 10;
  static const int rows = 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = math.min(
          constraints.maxWidth / columns,
          constraints.maxHeight / rows,
        );
        return Center(
          child: SizedBox(
            width: cell * columns,
            height: cell * rows,
            child: Column(
              children: [
                for (var r = 0; r < rows; r++)
                  Expanded(
                    child: Row(
                      children: [
                        for (var c = 0; c < columns; c++)
                          Expanded(
                            child: _BoardCell(
                              number: r * columns + c + 1,
                              called: game.isCalled(r * columns + c + 1),
                              current: game.current == r * columns + c + 1,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BoardCell extends StatelessWidget {
  const _BoardCell({
    required this.number,
    required this.called,
    required this.current,
  });

  final int number;
  final bool called;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final (background, foreground) = switch ((called, current)) {
      (_, true) => (scheme.tertiary, scheme.onTertiary),
      (true, _) => (scheme.primary, scheme.onPrimary),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    return Semantics(
      label: called
          ? l10n.boardCellCalled(number)
          : l10n.boardCellNotCalled(number),
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: DecoratedBox(
            key: ValueKey('board-$number-${called ? 'called' : 'open'}'),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(6),
              border: current
                  ? Border.all(color: scheme.onSurface, width: 3)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: foreground,
                    // Weight as well as colour, so called numbers stand out
                    // for colour-blind players too.
                    fontWeight: called ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
