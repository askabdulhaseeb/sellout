import 'int_ext.dart';

extension DurationExt on Duration {
  String putInStart({required String sign, required int length}) {
    return toString().length < length
        ? toString().padLeft(length, sign)
        : toString();
  }

  bool timesAgo(Duration duration) {
    final DateTime now = DateTime.now();
    final DateTime ago = now.subtract(duration);
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(inMilliseconds);
    return time.isBefore(ago);
  }

  String display() {
    final int days = inDays;
    final int hours = inHours;
    final int minutes = inMinutes.remainder(60);
    final int seconds = inSeconds.remainder(60);
    final String str =
        '${hours}H:${minutes.putInStart(sign: '0', length: 2)}m:${seconds.putInStart(sign: '0', length: 2)}s';
    return days > 0 ? '$days Day - $str' : str;
  }
}
