import 'package:tambola_host/features/game/domain/ticket.dart';

/// Every rule a printed Tambola ticket must follow. Returns the broken rules.
List<String> ticketProblems(Ticket ticket) {
  final problems = <String>[];
  if (ticket.cells.length != 27) {
    problems.add('has ${ticket.cells.length} cells');
  }
  if (ticket.numbers.length != 15) {
    problems.add('has ${ticket.numbers.length} numbers');
  }
  if (ticket.numbers.toSet().length != ticket.numbers.length) {
    problems.add('repeats a number');
  }
  for (var r = 0; r < Ticket.rows; r++) {
    if (ticket.rowNumbers(r).length != 5) {
      problems.add('row $r has ${ticket.rowNumbers(r).length} numbers');
    }
  }
  for (var c = 0; c < Ticket.columns; c++) {
    final column = ticket.columnNumbers(c);
    final (low, high) = Ticket.columnRange(c);
    if (column.isEmpty) problems.add('column $c is empty');
    for (final n in column) {
      if (n < low || n > high) problems.add('$n is in column $c');
    }
    for (var i = 1; i < column.length; i++) {
      if (column[i] <= column[i - 1]) {
        problems.add('column $c is not ascending: $column');
      }
    }
  }
  return problems;
}
