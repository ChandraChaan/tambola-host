import '../../../core/seeded_random.dart';
import 'ticket.dart';

/// Builds tickets deterministically from a game code.
///
/// Tickets come in strips of six: tickets 1–6 form strip 0, 7–12 strip 1,
/// and so on. Each strip uses every number from 1 to 90 exactly once, so no
/// number is repeated inside a strip. The same code and ticket number always
/// give the same ticket, which lets the host check any ticket by its number.
class TicketGenerator {
  TicketGenerator(this.gameCode);

  static const int ticketsPerStrip = 6;

  final String gameCode;
  final Map<int, List<Ticket>> _strips = {};

  /// The ticket printed with [ticketNumber] (1-based).
  Ticket ticket(int ticketNumber) {
    assert(ticketNumber >= 1, 'Ticket numbers start at 1');
    final strip = (ticketNumber - 1) ~/ ticketsPerStrip;
    return this.strip(strip)[(ticketNumber - 1) % ticketsPerStrip];
  }

  /// The first [count] tickets.
  List<Ticket> tickets(int count) => [
    for (var n = 1; n <= count; n++) ticket(n),
  ];

  /// The six tickets of strip [index] (0-based).
  List<Ticket> strip(int index) => _strips[index] ??= generateStrip(
    SeededRandom(fnv1a32('$gameCode/$index')),
    firstTicketNumber: index * ticketsPerStrip + 1,
  );

  /// Numbers available in each of the nine columns.
  static List<int> columnPool(int column) {
    final (low, high) = Ticket.columnRange(column);
    return [for (var n = low; n <= high; n++) n];
  }

  /// Generates one full strip of six tickets that together use 1–90 once.
  static List<Ticket> generateStrip(
    SeededRandom random, {
    required int firstTicketNumber,
  }) {
    final counts = _columnCounts(random);
    final layouts = [for (final row in counts) _rowLayout(row, random)];

    final cells = [
      for (var t = 0; t < ticketsPerStrip; t++)
        List<int>.filled(Ticket.rows * Ticket.columns, 0),
    ];
    for (var c = 0; c < Ticket.columns; c++) {
      final pool = columnPool(c);
      random.shuffle(pool);
      var next = 0;
      for (var t = 0; t < ticketsPerStrip; t++) {
        final take = pool.sublist(next, next + counts[t][c])..sort();
        next += counts[t][c];
        var i = 0;
        for (var r = 0; r < Ticket.rows; r++) {
          if (layouts[t][r][c]) {
            cells[t][r * Ticket.columns + c] = take[i++];
          }
        }
      }
    }
    return [
      for (var t = 0; t < ticketsPerStrip; t++)
        Ticket(number: firstTicketNumber + t, cells: cells[t]),
    ];
  }

  /// How many numbers each ticket gets from each column.
  ///
  /// Every ticket starts with one number per column (so no column is empty)
  /// and then receives six more, at most three per column, until each
  /// column's pool is used up. A dead end simply restarts with fresh draws.
  static List<List<int>> _columnCounts(SeededRandom random) {
    while (true) {
      final counts = [
        for (var t = 0; t < ticketsPerStrip; t++)
          List<int>.filled(Ticket.columns, 1),
      ];
      final need = List<int>.filled(
        ticketsPerStrip,
        Ticket.numbersPerTicket - Ticket.columns,
      );
      final columns = List<int>.generate(Ticket.columns, (c) => c);
      random.shuffle(columns);
      // Bigger columns first: they have the fewest ways to fit.
      columns.sort(
        (a, b) => columnPool(b).length.compareTo(columnPool(a).length),
      );

      var stuck = false;
      for (final c in columns) {
        final extra = columnPool(c).length - ticketsPerStrip;
        for (var k = 0; k < extra && !stuck; k++) {
          final open = [
            for (var t = 0; t < ticketsPerStrip; t++)
              if (need[t] > 0 && counts[t][c] < Ticket.rows) t,
          ];
          if (open.isEmpty) {
            stuck = true;
            break;
          }
          // Favour tickets that still need the most numbers.
          final weights = [for (final t in open) need[t]];
          var pick = random.nextInt(weights.reduce((a, b) => a + b));
          var chosen = open.last;
          for (var i = 0; i < open.length; i++) {
            if (pick < weights[i]) {
              chosen = open[i];
              break;
            }
            pick -= weights[i];
          }
          counts[chosen][c]++;
          need[chosen]--;
        }
        if (stuck) break;
      }
      if (!stuck) return counts;
    }
  }

  /// Decides which rows hold a number in each column so that every row ends
  /// up with exactly five numbers. Returns `[row][column]` flags.
  static List<List<bool>> _rowLayout(List<int> columnCounts, SeededRandom r) {
    final layout = [
      for (var row = 0; row < Ticket.rows; row++)
        List<bool>.filled(Ticket.columns, false),
    ];
    final rowTotals = List<int>.filled(Ticket.rows, 0);

    bool place(int column) {
      if (column == Ticket.columns) {
        return rowTotals.every((t) => t == Ticket.numbersPerRow);
      }
      final options = _rowChoices[columnCounts[column]]!.toList();
      r.shuffle(options);
      for (final rows in options) {
        if (rows.any((row) => rowTotals[row] >= Ticket.numbersPerRow)) {
          continue;
        }
        for (final row in rows) {
          rowTotals[row]++;
          layout[row][column] = true;
        }
        if (place(column + 1)) return true;
        for (final row in rows) {
          rowTotals[row]--;
          layout[row][column] = false;
        }
      }
      return false;
    }

    if (!place(0)) {
      throw StateError('No row layout for column counts $columnCounts');
    }
    return layout;
  }

  static const Map<int, List<List<int>>> _rowChoices = {
    1: [
      [0],
      [1],
      [2],
    ],
    2: [
      [0, 1],
      [0, 2],
      [1, 2],
    ],
    3: [
      [0, 1, 2],
    ],
  };
}
