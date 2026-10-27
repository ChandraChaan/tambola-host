import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/claims.dart';
import 'package:tambola_host/features/game/domain/ticket_generator.dart';

import '../support/fakes.dart';

Future<void> openClaims(WidgetTester tester) async {
  await tester.tap(find.text('Claims'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a full house after every call is valid', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 90));
    await pumpApp(tester, repository: repository);
    await openClaims(tester);

    expect(
      find.text('Enter the ticket number the player is holding.'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const Key('claim-ticket')), '7');
    await tester.tap(find.byKey(const ValueKey('prize-fullHouse')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('verdict-ClaimValid')), findsOneWidget);
    expect(find.text('Valid claim'), findsOneWidget);
    expect(find.text('Ticket 7'), findsOneWidget);
  });

  testWidgets('a claim before enough calls is rejected, then becomes valid', (
    tester,
  ) async {
    final game = sampleGame(calledCount: 0);
    final ticket = TicketGenerator(game.code).ticket(3);
    final topLine = ClaimRules.numbersFor(ticket, Prize.topLine);
    // The call at which the top line of ticket 3 completes.
    final completesAt = topLine
        .map((n) => game.callOrder.indexOf(n) + 1)
        .reduce((a, b) => a > b ? a : b);
    final repository = FakeGameRepository(
      game: sampleGame(calledCount: completesAt - 1),
    );
    await pumpApp(tester, repository: repository);
    await openClaims(tester);

    await tester.enterText(find.byKey(const Key('claim-ticket')), '3');
    await tester.tap(find.byKey(const ValueKey('prize-topLine')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('verdict-ClaimNotYet')), findsOneWidget);
    final missing = game.callOrder[completesAt - 1];
    expect(find.text('Still needs: $missing'), findsOneWidget);
    expect(find.byKey(ValueKey('cell-$missing-open')), findsOneWidget);

    // The host calls the next number; the open check updates by itself.
    await tester.tap(find.text('Caller'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('next-number')));
    await tester.pumpAndSettle();
    await openClaims(tester);

    expect(find.byKey(const Key('verdict-ClaimValid')), findsOneWidget);
    expect(
      find.text('Completed on call $completesAt with number $missing.'),
      findsOneWidget,
    );
    expect(find.byKey(ValueKey('cell-$missing-marked')), findsOneWidget);
  });

  testWidgets('an unknown ticket number is explained', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 10));
    await pumpApp(tester, repository: repository);
    await openClaims(tester);

    await tester.enterText(find.byKey(const Key('claim-ticket')), '999');
    await tester.pumpAndSettle();
    expect(
      find.text('Ticket 999 is not in this game. Tickets run from 1 to 60.'),
      findsOneWidget,
    );
  });

  testWidgets('tickets screen lists tickets with the game code', (
    tester,
  ) async {
    final repository = FakeGameRepository(game: sampleGame());
    await pumpApp(tester, repository: repository);
    await tester.tap(find.text('Tickets'));
    await tester.pumpAndSettle();

    expect(find.text('60 tickets for game K7QX2M'), findsOneWidget);
    expect(find.text('Ticket 1'), findsOneWidget);
    // Pinned in ticket_generator_test: ticket 1 of K7QX2M starts with 2, 15.
    expect(find.byKey(const ValueKey('cell-2-open')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ticket-count')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('ticket-count-field')), '12');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('12 tickets for game K7QX2M'), findsOneWidget);
    expect(repository.game!.ticketCount, 12);
  });
}
