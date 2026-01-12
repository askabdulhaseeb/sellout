import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../../order/view/screens/order_seller_screen.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../../data/source/local/local_notification.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../provider/notification_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationActionHandler {
  static Future<void> handleNotification(
    BuildContext context,
    NotificationEntity notification,
    String action,
  ) async {
    // Mark as viewed
    await LocalNotifications.markAsViewed(notification.notificationId);
    if (context.mounted) {
      context.read<NotificationProvider>().refreshFromLocal();
    }

    if (!context.mounted) return;

    switch (action) {
      case 'post':
        await _handlePostNotification(context, notification.postId);
        break;
      case 'chat':
        await _handleChatNotification(context, notification.chatId);
        break;
      case 'order':
        await _handleOrderNotification(context, notification);
        break;
      default:
        print('❌ NO ACTION - No valid data found');
    }
  }

  static Future<void> _handleOrderNotification(
    BuildContext context,
    NotificationEntity notification,
  ) async {
    final String? orderId = notification.orderId;

    if (orderId == null || orderId.isEmpty) {
      print('❌ Order ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
      }
      return;
    }

    print('✅ Processing ORDER: $orderId');

    final String notificationFor = notification.notificationFor.toLowerCase();
    final bool forSeller =
        notificationFor.contains('seller') ||
        notificationFor.contains('business');

    print('   notificationFor: "$notificationFor" | forSeller: $forSeller');

    if (!context.mounted) return;

    if (forSeller) {
      print('   ✅ Navigating to SELLER view');
      AppNavigator.pushNamed(
        OrderSellerScreen.routeName,
        arguments: <String, dynamic>{'order-id': orderId},
      );
      return;
    }

    print('   ✅ Navigating to BUYER view');
    AppNavigator.pushNamed(
      OrderBuyerScreen.routeName,
      arguments: <String, dynamic>{'order-id': orderId},
    );
  }

  static Future<void> _handleChatNotification(
    BuildContext context,
    String? chatId,
  ) async {
    if (chatId == null || chatId.trim().isEmpty) {
      print('❌ Chat ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'chat_not_found'.tr());
      }
      return;
    }

    print('✅ Opening CHAT: $chatId');

    if (!context.mounted) return;

    final ChatProvider chatProvider = context.read<ChatProvider>();
    await chatProvider.createOrOpenChatById(context, chatId);
  }

  static Future<void> _handlePostNotification(
    BuildContext context,
    String? postId,
  ) async {
    if (postId == null || postId.isEmpty) {
      print('❌ Post ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'post_not_found'.tr());
      }
      return;
    }

    print('✅ Opening POST: $postId');
    if (context.mounted) {
      AppNavigator.pushNamed(
        PostDetailScreen.routeName,
        arguments: <String, String>{'pid': postId},
      );
    }
  }
}
