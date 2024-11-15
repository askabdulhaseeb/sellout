import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../entities/api_request_entity.dart';
import '../../extension/duration_ext.dart';
import '../../extension/string_ext.dart';
import '../../utilities/app_string.dart';

export '../../entities/api_request_entity.dart';

class LocalRequestHistory {
  static final String boxTitle = AppStrings.localRequestHistory;
  static Box<ApiRequestEntity> get _box => Hive.box<ApiRequestEntity>(boxTitle);

  static Future<Box<ApiRequestEntity>> get openBox async =>
      await Hive.openBox<ApiRequestEntity>(boxTitle);

  Future<Box<ApiRequestEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ApiRequestEntity>(boxTitle);
    }
  }

  Future<void> save(ApiRequestEntity request) async =>
      await _box.put(request.url.toSHA256(), request);

  Future<ApiRequestEntity?> request({
    required String endpoint,
    String? baseURL,
    Duration duration = const Duration(hours: 1),
  }) async {
    String url = baseURL ?? dotenv.env['baseURL'] ?? '';
    if (url.isEmpty) {
      return null;
    }
    url = '$url${endpoint.startsWith('/') ? endpoint : '/$endpoint'}';

    ApiRequestEntity? result = _box.get(url.toSHA256());
    if (result == null) return null;
    if (!result.timesAgo(duration)) {
      if (!url.contains('/user/') && !url.contains('/post/')) {
        debugPrint('🟢 Less then ${duration.display()} - $url');
      }
      return result;
    } else {
      debugPrint('🔴 More then ${duration.display()} - $url');
      await delete(url);
      return null;
    }
  }

  Future<void> delete(String value) async =>
      await _box.delete(value.toSHA256());
}
