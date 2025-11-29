import 'dart:async';

/// Handles periodic token refresh logic for the app.
class TokenRefreshScheduler {
  TokenRefreshScheduler({
    required this.onRefresh,
    this.refreshInterval = const Duration(minutes: 10),
  });
  final Future<void> Function() onRefresh;
  Duration refreshInterval;
  Timer? _refreshTimer;
  Timer? _remainingTimer;
  DateTime? _nextRefreshTime;

  void setInterval(Duration interval) {
    refreshInterval = interval;
    if (_refreshTimer != null) {
      start();
    }
  }

  void start() {
    _refreshTimer?.cancel();
    _remainingTimer?.cancel();
    _nextRefreshTime = DateTime.now().add(refreshInterval);
    _refreshTimer = Timer.periodic(refreshInterval, (_) async {
      await onRefresh();
      _nextRefreshTime = DateTime.now().add(refreshInterval);
    });
    _remainingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_nextRefreshTime != null) {
        final Duration remaining = _nextRefreshTime!.difference(DateTime.now());
        final int seconds = remaining.inSeconds > 0 ? remaining.inSeconds : 0;
        // ignore: avoid_print
        print('[Token Refresh] Time remaining for next refresh: ${seconds}s');
      }
    });
  }

  void stop() {
    _refreshTimer?.cancel();
    _remainingTimer?.cancel();
  }
}
