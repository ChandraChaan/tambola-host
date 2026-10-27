import 'game.dart';
import 'ticket.dart';

/// The prizes a player can claim.
enum Prize { earlyFive, topLine, middleLine, bottomLine, corners, fullHouse }

/// Outcome of checking a claim against the numbers called so far.
sealed class ClaimResult {
  const ClaimResult();
}

/// The claim is good.
///
/// [completedOnCall] is the 1-based call that completed the prize, and
/// [completingNumber] the number called then. If [callsSince] is above zero
/// the prize was already complete before the latest call.
final class ClaimValid extends ClaimResult {
  const ClaimValid({
    required this.completedOnCall,
    required this.completingNumber,
    required this.callsSince,
  });

  final int completedOnCall;
  final int completingNumber;
  final int callsSince;

  @override
  bool operator ==(Object other) =>
      other is ClaimValid &&
      other.completedOnCall == completedOnCall &&
      other.completingNumber == completingNumber &&
      other.callsSince == callsSince;

  @override
  int get hashCode =>
      Object.hash(completedOnCall, completingNumber, callsSince);
}

/// The claim is not complete yet. [missing] lists the numbers still needed
/// (for Early Five, how many more are needed is [stillNeeded]).
final class ClaimNotYet extends ClaimResult {
  const ClaimNotYet({required this.missing, required this.stillNeeded});

  final List<int> missing;
  final int stillNeeded;
}

/// The ticket number is not part of this game.
final class ClaimUnknownTicket extends ClaimResult {
  const ClaimUnknownTicket();
}

abstract final class ClaimRules {
  static const int earlyFiveCount = 5;

  /// The numbers that make up [prize] on [ticket]. For Early Five this is
  /// every number on the ticket, of which any five will do.
  static List<int> numbersFor(Ticket ticket, Prize prize) => switch (prize) {
    Prize.earlyFive || Prize.fullHouse => ticket.numbers,
    Prize.topLine => ticket.rowNumbers(0),
    Prize.middleLine => ticket.rowNumbers(1),
    Prize.bottomLine => ticket.rowNumbers(2),
    Prize.corners => [
      ticket.rowNumbers(0).first,
      ticket.rowNumbers(0).last,
      ticket.rowNumbers(2).first,
      ticket.rowNumbers(2).last,
    ],
  };

  /// How many of [numbersFor] must be called to win [prize].
  static int requiredCount(Ticket ticket, Prize prize) =>
      prize == Prize.earlyFive
      ? earlyFiveCount
      : numbersFor(ticket, prize).length;

  static ClaimResult check(Ticket ticket, Prize prize, Game game) {
    final numbers = numbersFor(ticket, prize);
    final needed = requiredCount(ticket, prize);
    final positions = [for (final n in numbers) ?game.callPosition[n]]..sort();
    if (positions.length < needed) {
      return ClaimNotYet(
        missing: [
          for (final n in numbers)
            if (!game.isCalled(n)) n,
        ],
        stillNeeded: needed - positions.length,
      );
    }
    final completedOnCall = positions[needed - 1];
    return ClaimValid(
      completedOnCall: completedOnCall,
      completingNumber: game.callOrder[completedOnCall - 1],
      callsSince: game.calledCount - completedOnCall,
    );
  }

  /// Checks ticket [ticketNumber] of [game], built by [ticketFor].
  static ClaimResult checkNumber(
    int ticketNumber,
    Prize prize,
    Game game,
    Ticket Function(int) ticketFor,
  ) {
    if (ticketNumber < 1 || ticketNumber > game.ticketCount) {
      return const ClaimUnknownTicket();
    }
    return check(ticketFor(ticketNumber), prize, game);
  }
}
