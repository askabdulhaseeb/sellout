import 'package:intl/intl.dart';

class BalanceFormatters {
  const BalanceFormatters._();

  static String formatAmount(num? amount, {required String currencyCode}) {
    try {
      return NumberFormat.simpleCurrency(
        name: currencyCode,
        decimalDigits: 2,
      ).format(amount ?? 0);
    } catch (_) {
      final num safe = amount ?? 0;
      return '${safe.toStringAsFixed(2)} $currencyCode'.trim();
    }
  }

  static String formatDateTime(String raw) {
    final DateTime? dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('d MMM yyyy, HH:mm').format(dt.toLocal());
  }
}
