import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../features/personal/notifications/domain/entities/notification_entity.dart';
import '../routes/app_linking.dart';
import '../features/personal/notifications/view/screens/notification_screen.dart';

class SystemNotificationService {
  factory SystemNotificationService() => _instance;
  SystemNotificationService._internal();
  static final SystemNotificationService _instance =
      SystemNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  // Tracks whether the app is currently in the foreground. When true,
  // system notifications will be suppressed to avoid showing notifications
  // while the user is actively using the app.
  bool _isAppInForeground = false;

  /// Set whether the app is in foreground. Call this from a lifecycle observer.
  void setAppInForeground(bool value) {
    _isAppInForeground = value;
    debugPrint('SystemNotificationService: app in foreground = $value');
  }

  /// Initialize the notification service. Call this at app startup.
  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions on iOS
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // Request permissions on Android 13+
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
    debugPrint('SystemNotificationService initialized');
  }

  /// Handle notification tap - navigate to notification screen
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    AppNavigator.pushNamed(NotificationsScreen.routeName);
  }

  /// Show a system notification for a new notification entity
  Future<void> showNotification(NotificationEntity notification) async {
    if (!_isInitialized) {
      debugPrint('SystemNotificationService not initialized');
      return;
    }

    // If app is in foreground, skip showing a system notification.
    if (_isAppInForeground) {
      debugPrint(
        'App is in foreground - skipping system notification: ${notification.title}',
      );
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'sellout_notifications',
          'Sellout Notifications',
          channelDescription: 'Notifications from Sellout app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use hashCode of notificationId for unique int id
    final int id = notification.notificationId.hashCode;

    await _plugin.show(
      id,
      notification.title,
      notification.message,
      details,
      payload: notification.notificationId,
    );

    debugPrint('System notification shown: ${notification.title}');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
