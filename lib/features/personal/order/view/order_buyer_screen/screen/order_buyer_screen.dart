import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../services/get_it.dart' show locator;
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../data/source/local/local_orders.dart';
import '../widgets/buyer_order_header_widget.dart';
import '../widgets/buyer_order_product_detail_widget.dart';
import '../widgets/order_buyer_address_widget.dart';
import '../widgets/order_buyer_payment_info_widget.dart';
import '../widgets/order_buyer_screen_bottom_buttons.dart';
import '../widgets/order_buyer_status_section.dart';
import '../widgets/order_buyer_tracking_details_section.dart';

class OrderBuyerScreen extends StatelessWidget {
  const OrderBuyerScreen({super.key});
  static String routeName = '/order-buyer-screen';

  Future<PostEntity?> _loadPost(String postId) async {
    final DataState<PostEntity> postResult = await GetSpecificPostUsecase(
      locator(),
    ).call(GetSpecificPostParam(postId: postId));
    return (postResult is DataSuccess<PostEntity>) ? postResult.entity : null;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Support both 'order' object (legacy) and 'order-id' string (new)
    late OrderEntity order;
    if (args.containsKey('order-id')) {
      final String orderId = args['order-id'] as String;
      final OrderEntity? fetchedOrder = LocalOrders().get(orderId);
      if (fetchedOrder == null) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const AppBarTitle(titleKey: 'order_details'),
          ),
          body: Center(child: Text('order_not_found'.tr())),
        );
      }
      order = fetchedOrder;
    } else {
      order = args['order'] as OrderEntity;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'order_details'),
      ),
      body: FutureBuilder<PostEntity?>(
        future: _loadPost(order.postId),
        builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final PostEntity? post = snapshot.data;

          return StreamBuilder<dynamic>(
            stream: LocalOrders().watch(key: order.orderId),
            builder: (BuildContext context, _) {
              final OrderEntity orderData =
                  LocalOrders().get(order.orderId) ?? order;
              final bool hasTrackingDetails =
                  (orderData.trackId?.trim().isNotEmpty ?? false) ||
                  ((orderData.shippingDetails?.postage.isNotEmpty ?? false) &&
                      (orderData.shippingDetails!.postage.first.shipmentId
                              ?.trim()
                              .isNotEmpty ??
                          false));

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BuyerOrderHeaderWidget(orderData: orderData),
                    const SizedBox(height: 16),
                    OrderBuyerStatusSection(orderData: orderData),
                    const SizedBox(height: 16),
                    BuyerOrderProductDetailWidget(
                      post: post,
                      orderData: orderData,
                    ),
                    if (hasTrackingDetails) const SizedBox(height: 16),
                    if (hasTrackingDetails)
                      OrderBuyerTrackingDetailsSection(orderData: orderData),
                    if (hasTrackingDetails) const SizedBox(height: 16),
                    OrderBuyerAddressWIdget(orderData: orderData),
                    const SizedBox(height: 16),
                    OrderBuyerPaymentInfoWidget(
                      orderData: orderData,
                      post: post,
                    ),
                    const SizedBox(height: 24),
                    OrderBuyerScreenBottomButtons(order: orderData, post: post),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
