import 'package:flutter/material.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../services/get_it.dart' show locator;
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../../../core/sources/data_state.dart';
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

  Future<(OrderEntity, PostEntity?)> _loadData(OrderEntity order) async {
    final DataState<PostEntity> postResult = await GetSpecificPostUsecase(
      locator(),
    ).call(GetSpecificPostParam(postId: order.postId));
    final PostEntity? post = (postResult is DataSuccess<PostEntity>)
        ? postResult.entity
        : null;
    return (order, post);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final OrderEntity order = args['order'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'order_details'),
      ),
      body: FutureBuilder<(OrderEntity, PostEntity?)>(
        future: _loadData(order),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<(OrderEntity, PostEntity?)> snapshot,
            ) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final (OrderEntity orderData, PostEntity? post) = snapshot.data!;
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
                    OrderBuyerScreenBottomButtons(order: orderData),
                  ],
                ),
              );
            },
      ),
    );
  }
}
