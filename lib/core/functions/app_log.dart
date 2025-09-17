import 'dart:async';
import 'dart:developer';

class AppLog {
  static void error(
    String message, {
    String? name,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // print('''
    // [${DateTime.now()}] ${name ?? 'AppLog'}: $message
    // ${error != null ? 'Error: $error' : ''}
    // ''');
    log(
      message,
      name: '❌ ${name ?? 'AppLog'}',
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(
    String message, {
    String? name,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    Zone? zone,
  }) {
    // print('''
    // [${DateTime.now()}] ${name ?? 'AppLog'}: $message
    // ''');
    log(
      message,
      name: name ?? 'AppLog',
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      zone: zone,
    );
  }
}
