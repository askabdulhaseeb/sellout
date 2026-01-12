import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../order/view/screens/order_seller_screen.dart';
import '../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../data/source/local/local_notification.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationOrderAction {
  const NotificationOrderAction._();

  static Future<void> navigate({
    required BuildContext context,
    required NotificationEntity notification,
  }) async {
    debugPrint('🔔 NotificationOrderAction.navigate called');
    debugPrint(
      '   notification.notificationId: ${notification.notificationId}',
    );
    debugPrint('   notification.orderContext: ${notification.orderContext}');
    debugPrint(
      '   notification.orderContext is null: ${notification.orderContext == null}',
    );

    // Clear old cached notifications without orderContext
    if (notification.orderContext == null) {
      debugPrint('⚠️  OrderContext is null! Clearing notifications cache...');
      try {
        await LocalNotifications().clear();
        debugPrint('✓ Cleared notifications cache');
      } catch (e) {
        debugPrint('Error clearing cache: $e');
      }
    }

    final String? uid = LocalAuth.uid;
    final String sellerId = notification.orderContext?.sellerId ?? '';
    final String buyerId = notification.orderContext?.buyerId ?? '';
    final String orderId = notification.orderContext?.orderId ?? '';

    debugPrint('📋 OrderContext Data:');
    debugPrint('   orderId: $orderId');
    debugPrint('   sellerId: $sellerId');
    debugPrint('   buyerId: $buyerId');
    debugPrint('   uid: $uid');

    if (orderId.isNotEmpty) {
      uid == sellerId
          ? AppNavigator.pushNamed(
              OrderSellerScreen.routeName,
              arguments: <String, dynamic>{'order-id': orderId},
            )
          : uid == buyerId
          ? AppNavigator.pushNamed(
              OrderBuyerScreen.routeName,
              arguments: <String, dynamic>{'order-id': orderId},
            )
          : AppNavigator.pushNamed(
              PostDetailScreen.routeName,
              arguments: <String, String>{'pid': notification.postId ?? ''},
            );
      return;
    }

    // No valid route found
    if (context.mounted) {
      AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
    }
  }

  static String getButtonText() => 'order'.tr();
}
