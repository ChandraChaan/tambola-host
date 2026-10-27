import 'package:flutter/material.dart';

import '../../../core/l10n.dart';
import '../../game/domain/ticket.dart';

/// Draws a ticket as a 3 × 9 grid.
///
/// Numbers in [marked] are filled in (already called); numbers in
/// [highlighted] get a thick outline (they count for the prize being checked).
class TicketView extends StatelessWidget {
  const TicketView({
    required this.ticket,
    required this.gameCode,
    this.marked = const {},
    this.highlighted = const {},
    super.key,
  });

  final Ticket ticket;
  final String gameCode;
  final Set<int> marked;
  final Set<int> highlighted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: l10n.ticketSemantics(ticket.number, gameCode),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.ticketHeading(ticket.number),
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    l10n.gameCodeLabel(gameCode),
                    style: text.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: Ticket.columns / Ticket.rows,
                child: Column(
                  children: [
                    for (var r = 0; r < Ticket.rows; r++)
                      Expanded(
                        child: Row(
                          children: [
                            for (var c = 0; c < Ticket.columns; c++)
                              Expanded(
                                child: _TicketCell(
                                  number: ticket.cell(r, c),
                                  marked: marked.contains(ticket.cell(r, c)),
                                  highlighted: highlighted.contains(
                                    ticket.cell(r, c),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketCell extends StatelessWidget {
  const _TicketCell({
    required this.number,
    required this.marked,
    required this.highlighted,
  });

  final int number;
  final bool marked;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final blank = number == 0;
    final background = blank
        ? scheme.surfaceContainerHigh
        : marked
        ? scheme.primary
        : scheme.surface;
    final foreground = marked ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      label: blank
          ? l10n.ticketCellBlank
          : marked
          ? l10n.ticketCellMarked(number)
          : '$number',
      child: ExcludeSemantics(
        child: Container(
          key: blank
              ? null
              : ValueKey('cell-$number-${marked ? 'marked' : 'open'}'),
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: highlighted ? scheme.tertiary : scheme.outlineVariant,
              width: highlighted ? 3 : 1,
            ),
          ),
          child: blank
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: FittedBox(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: foreground,
                        fontWeight: marked ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
