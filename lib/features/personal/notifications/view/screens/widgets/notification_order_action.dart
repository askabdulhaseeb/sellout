import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../order/data/source/local/local_orders.dart';
import '../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../order/view/screens/order_seller_screen.dart';

class NotificationOrderAction {
  const NotificationOrderAction._();

  static Future<void> navigate({
    required BuildContext context,
    required String? orderId,
    required String notificationFor,
  }) async {
    if (orderId == null || orderId.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
      }
      return;
    }

    if (!context.mounted) return;

    final bool forSeller = notificationFor.toLowerCase().contains(
      RegExp(r'seller|business'),
    );

    // Try to pull the order from local cache to avoid "No order found" screens
    final order = LocalOrders().get(orderId);

    AppNavigator.pushNamed(
      forSeller ? OrderSellerScreen.routeName : OrderBuyerScreen.routeName,
      arguments: <String, dynamic>{
        'order-id': orderId,
        if (order != null) 'order': order,
      },
    );
  }

  static String getButtonText() => 'order'.tr();
}
