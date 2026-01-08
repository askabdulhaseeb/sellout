import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../order/view/screens/order_seller_screen.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationOrderAction {
  const NotificationOrderAction._();

  static Future<void> navigate({
    required BuildContext context,
    required NotificationEntity notification,
  }) async {
    final String? orderId = notification.metadata.orderId;
    if (orderId == null || orderId.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
      }
      return;
    }
    // Try to pull the order from local cache to avoid "No order found" screens

    AppNavigator.pushNamed(
      notification.metadata.isSeller
          ? OrderSellerScreen.routeName
          : OrderBuyerScreen.routeName,
      arguments: <String, dynamic>{'order-id': orderId},
    );
  }

  static String getButtonText() => 'order'.tr();
}
