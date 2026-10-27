import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../game/domain/claims.dart';
import '../../game/domain/ticket.dart';
import '../../game/presentation/game_controller.dart';

typedef ClaimQuery = ({int? ticketNumber, Prize prize});

final claimQueryProvider = NotifierProvider<ClaimQueryController, ClaimQuery>(
  ClaimQueryController.new,
);

class ClaimQueryController extends Notifier<ClaimQuery> {
  @override
  ClaimQuery build() => (ticketNumber: null, prize: Prize.earlyFive);

  void setTicket(int? number) =>
      state = (ticketNumber: number, prize: state.prize);

  void setPrize(Prize prize) =>
      state = (ticketNumber: state.ticketNumber, prize: prize);
}

/// The ticket being checked and the verdict, kept up to date as numbers are
/// called. `null` until a ticket number is entered.
typedef ClaimCheck = ({Ticket? ticket, ClaimResult result});

final claimCheckProvider = Provider<ClaimCheck?>((ref) {
  final query = ref.watch(claimQueryProvider);
  final number = query.ticketNumber;
  if (number == null) return null;
  final game = ref.watch(gameProvider);
  final generator = ref.watch(ticketGeneratorProvider);
  final result = ClaimRules.checkNumber(
    number,
    query.prize,
    game,
    generator.ticket,
  );
  return (
    ticket: result is ClaimUnknownTicket ? null : generator.ticket(number),
    result: result,
  );
});
