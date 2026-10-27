import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/claims.dart';
import 'package:tambola_host/features/game/domain/game.dart';
import 'package:tambola_host/features/game/domain/ticket.dart';
import 'package:tambola_host/features/game/domain/ticket_generator.dart';

// Rows: [2 15 26 55 71], [3 18 41 68 76], [33 45 69 77 85]
final _ticket = Ticket(
  number: 1,
  cells: const [
    2, 15, 26, 0, 0, 55, 0, 71, 0, //
    3, 18, 0, 0, 41, 0, 68, 76, 0, //
    0, 0, 0, 33, 45, 0, 69, 77, 85, //
  ],
);

/// A game whose calls so far are exactly [calls], in that order.
Game _gameCalling(List<int> calls) => _ScriptedGame(calls);

/// Replaces the shuffled call order with a scripted one.
class _ScriptedGame extends Game {
  _ScriptedGame(this.script)
    : super(
        code: 'K7QX2M',
        callSeed: 1,
        ticketCount: 60,
        calledCount: script.length,
        startedAt: DateTime.utc(2026),
      );

  final List<int> script;

  late final List<int> _order = [
    ...script,
    for (var n = 1; n <= 90; n++)
      if (!script.contains(n)) n,
  ];

  @override
  List<int> get callOrder => _order;
}

void main() {
  group('numbersFor', () {
    test('lines, corners and full house', () {
      expect(ClaimRules.numbersFor(_ticket, Prize.topLine), [
        2,
        15,
        26,
        55,
        71,
      ]);
      expect(ClaimRules.numbersFor(_ticket, Prize.middleLine), [
        3,
        18,
        41,
        68,
        76,
      ]);
      expect(ClaimRules.numbersFor(_ticket, Prize.bottomLine), [
        33,
        45,
        69,
        77,
        85,
      ]);
      expect(ClaimRules.numbersFor(_ticket, Prize.corners), [2, 71, 33, 85]);
      expect(ClaimRules.numbersFor(_ticket, Prize.fullHouse), hasLength(15));
    });
  });

  group('check', () {
    test('top line is valid once all five are called', () {
      final result = ClaimRules.check(
        _ticket,
        Prize.topLine,
        _gameCalling([2, 15, 90, 26, 55, 71]),
      );
      expect(
        result,
        const ClaimValid(
          completedOnCall: 6,
          completingNumber: 71,
          callsSince: 0,
        ),
      );
    });

    test('a line one short is not valid and lists what is missing', () {
      final result = ClaimRules.check(
        _ticket,
        Prize.topLine,
        _gameCalling([2, 15, 26, 55]),
      );
      expect(result, isA<ClaimNotYet>());
      final notYet = result as ClaimNotYet;
      expect(notYet.missing, [71]);
      expect(notYet.stillNeeded, 1);
    });

    test('numbers on other rows do not count towards a line', () {
      final result = ClaimRules.check(
        _ticket,
        Prize.middleLine,
        _gameCalling([2, 15, 26, 55, 71, 3, 18, 41, 68]),
      );
      expect((result as ClaimNotYet).missing, [76]);
    });

    test('early five needs any five numbers from the ticket', () {
      expect(
        ClaimRules.check(
          _ticket,
          Prize.earlyFive,
          _gameCalling([2, 3, 4, 33, 85]),
        ),
        isA<ClaimNotYet>().having((r) => r.stillNeeded, 'stillNeeded', 1),
      );
      expect(
        ClaimRules.check(
          _ticket,
          Prize.earlyFive,
          _gameCalling([2, 3, 4, 33, 85, 90, 77, 1]),
        ),
        const ClaimValid(
          completedOnCall: 7,
          completingNumber: 77,
          callsSince: 1,
        ),
      );
    });

    test('corners need exactly the four corner numbers', () {
      expect(
        ClaimRules.check(
          _ticket,
          Prize.corners,
          _gameCalling([2, 71, 33, 15, 45]),
        ),
        isA<ClaimNotYet>().having((r) => r.missing, 'missing', [85]),
      );
      expect(
        ClaimRules.check(_ticket, Prize.corners, _gameCalling([85, 2, 71, 33])),
        const ClaimValid(
          completedOnCall: 4,
          completingNumber: 33,
          callsSince: 0,
        ),
      );
    });

    test('a late claim reports how many calls ago it was complete', () {
      final result = ClaimRules.check(
        _ticket,
        Prize.bottomLine,
        _gameCalling([33, 45, 69, 77, 85, 1, 4, 5]),
      );
      expect(
        result,
        const ClaimValid(
          completedOnCall: 5,
          completingNumber: 85,
          callsSince: 3,
        ),
      );
    });

    test('full house is complete exactly when the last number arrives', () {
      final numbers = _ticket.numbers;
      final almost = ClaimRules.check(
        _ticket,
        Prize.fullHouse,
        _gameCalling(numbers.sublist(0, 14)),
      );
      expect((almost as ClaimNotYet).missing, [numbers.last]);
      expect(
        ClaimRules.check(_ticket, Prize.fullHouse, _gameCalling(numbers)),
        isA<ClaimValid>(),
      );
    });

    test('nothing is valid before any call', () {
      for (final prize in Prize.values) {
        expect(
          ClaimRules.check(_ticket, prize, _gameCalling([])),
          isA<ClaimNotYet>(),
        );
      }
    });

    test('after all 90 calls every prize is valid on every ticket', () {
      final game = Game(
        code: 'K7QX2M',
        callSeed: 11,
        ticketCount: 60,
        calledCount: 90,
        startedAt: DateTime.utc(2026),
      );
      final generator = TicketGenerator(game.code);
      for (final ticket in generator.tickets(60)) {
        for (final prize in Prize.values) {
          expect(ClaimRules.check(ticket, prize, game), isA<ClaimValid>());
        }
      }
    });
  });

  group('checkNumber', () {
    test('rejects ticket numbers outside the game', () {
      final game = _gameCalling([1, 2, 3]);
      final generator = TicketGenerator(game.code);
      expect(
        ClaimRules.checkNumber(0, Prize.topLine, game, generator.ticket),
        isA<ClaimUnknownTicket>(),
      );
      expect(
        ClaimRules.checkNumber(61, Prize.topLine, game, generator.ticket),
        isA<ClaimUnknownTicket>(),
      );
      expect(
        ClaimRules.checkNumber(60, Prize.topLine, game, generator.ticket),
        isA<ClaimNotYet>(),
      );
    });
  });
}
