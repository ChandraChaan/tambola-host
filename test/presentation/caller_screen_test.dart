import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/call_phrases.dart';

import '../support/fakes.dart';

void main() {
  int currentNumber(WidgetTester tester) {
    final text = tester.widget<Text>(
      find
          .descendant(
            of: find.byType(AnimatedSwitcher),
            matching: find.byType(Text),
          )
          .last,
    );
    return int.parse(text.data!);
  }

  testWidgets('next number calls, marks the board and speaks', (tester) async {
    final repository = FakeGameRepository(game: sampleGame());
    final announcer = FakeAnnouncer();
    await pumpApp(tester, repository: repository, announcer: announcer);

    expect(find.text('Call 1 of 90'), findsNothing);
    await tester.tap(find.byKey(const Key('next-number')));
    await tester.pumpAndSettle();

    final first = sampleGame().callOrder.first;
    expect(currentNumber(tester), first);
    expect(find.text('Call 1 of 90'), findsOneWidget);
    expect(find.byKey(ValueKey('board-$first-called')), findsOneWidget);
    expect(find.text(CallPhrases.rhyme(first)), findsOneWidget);
    expect(announcer.spoken, hasLength(1));
    expect(repository.game!.calledCount, 1);
  });

  testWidgets('the next button stays put between calls', (tester) async {
    // Regression: the rhyme line used to appear after the first call and
    // push the button down, so quick repeated taps missed it.
    await pumpApp(tester, repository: FakeGameRepository(game: sampleGame()));
    final next = find.byKey(const Key('next-number'));
    final before = tester.getCenter(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(tester.getCenter(next), before);
  });

  testWidgets('previous calls and undo', (tester) async {
    final repository = FakeGameRepository(game: sampleGame());
    await pumpApp(tester, repository: repository);
    final order = sampleGame().callOrder;

    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byKey(const Key('next-number')));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(currentNumber(tester), order[6]);
    // Five previous calls, newest first, not including the current one.
    for (final n in order.sublist(1, 6)) {
      expect(find.byKey(ValueKey('previous-$n')), findsOneWidget);
    }
    expect(find.byKey(ValueKey('previous-${order[0]}')), findsNothing);

    await tester.tap(find.byKey(const Key('undo')));
    await tester.pumpAndSettle();
    expect(currentNumber(tester), order[5]);
    expect(find.byKey(ValueKey('board-${order[6]}-open')), findsOneWidget);
  });

  testWidgets('auto-play calls on a timer until paused', (tester) async {
    final repository = FakeGameRepository(game: sampleGame());
    await pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(const Key('auto-play')));
    await tester.pump();
    expect(repository.game!.calledCount, 1);
    expect(find.text('Pause'), findsOneWidget);

    await tester.pump(const Duration(seconds: 8));
    expect(repository.game!.calledCount, 2);
    await tester.pump(const Duration(seconds: 8));
    expect(repository.game!.calledCount, 3);

    await tester.tap(find.byKey(const Key('auto-play')));
    await tester.pump(const Duration(seconds: 30));
    expect(repository.game!.calledCount, 3);
    expect(find.text('Auto-play'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('auto-play stops after the 90th number', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 88));
    await pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(const Key('auto-play')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 8));
    expect(repository.game!.calledCount, 90);
    await tester.pump(const Duration(seconds: 8));
    await tester.pumpAndSettle();
    expect(find.text('All 90 numbers have been called'), findsOneWidget);
    expect(find.text('Auto-play'), findsOneWidget);
    final next = tester.widget<FilledButton>(
      find.byKey(const Key('next-number')),
    );
    expect(next.onPressed, isNull);
  });

  testWidgets('new game dialog starts over with the same code', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 20));
    await pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(const Key('new-game')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('new-game-count')), '24');
    await tester.enterText(find.byKey(const Key('new-game-code')), 'k7qx2m');
    await tester.tap(find.byKey(const Key('new-game-start')));
    await tester.pumpAndSettle();

    final game = repository.game!;
    expect(game.code, 'K7QX2M');
    expect(game.ticketCount, 24);
    expect(game.calledCount, 0);
  });

  testWidgets('new game dialog rejects a bad code', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 20));
    await pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(const Key('new-game')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('new-game-code')), 'OOPS');
    await tester.tap(find.byKey(const Key('new-game-start')));
    await tester.pumpAndSettle();

    expect(
      find.text('Codes are 6 letters and digits, like K7QX2M'),
      findsOneWidget,
    );
    expect(repository.game!.calledCount, 20);
  });

  testWidgets('works on a narrow phone screen', (tester) async {
    final repository = FakeGameRepository(game: sampleGame(calledCount: 3));
    await pumpApp(tester, repository: repository, size: const Size(360, 740));

    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('next-number')));
    await tester.tap(find.byKey(const Key('next-number')));
    await tester.pumpAndSettle();
    expect(repository.game!.calledCount, 4);
    expect(tester.takeException(), isNull);
  });
}
