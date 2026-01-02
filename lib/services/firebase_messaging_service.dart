import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../core/functions/app_log.dart';
import '../features/personal/notifications/domain/entities/notification_entity.dart';
import '../features/personal/notifications/domain/entities/notification_metadata_entity.dart';
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
      final RemoteMessage? initialMessage =
          await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      _isInitialized = true;
      AppLog.info('FirebaseMessagingService initialized',
          name: 'FirebaseMessagingService');
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
      AppLog.error('Failed to get FCM token',
          name: 'FirebaseMessagingService', error: e);
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
    // TODO: Implement API call to send FCM token to your backend
    // Example:
    // await YourApiService().updateFcmToken(token);
    AppLog.info('FCM token ready to send to server: $token',
        name: 'FirebaseMessagingService');
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

    // TODO: Navigate to appropriate screen based on message data
    // Example:
    // final String? type = message.data['type'];
    // final String? id = message.data['id'];
    // if (type == 'chat') {
    //   AppNavigator.pushNamed('/chat', arguments: id);
    // }
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
      AppLog.info('Subscribed to topic: $topic',
          name: 'FirebaseMessagingService');
    } catch (e) {
      AppLog.error('Failed to subscribe to topic: $topic',
          name: 'FirebaseMessagingService', error: e);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      AppLog.info('Unsubscribed from topic: $topic',
          name: 'FirebaseMessagingService');
    } catch (e) {
      AppLog.error('Failed to unsubscribe from topic: $topic',
          name: 'FirebaseMessagingService', error: e);
    }
  }

  /// Delete the FCM token (useful for logout)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      AppLog.info('FCM token deleted', name: 'FirebaseMessagingService');
    } catch (e) {
      AppLog.error('Failed to delete FCM token',
          name: 'FirebaseMessagingService', error: e);
    }
  }
}
