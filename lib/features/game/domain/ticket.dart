/// One Tambola ticket: 3 rows × 9 columns, 15 numbers, 5 in each row.
///
/// Column `c` holds numbers from [columnRange]. Blank cells are `0`.
class Ticket {
  Ticket({required this.number, required List<int> cells})
    : assert(cells.length == rows * columns, 'A ticket has 27 cells'),
      cells = List.unmodifiable(cells);

  static const int rows = 3;
  static const int columns = 9;
  static const int numbersPerRow = 5;
  static const int numbersPerTicket = rows * numbersPerRow;

  /// The ticket number printed on the ticket, starting at 1.
  final int number;

  /// Row-major cells; `0` means blank.
  final List<int> cells;

  int cell(int row, int column) => cells[row * columns + column];

  /// The numbers in [row], left to right.
  List<int> rowNumbers(int row) => [
    for (var c = 0; c < columns; c++)
      if (cell(row, c) != 0) cell(row, c),
  ];

  /// The numbers in [column], top to bottom.
  List<int> columnNumbers(int column) => [
    for (var r = 0; r < rows; r++)
      if (cell(r, column) != 0) cell(r, column),
  ];

  /// All 15 numbers on the ticket, top row first.
  List<int> get numbers => [
    for (final n in cells)
      if (n != 0) n,
  ];

  /// The column a number belongs to: 1–9, 10–19, … 70–79, 80–90.
  static int columnOf(int number) => number == 90 ? 8 : number ~/ 10;

  /// Lowest and highest number allowed in [column].
  static (int, int) columnRange(int column) => switch (column) {
    0 => (1, 9),
    8 => (80, 90),
    _ => (column * 10, column * 10 + 9),
  };

  @override
  bool operator ==(Object other) {
    if (other is! Ticket || other.number != number) return false;
    for (var i = 0; i < cells.length; i++) {
      if (other.cells[i] != cells[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(number, Object.hashAll(cells));

  @override
  String toString() =>
      'Ticket #$number ${[for (var r = 0; r < rows; r++) rowNumbers(r)]}';
}
