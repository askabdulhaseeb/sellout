import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  // Hive Boxes
  static String get localAuthBox => 'com.sellout.local-auth';
  static String get localUsersBox => 'com.sellout.local-users';
  static String get localRequestHistory => 'com.sellout.request_history';
  static String get localReviewBox => 'com.sellout.local-review';
  static String get localListingBox => 'com.sellout.local-listing';
  static String get localChatsBox => 'com.sellout.local-chats';
  static String get localChatMessagesBox => 'local-chat-messages';
  static String get localPostsBox => 'com.sellout.local-posts';
  // API
  String get baseURL =>
      kDebugMode ? 'http://192.168.0.181:3200' : dotenv.env['baseURL'] ?? '';
}
