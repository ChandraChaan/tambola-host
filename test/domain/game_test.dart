import 'package:flutter_test/flutter_test.dart';
import 'package:tambola_host/features/game/domain/game.dart';

Game _game(int seed, {int called = 0}) => Game(
  code: 'K7QX2M',
  callSeed: seed,
  ticketCount: 60,
  calledCount: called,
  startedAt: DateTime.utc(2026),
);

void main() {
  test('the call order is a permutation of 1–90 for many seeds', () {
    for (var seed = 0; seed < 1000; seed++) {
      final order = _game(seed).callOrder;
      expect(order, hasLength(90));
      expect(order.toSet(), hasLength(90));
      expect(order.every((n) => n >= 1 && n <= 90), isTrue);
    }
  });

  test('calling never repeats a number and stops after 90', () {
    var game = _game(5);
    final seen = <int>{};
    for (var i = 0; i < 90; i++) {
      game = game.callNext();
      expect(
        seen.add(game.current!),
        isTrue,
        reason: 'repeat at call ${i + 1}',
      );
    }
    expect(game.isFinished, isTrue);
    expect(game.callNext(), same(game));
    expect(seen, hasLength(90));
  });

  test('same seed gives the same calls; different seeds differ', () {
    expect(_game(1).callOrder, _game(1).callOrder);
    expect(_game(1).callOrder, isNot(_game(2).callOrder));
  });

  test('undo takes back the last call and next calls it again', () {
    final game = _game(9, called: 10);
    final undone = game.undo();
    expect(undone.calledCount, 9);
    expect(undone.isCalled(game.current!), isFalse);
    expect(undone.callNext().current, game.current);
    expect(_game(9).undo().calledCount, 0);
  });

  test('called, positions and recent agree', () {
    final game = _game(3, called: 8);
    expect(game.called, game.callOrder.take(8));
    expect(game.recent(), game.callOrder.take(8).toList().reversed.take(5));
    expect(game.recent(), hasLength(5));
    for (var i = 0; i < 8; i++) {
      expect(game.callPosition[game.called[i]], i + 1);
    }
    expect(_game(3).current, isNull);
    expect(_game(3).recent(), isEmpty);
  });

  test('JSON round trip', () {
    final game = _game(77, called: 33);
    expect(Game.fromJson(game.toJson()), game);
  });

  test('fromJson rejects broken data', () {
    final good = _game(1).toJson();
    expect(Game.fromJson({...good, 'calledCount': 91}), isNull);
    expect(Game.fromJson({...good, 'calledCount': -1}), isNull);
    expect(Game.fromJson({...good, 'ticketCount': 0}), isNull);
    expect(Game.fromJson({...good, 'code': 12}), isNull);
    expect(Game.fromJson({...good, 'startedAt': 'yesterday'}), isNull);
    expect(Game.fromJson(<String, Object?>{}), isNull);
  });
}
