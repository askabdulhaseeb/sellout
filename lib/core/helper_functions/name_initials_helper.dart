class GetInitialsHelper {
  /// Returns initials from a name.
  /// Examples:
  /// "John Doe" -> "JD"
  /// "Alice" -> "A"
  /// "  " -> ""
  /// "Mary Ann Smith" -> "MA" (first two words)
  static String getInitials(String name) {
    if (name.trim().isEmpty) return '';

    final List<String> parts =
        name.trim().split(RegExp(r'\s+')); // split by spaces
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      final String first = parts[0][0].toUpperCase();
      final String second = parts[1][0].toUpperCase();
      return first + second;
    }
  }
}
