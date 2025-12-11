import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../core/widgets/step_progress_indicator.dart';
import '../../../../../../services/get_it.dart' show locator;
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/post_buy_now_button.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../widgets/cancel_order_button.dart';

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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BuyerOrderHeaderWidget(orderData: orderData),
                    const SizedBox(height: 16),
                    // Map processing / readyToShip into the pending step so they
                    // display under the same initial step in the UI. If the
                    // order is cancelled show a clear banner above the indicator.
                    Builder(
                      builder: (BuildContext ctx) {
                        final StatusType rawStatus = orderData.orderStatus;
                        final StatusType displayStatus =
                            (rawStatus == StatusType.processing ||
                                rawStatus == StatusType.readyToShip)
                            ? StatusType.pending
                            : rawStatus;
                        final bool isCancelled =
                            rawStatus == StatusType.cancelled;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (isCancelled)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(ctx).colorScheme.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.cancel,
                                      size: 16,
                                      color: Theme.of(ctx).colorScheme.onError,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'cancelled'.tr(),
                                      style: Theme.of(ctx).textTheme.bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              ctx,
                                            ).colorScheme.onError,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            if (isCancelled) const SizedBox(height: 8),
                            StepProgressIndicator<StatusType>(
                              stepsStrs: <String>[
                                'pending'.tr(),
                                'dispatched'.tr(),
                                'delivered'.tr(),
                              ],
                              title: 'delivery_info'.tr(),
                              currentStep: displayStatus,
                              steps: const <StatusType>[
                                StatusType.pending,
                                StatusType.shipped,
                                StatusType.completed,
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Product card
                    BuyerOrderProductDetailWidget(
                      post: post,
                      orderData: orderData,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'tracking_details'.tr(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _TwoStyleText(
                          firstText: 'postal_service'.tr(),
                          secondText:
                              orderData.shippingDetails != null &&
                                  orderData.shippingDetails!.postage.isNotEmpty
                              ? (orderData
                                        .shippingDetails!
                                        .postage
                                        .first
                                        .serviceName ??
                                    orderData
                                        .shippingDetails!
                                        .postage
                                        .first
                                        .provider ??
                                    '-')
                              : '-',
                        ),
                        _TwoStyleText(
                          firstText: 'courier'.tr(),
                          secondText:
                              orderData.shippingDetails != null &&
                                  orderData.shippingDetails!.postage.isNotEmpty
                              ? (orderData
                                        .shippingDetails!
                                        .postage
                                        .first
                                        .provider ??
                                    '-')
                              : '-',
                        ),
                        _TwoStyleText(
                          firstText: 'tracking_number'.tr(),
                          secondText: orderData.trackId?.isNotEmpty == true
                              ? orderData.trackId!
                              : (orderData.shippingDetails != null &&
                                        orderData
                                            .shippingDetails!
                                            .postage
                                            .isNotEmpty
                                    ? (orderData
                                              .shippingDetails!
                                              .postage
                                              .first
                                              .shipmentId ??
                                          '-')
                                    : '-'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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

class OrderBuyerScreenBottomButtons extends StatelessWidget {
  const OrderBuyerScreenBottomButtons({required this.order, super.key});
  final OrderEntity order;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InDevMode(
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'more_actions'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomElevatedButton(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  isLoading: false,
                  onTap: () {},
                  title: 'tell_us_what_you_think'.tr(),
                  bgColor: Colors.transparent,
                  textStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                if (order.orderStatus == StatusType.shipped ||
                    order.orderStatus == StatusType.pending ||
                    order.orderStatus == StatusType.processing)
                  CancelOrderButton(order: order),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class OrderBuyerAddressWIdget extends StatelessWidget {
  const OrderBuyerAddressWIdget({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'delivery_address'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(orderData.shippingAddress.address1),
        Text(orderData.shippingAddress.city),
        Text(orderData.shippingAddress.state.stateName),
        Text(orderData.shippingAddress.country.countryName),
      ],
    );
  }
}

class OrderBuyerPaymentInfoWidget extends StatelessWidget {
  const OrderBuyerPaymentInfoWidget({
    required this.orderData,
    required this.post,
    super.key,
  });

  final OrderEntity orderData;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'payment_info'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InDevMode(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(AppStrings.visa, fit: BoxFit.contain),
              ),
              Text(
                '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.totalAmount.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('1 ${'item'.tr()}'),
            Text(
              '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.price.toStringAsFixed(2)}',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'postage'.tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              // try coreAmount, fall back to 0
              orderData.shippingDetails != null &&
                      orderData.shippingDetails!.postage.isNotEmpty
                  ? '${CountryHelper.currencySymbolHelper(post?.currency ?? orderData.paymentDetail.postCurrency)}${(orderData.shippingDetails!.postage.first.coreAmount ?? 0).toString()}'
                  : '${CountryHelper.currencySymbolHelper(post?.currency ?? orderData.paymentDetail.postCurrency)}0',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'order_total'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class BuyerOrderProductDetailWidget extends StatelessWidget {
  const BuyerOrderProductDetailWidget({
    required this.post,
    required this.orderData,
    super.key,
  });

  final PostEntity? post;
  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: post?.imageURL != null
                    ? CustomNetworkImage(
                        imageURL: post!.imageURL,
                        size: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 80),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post?.title ?? 'na'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${CountryHelper.currencySymbolHelper(orderData.paymentDetail.buyerCurrency)}${orderData.paymentDetail.convertedPrice}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          PostBuyNowButton(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            detailWidgetColor: null,
            detailWidgetSize: null,
            detailWidget: false,
            post: post!,
            buyNowText: 'buy_again'.tr(),
            buyNowColor: Colors.transparent,
            buyNowTextStyle: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

class BuyerOrderHeaderWidget extends StatelessWidget {
  const BuyerOrderHeaderWidget({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TwoStyleText(
          firstText: 'time_placed'.tr(),
          secondText: DateFormat(
            'd MMM yyyy \'at\' h:mm a',
          ).format(orderData.updatedAt),
        ),
        _TwoStyleText(
          firstText: 'order_number'.tr(),
          secondText: orderData.orderId,
        ),
        _TwoStyleText(
          firstText: 'total'.tr(),
          secondText:
              '${orderData.totalAmount.toStringAsFixed(2)} (${orderData.quantity} ${'items'.tr()})',
        ),
        FutureBuilder<UserEntity?>(
          future: LocalUser().user(orderData.sellerId),
          builder: (BuildContext ctx, AsyncSnapshot<UserEntity?> snap) {
            final String sellerName =
                (snap.hasData && snap.data?.displayName.isNotEmpty == true)
                ? snap.data!.displayName
                : orderData.sellerId;
            return _TwoStyleText(
              firstText: 'sold_by'.tr(),
              secondText: sellerName,
            );
          },
        ),
      ],
    );
  }
}

class _TwoStyleText extends StatelessWidget {
  const _TwoStyleText({required this.firstText, required this.secondText});

  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w400,
        );
    final TextStyle? valueStyle = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              '$firstText:',
              style: labelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Text(secondText, style: valueStyle)),
        ],
      ),
    );
  }
}
