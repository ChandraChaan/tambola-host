import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/core/seeded_random.dart';
import 'package:tambola_host/features/game/domain/game_code.dart';
import 'package:tambola_host/features/game/domain/ticket.dart';
import 'package:tambola_host/features/game/domain/ticket_generator.dart';

import '../support/ticket_rules.dart';

void main() {
  group('strip generation', () {
    test('every ticket is valid and every strip uses 1–90 once '
        '(2,000 strips)', () {
      for (var seed = 0; seed < 2000; seed++) {
        final strip = TicketGenerator.generateStrip(
          SeededRandom(seed),
          firstTicketNumber: 1,
        );
        expect(strip, hasLength(6));
        for (final ticket in strip) {
          expect(
            ticketProblems(ticket),
            isEmpty,
            reason: 'seed $seed: $ticket',
          );
        }
        final all = [for (final t in strip) ...t.numbers]..sort();
        expect(all, List<int>.generate(90, (i) => i + 1), reason: 'seed $seed');
      }
    });

    test('tickets are numbered from firstTicketNumber', () {
      final strip = TicketGenerator.generateStrip(
        SeededRandom(1),
        firstTicketNumber: 13,
      );
      expect([for (final t in strip) t.number], [13, 14, 15, 16, 17, 18]);
    });
  });

  group('TicketGenerator', () {
    test('many game codes give valid tickets', () {
      final random = SeededRandom(2026);
      for (var i = 0; i < 200; i++) {
        final generator = TicketGenerator(GameCode.generate(random.nextInt));
        for (final ticket in generator.tickets(12)) {
          expect(ticketProblems(ticket), isEmpty, reason: '$ticket');
        }
      }
    });

    test('the same code and number always give the same ticket', () {
      final first = TicketGenerator('K7QX2M');
      final second = TicketGenerator('K7QX2M');
      // Ask in a different order: results must not depend on cache order.
      final late = second.ticket(600);
      final early = second.ticket(1);
      expect(first.ticket(1), early);
      expect(first.ticket(600), late);
      expect(first.tickets(30), second.tickets(30));
    });

    test('pins a known ticket so generation never silently changes', () {
      // If this fails, tickets already printed by hosts would no longer
      // match the claim checker. Only update it on purpose.
      final ticket = TicketGenerator('K7QX2M').ticket(1);
      expect(ticketProblems(ticket), isEmpty);
      expect(ticket.cells, _pinnedTicket);
    });

    test('different codes give different tickets', () {
      expect(
        TicketGenerator('AAAAAA').tickets(6),
        isNot(TicketGenerator('AAAAAB').tickets(6)),
      );
    });

    test('tickets in the same strip never share a number', () {
      final generator = TicketGenerator('HOUSIE');
      for (var strip = 0; strip < 20; strip++) {
        final numbers = [
          for (var n = 1; n <= 6; n++)
            ...generator.ticket(strip * 6 + n).numbers,
        ];
        expect(numbers.toSet(), hasLength(90));
      }
    });

    test('columnOf matches columnRange', () {
      for (var n = 1; n <= 90; n++) {
        final (low, high) = Ticket.columnRange(Ticket.columnOf(n));
        expect(n, inInclusiveRange(low, high));
      }
    });
  });
}

const List<int> _pinnedTicket = [
  2, 15, 26, 0, 0, 55, 0, 71, 0, //
  3, 18, 0, 0, 41, 0, 68, 76, 0, //
  0, 0, 0, 33, 45, 0, 69, 77, 85, //
];
