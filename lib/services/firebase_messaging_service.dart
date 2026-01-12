import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../core/functions/app_log.dart';
import '../core/sources/api_call.dart';
import '../core/sources/data_state.dart';
import '../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/chat/views/screens/chat_screen.dart';
import '../features/personal/notifications/domain/entities/notification_entity.dart';
import '../features/personal/notifications/domain/entities/notification_metadata_entity.dart';
import '../features/personal/notifications/view/screens/notification_screen.dart';
import '../features/personal/order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../features/personal/order/view/screens/order_seller_screen.dart';
import '../features/personal/post/post_detail/views/screens/post_detail_screen.dart';
import '../routes/app_linking.dart';
import 'system_notification_service.dart';

/// Service for handling Firebase Cloud Messaging (FCM) push notifications.
class FirebaseMessagingService {
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  String? _fcmToken;

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize FCM and set up message handlers
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Request permission for notifications
      await _requestPermission();

      // Get the FCM token
      await _getToken();

      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up message opened app handler (when user taps notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a notification
      final RemoteMessage? initialMessage = await _messaging
          .getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      _isInitialized = true;
      AppLog.info(
        'FirebaseMessagingService initialized',
        name: 'FirebaseMessagingService',
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'Failed to initialize FirebaseMessagingService',
        name: 'FirebaseMessagingService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('FCM Permission status: ${settings.authorizationStatus}');
    }
  }

  /// Get the FCM token
  Future<void> _getToken() async {
    try {
      // For iOS, get APNS token first
      if (Platform.isIOS) {
        final String? apnsToken = await _messaging.getAPNSToken();
        if (kDebugMode) {
          print('APNS Token: $apnsToken');
        }
      }

      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // TODO: Send token to your backend server
      if (_fcmToken != null) {
        await _sendTokenToServer(_fcmToken!);
      }
    } catch (e) {
      AppLog.error(
        'Failed to get FCM token',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String token) {
    _fcmToken = token;
    if (kDebugMode) {
      print('FCM Token refreshed: $token');
    }
    _sendTokenToServer(token);
  }

  /// Send token to backend server
  Future<void> _sendTokenToServer(String token) async {
    final String endpoint =
        dotenv.env['FCM_TOKEN_ENDPOINT'] ?? '/api/user/fcm-token';

    final Map<String, dynamic> payload =
        <String, dynamic>{
          'fcm_token': token,
          'user_id': LocalAuth.uid,
          'platform': Platform.isIOS ? 'ios' : 'android',
        }..removeWhere(
          (_, dynamic value) =>
              value == null || (value is String && value.trim().isEmpty),
        );

    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: jsonEncode(payload),
        extraHeader: <String, String>{'X-Requested-With': 'XMLHttpRequest'},
      );

      if (result is DataSuccess) {
        AppLog.info(
          'FCM token sent to server',
          name: 'FirebaseMessagingService',
        );
      } else if (result is DataFailer) {
        AppLog.error(
          'Failed to send FCM token',
          name: 'FirebaseMessagingService',
          error: result.exception,
        );
      }
    } catch (e, stackTrace) {
      AppLog.error(
        'FCM token send error',
        name: 'FirebaseMessagingService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handle foreground messages - show local notification
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // Show local notification when app is in foreground
    final RemoteNotification? notification = message.notification;
    if (notification != null) {
      _showLocalNotification(message);
    }
  }

  /// Handle when user taps on notification to open app
  void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      print('Message opened app: ${message.messageId}');
      print('Data: ${message.data}');
    }

    final Map<String, dynamic> data = message.data;
    final String type = data['type']?.toString().toLowerCase() ?? '';
    final BuildContext? context = AppNavigator().navigatorKey.currentContext;

    switch (type) {
      case 'chat':
        final String? chatId = data['chat_id']?.toString();
        if (chatId != null && chatId.isNotEmpty) {
          if (context != null) {
            context.read<ChatProvider>().createOrOpenChatById(context, chatId);
          } else {
            AppNavigator.pushNamed(
              ChatScreen.routeName,
              arguments: <String, String>{'chat_id': chatId},
            );
          }
        }
        break;
      case 'order':
        final String? orderId = data['order_id']?.toString();
        final String audience =
            data['for']?.toString().toLowerCase() ??
            data['target']?.toString().toLowerCase() ??
            data['role']?.toString().toLowerCase() ??
            '';
        if (orderId != null && orderId.isNotEmpty) {
          final bool forSeller =
              audience.contains('seller') || audience.contains('business');
          final String route = forSeller
              ? OrderSellerScreen.routeName
              : OrderBuyerScreen.routeName;
          AppNavigator.pushNamed(
            route,
            arguments: <String, dynamic>{'order-id': orderId},
          );
        }
        break;
      case 'post':
        final String? postId = data['post_id']?.toString();
        if (postId != null && postId.isNotEmpty) {
          AppNavigator.pushNamed(
            PostDetailScreen.routeName,
            arguments: <String, String>{'pid': postId},
          );
        }
        break;
      default:
        AppNavigator.pushNamed(NotificationsScreen.routeName);
        break;
    }
  }

  /// Show local notification for foreground messages
  void _showLocalNotification(RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    if (notification == null) return;

    // Create a NotificationEntity to use with SystemNotificationService
    final NotificationEntity notificationEntity = NotificationEntity(
      notificationId: message.messageId ?? DateTime.now().toIso8601String(),
      userId: '',
      type: message.data['type']?.toString() ?? 'push',
      title: notification.title ?? 'Sellout',
      deliverTo: 'user',
      message: notification.body ?? '',
      isViewed: false,
      metadata: NotificationMetadataEntity(
        chatId: message.data['chat_id']?.toString(),
        postId: message.data['post_id']?.toString(),
        orderId: message.data['order_id']?.toString(),
        senderId: message.data['sender_id']?.toString(),
        messageId: message.data['message_id']?.toString(),
      ),
      notificationFor: 'user',
      timestamps: DateTime.now(),
    );

    SystemNotificationService().showNotification(notificationEntity);
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      AppLog.info(
        'Subscribed to topic: $topic',
        name: 'FirebaseMessagingService',
      );
    } catch (e) {
      AppLog.error(
        'Failed to subscribe to topic: $topic',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      AppLog.info(
        'Unsubscribed from topic: $topic',
        name: 'FirebaseMessagingService',
      );
    } catch (e) {
      AppLog.error(
        'Failed to unsubscribe from topic: $topic',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }

  /// Delete the FCM token (useful for logout)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      AppLog.info('FCM token deleted', name: 'FirebaseMessagingService');
    } catch (e) {
      AppLog.error(
        'Failed to delete FCM token',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }
}
