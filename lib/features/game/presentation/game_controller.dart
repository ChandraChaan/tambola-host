import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/call_phrases.dart';
import '../domain/game.dart';
import '../domain/game_code.dart';
import '../domain/ticket_generator.dart';
import 'providers.dart';
import 'settings_controller.dart';

final gameProvider = NotifierProvider<GameController, Game>(GameController.new);

/// Tickets for the current game code.
final ticketGeneratorProvider = Provider<TicketGenerator>(
  (ref) => TicketGenerator(ref.watch(gameProvider.select((g) => g.code))),
);

class GameController extends Notifier<Game> {
  @override
  Game build() {
    final saved = ref.read(gameRepositoryProvider).loadGame();
    if (saved != null) return saved;
    final game = _create(ticketCount: Game.defaultTicketCount);
    _save(game);
    return game;
  }

  /// Calls the next number and announces it.
  void callNext() {
    if (state.isFinished) return;
    state = state.callNext();
    _save(state);
    announceCurrent();
  }

  /// Takes back the last call. Calling "next" again gives the same number.
  void undo() {
    if (state.calledCount == 0) return;
    state = state.undo();
    _save(state);
    unawaited(ref.read(announcerProvider).stop());
  }

  /// Says the current number again.
  void announceCurrent() {
    final number = state.current;
    if (number == null) return;
    final settings = ref.read(settingsProvider);
    final text = CallPhrases.spoken(
      number,
      settings.voice,
      rhyme: settings.rhymes,
    );
    unawaited(ref.read(announcerProvider).speak(text, settings.voice));
  }

  /// Starts a fresh game. Pass [code] to reuse the tickets of an earlier game.
  void newGame({required int ticketCount, String? code}) {
    state = _create(ticketCount: ticketCount, code: code);
    _save(state);
    unawaited(ref.read(announcerProvider).stop());
  }

  void setTicketCount(int count) {
    state = state.copyWith(ticketCount: count.clamp(1, Game.maxTickets));
    _save(state);
  }

  Game _create({required int ticketCount, String? code}) {
    final nextInt = ref.read(randomProvider);
    return Game(
      code: code ?? GameCode.generate(nextInt),
      callSeed: nextInt(0x100000000),
      ticketCount: ticketCount,
      startedAt: ref.read(clockProvider)().toUtc(),
    );
  }

  void _save(Game game) =>
      unawaited(ref.read(gameRepositoryProvider).saveGame(game));
}
