import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../sources/local/local_request_history.dart';

part 'api_request_entity.g.dart';

@HiveType(typeId: 3)
class ApiRequestEntity {
  ApiRequestEntity({
    required this.url,
    required this.encodedData,
    DateTime? lastRequest,
  }) : lastRequest = lastRequest ?? DateTime.now();

  @HiveField(0)
  final String url;
  @HiveField(1)
  DateTime? lastRequest;
  @HiveField(2)
  String encodedData;

  bool timesAgo(Duration duration) {
    if (lastRequest == null) return true;
    debugPrint('Difference from Last to Now $duration');
    return lastRequest != null &&
        DateTime.now().difference(lastRequest!) > duration;
  }

  Future<void> updateLastRequest() async {
    lastRequest = DateTime.now();
    await LocalRequestHistory().save(this);
  }
}
