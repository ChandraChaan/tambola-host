import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/app.dart';
import 'package:tambola_host/features/game/domain/ticket.dart';
import 'package:tambola_host/features/tickets/domain/ticket_printer.dart';
import 'package:tambola_host/features/tickets/presentation/ticket_printer_provider.dart';

import '../support/fakes.dart';

class FakeTicketPrinter implements TicketPrinter {
  FakeTicketPrinter({this.fail = false});

  final bool fail;
  List<Ticket>? tickets;
  String? gameCode;
  TicketLabels? labels;

  @override
  Future<void> printTickets({
    required List<Ticket> tickets,
    required String gameCode,
    required TicketLabels labels,
  }) async {
    if (fail) throw StateError('printer unavailable');
    this.tickets = tickets;
    this.gameCode = gameCode;
    this.labels = labels;
  }
}

Future<void> pumpTickets(WidgetTester tester, FakeTicketPrinter printer) async {
  tester.view
    ..physicalSize = const Size(1280, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...testOverrides(
          repository: FakeGameRepository(game: sampleGame(ticketCount: 18)),
        ),
        ticketPrinterProvider.overrideWithValue(printer),
      ],
      child: const TambolaHostApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Tickets'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('print sends every ticket in play with the game code', (
    tester,
  ) async {
    final printer = FakeTicketPrinter();
    await pumpTickets(tester, printer);

    await tester.tap(find.byKey(const Key('print-tickets')));
    await tester.pumpAndSettle();

    expect(printer.gameCode, 'K7QX2M');
    expect(
      [for (final t in printer.tickets!) t.number],
      [for (var n = 1; n <= 18; n++) n],
    );
    expect(printer.labels!.ticketHeading(4), 'Ticket 4');
    expect(printer.labels!.gameCode('K7QX2M'), 'Game K7QX2M');
  });

  testWidgets('a printing error shows a message', (tester) async {
    await pumpTickets(tester, FakeTicketPrinter(fail: true));

    await tester.tap(find.byKey(const Key('print-tickets')));
    await tester.pumpAndSettle();

    expect(
      find.text("Couldn't create the PDF. Please try again."),
      findsOneWidget,
    );
  });
}
