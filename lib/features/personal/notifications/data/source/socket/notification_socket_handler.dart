import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sockets/handlers/base_socket_handler.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/system_notification_service.dart';
import '../../../../bookings/data/sources/local_booking.dart';
import '../../models/notification_model.dart';
import '../local/local_notification.dart';

/// Handles notification socket events.
/// Also updates bookings when notification contains booking metadata.
class NotificationSocketHandler extends BaseSocketHandler {
  @override
  List<String> get supportedEvents => <String>[AppStrings.newNotification];

  @override
  Future<void> handleEvent(String eventName, dynamic data) async {
    if (data == null) return;

    if (eventName == AppStrings.newNotification ||
        eventName == 'new-notification') {
      await _handleNewNotification(data);
    }
  }

  Future<void> _handleNewNotification(dynamic data) async {
    try {
      if (data is Map<String, dynamic>) {
        // Handle booking update if metadata contains booking_id
        await _updateBookingIfPresent(data);

        // Save notification locally
        final NotificationModel notification = NotificationModel.fromMap(data);
        await LocalNotifications.saveNotification(notification);

        // Show system notification
        await SystemNotificationService().showNotification(notification);

        AppLog.info(
          'Notification processed: ${notification.notificationId}',
          name: 'NotificationSocketHandler',
        );
      }
    } catch (e) {
      AppLog.error(
        'Error handling notification: $e',
        name: 'NotificationSocketHandler',
      );
    }
  }

  Future<void> _updateBookingIfPresent(Map<String, dynamic> data) async {
    final dynamic metadata = data['metadata'];
    if (metadata != null && metadata is Map && metadata['booking_id'] != null) {
      final Map<String, dynamic> metadataMap =
          Map<String, dynamic>.from(metadata);
      await LocalBooking().update(
        metadataMap['booking_id'].toString(),
        metadataMap,
      );
      AppLog.info(
        'Booking updated from notification: ${metadataMap['booking_id']}',
        name: 'NotificationSocketHandler',
      );
    }
  }
}
