import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  // Hive Boxes
  static String get localAuthBox => 'local-auth';
  static String get localUsersBox => 'local-users';
  static String get localRequestHistory => 'request_history';
  static String get localReviewBox => 'local-review';
  static String get localListingBox => 'local-listing';
  // API
  String get baseURL =>
      kDebugMode ? 'http://192.168.0.181:3200' : dotenv.env['baseURL'] ?? '';
}
