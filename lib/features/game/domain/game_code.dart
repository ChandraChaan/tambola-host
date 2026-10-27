/// Short, easy-to-read game codes such as `K7QX2M`.
///
/// The alphabet leaves out characters that are easy to confuse when read
/// aloud or printed small (0/O, 1/I/L).
abstract final class GameCode {
  static const String alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  static const int length = 6;

  /// Builds a code from [nextInt], which returns a value in `0 .. max - 1`.
  static String generate(int Function(int max) nextInt) =>
      String.fromCharCodes([
        for (var i = 0; i < length; i++)
          alphabet.codeUnitAt(nextInt(alphabet.length)),
      ]);

  /// Upper-cases and trims what the host typed.
  static String normalize(String input) => input.trim().toUpperCase();

  static bool isValid(String code) =>
      code.length == length && code.split('').every(alphabet.contains);
}
