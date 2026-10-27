import '../../../core/seeded_random.dart';

/// A game in progress.
///
/// [code] is public: it is printed on every ticket and decides which tickets
/// exist. [callSeed] is private to the host's device and decides the order in
/// which numbers are called, so knowing the code does not reveal the calls.
class Game {
  Game({
    required this.code,
    required this.callSeed,
    required this.ticketCount,
    required this.startedAt,
    this.calledCount = 0,
  }) : assert(calledCount >= 0 && calledCount <= totalNumbers, 'calledCount'),
       assert(ticketCount >= 1 && ticketCount <= maxTickets, 'ticketCount');

  static const int totalNumbers = 90;
  static const int maxTickets = 600;
  static const int defaultTicketCount = 60;

  final String code;
  final int callSeed;
  final int ticketCount;
  final int calledCount;

  /// When the game was created, in UTC.
  final DateTime startedAt;

  late final List<int> callOrder = _shuffledNumbers(callSeed);

  /// Numbers called so far, in call order.
  late final List<int> called = List.unmodifiable(
    callOrder.sublist(0, calledCount),
  );

  /// Call position (1-based) of each called number.
  late final Map<int, int> callPosition = {
    for (var i = 0; i < calledCount; i++) callOrder[i]: i + 1,
  };

  int? get current => calledCount == 0 ? null : callOrder[calledCount - 1];

  /// Up to [count] most recent calls, newest first.
  List<int> recent([int count = 5]) =>
      called.reversed.take(count).toList(growable: false);

  bool get isFinished => calledCount == totalNumbers;

  bool isCalled(int number) => callPosition.containsKey(number);

  Game callNext() => isFinished ? this : copyWith(calledCount: calledCount + 1);

  Game undo() =>
      calledCount == 0 ? this : copyWith(calledCount: calledCount - 1);

  Game copyWith({int? calledCount, int? ticketCount}) => Game(
    code: code,
    callSeed: callSeed,
    ticketCount: ticketCount ?? this.ticketCount,
    startedAt: startedAt,
    calledCount: calledCount ?? this.calledCount,
  );

  Map<String, Object> toJson() => {
    'code': code,
    'callSeed': callSeed,
    'ticketCount': ticketCount,
    'calledCount': calledCount,
    'startedAt': startedAt.toUtc().toIso8601String(),
  };

  /// Reads a saved game, or returns `null` if [json] is not a valid one.
  static Game? fromJson(Map<String, Object?> json) {
    final code = json['code'];
    final callSeed = json['callSeed'];
    final ticketCount = json['ticketCount'];
    final calledCount = json['calledCount'];
    final startedAt = DateTime.tryParse('${json['startedAt']}');
    if (code is! String ||
        callSeed is! int ||
        ticketCount is! int ||
        calledCount is! int ||
        startedAt == null ||
        calledCount < 0 ||
        calledCount > totalNumbers ||
        ticketCount < 1 ||
        ticketCount > maxTickets) {
      return null;
    }
    return Game(
      code: code,
      callSeed: callSeed,
      ticketCount: ticketCount,
      calledCount: calledCount,
      startedAt: startedAt.toUtc(),
    );
  }

  static List<int> _shuffledNumbers(int seed) {
    final numbers = List<int>.generate(totalNumbers, (i) => i + 1);
    SeededRandom(seed).shuffle(numbers);
    return List.unmodifiable(numbers);
  }

  @override
  bool operator ==(Object other) =>
      other is Game &&
      other.code == code &&
      other.callSeed == callSeed &&
      other.ticketCount == ticketCount &&
      other.calledCount == calledCount &&
      other.startedAt == startedAt;

  @override
  int get hashCode =>
      Object.hash(code, callSeed, ticketCount, calledCount, startedAt);
}
