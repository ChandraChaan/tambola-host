import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/ticket_generator.dart';
import 'package:tambola_host/features/tickets/data/ticket_pdf.dart';
import 'package:tambola_host/features/tickets/domain/ticket_printer.dart';

final TicketLabels _labels = (
  documentTitle: 'Tickets',
  ticketHeading: (n) => 'Ticket $n',
  gameCode: (code) => 'Game $code',
  pageFooter: (first, last) => 'Tickets $first-$last',
);

void main() {
  test('one page per strip of six, last page partly filled', () async {
    final bytes = await buildTicketsPdf(
      tickets: TicketGenerator('K7QX2M').tickets(14),
      gameCode: 'K7QX2M',
      labels: _labels,
      compress: false,
    );
    final text = latin1.decode(bytes);
    expect(text, startsWith('%PDF'));
    expect(text, contains('/Count 3'));
  });

  test('a single ticket still makes a valid one-page PDF', () async {
    final bytes = await buildTicketsPdf(
      tickets: [TicketGenerator('K7QX2M').ticket(1)],
      gameCode: 'K7QX2M',
      labels: _labels,
      compress: false,
    );
    expect(latin1.decode(bytes), contains('/Count 1'));
  });
}
