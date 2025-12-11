import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../postage/domain/params/add_lable_params.dart';
import '../../../../postage/domain/usecase/buy_label_usecsae.dart';
import '../../../chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/helper_functions/country_helper.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';
import '../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../provider/order_provider.dart';
import 'order_postage_bottom_sheet.dart';

class OrderSellerScreen extends StatelessWidget {
  const OrderSellerScreen({super.key});
  static String routeName = '/order-seller-screen';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String orderId = args['order-id'] ?? '';

    final OrderProvider orderPro = Provider.of<OrderProvider>(
      context,
      listen: false,
    );
    if (orderPro.order?.orderId != orderId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderPro.loadOrder(orderId);
      });
    }

    return Selector<OrderProvider, OrderEntity?>(
      selector: (_, OrderProvider provider) => provider.order,
      builder: (BuildContext context, OrderEntity? order, _) {
        if (order == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isBusiness = order.sellerId.startsWith('BU');
        final GetSpecificPostUsecase getPostUsecase = GetSpecificPostUsecase(
          locator(),
        );
        final GetUserByUidUsecase getUserUsecase = GetUserByUidUsecase(
          locator(),
        );
        final GetBusinessByIdUsecase getBusinessUsecase =
            GetBusinessByIdUsecase(locator());

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'order_details'.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: FutureBuilder<DataState<PostEntity>>(
            future: getPostUsecase(GetSpecificPostParam(postId: order.postId)),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<DataState<PostEntity>> postSnap,
                ) {
                  if (postSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final PostEntity? post = postSnap.data?.entity;
                  if (post == null) {
                    return Center(child: Text('something_wrong'.tr()));
                  }

                  return FutureBuilder<DataState<dynamic>>(
                    future: isBusiness
                        ? getBusinessUsecase(order.sellerId)
                        : getUserUsecase(order.sellerId),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<DataState<dynamic>> userSnap,
                        ) {
                          if (userSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return _buildOrderDetailBody(context, post);
                        },
                  );
                },
          ),
        );
      },
    );
  }
}

Widget _buildOrderDetailBody(BuildContext context, PostEntity post) {
  final OrderEntity order = context.watch<OrderProvider>().order!;
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      backgroundBlendMode: BlendMode.color,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OrderScreenPostInfo(order: order, post: post),
          const Divider(),
          OrderInfoWidget(order: order),
          const Divider(),
          OrderDispatchedToWidget(order: order),
          const SizedBox(height: 16),
          const OrderActionButtonsList(),
        ],
      ),
    ),
  );
}

class OrderDispatchedToWidget extends StatelessWidget {
  const OrderDispatchedToWidget({required this.order, super.key});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.local_shipping_outlined,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 6),
            Text(
              'dispatched_to'.tr(),
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        OrderRecieverNameAddressWidget(
          address: order.shippingAddress,
          name: order.shippingAddress.recipientName,
          nameTextStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          addressTextStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class OrderInfoWidget extends StatelessWidget {
  const OrderInfoWidget({required this.order, super.key});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'order_number'.tr()}:',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorScheme.of(context).onSurface.withValues(alpha: 0.3),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                order.orderId,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
            ),
            // const ViewInvoiceButton()
          ],
        ),
      ],
    );
  }
}

class ViewInvoiceButton extends StatelessWidget {
  const ViewInvoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (BuildContext context, OrderProvider pro, Widget? child) {
        final OrderEntity order = pro.order!;
        return InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute<InvoiceScreen>(
            //       builder: (BuildContext context) =>
            //           InvoiceScreen(order: order),
            //     ));
          },
          child: Text(
            'view_invoice'.tr(),
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 10,
              decorationColor: order.orderStatus.color,
              color: order.orderStatus.color,
            ),
          ),
        );
      },
    );
  }
}

class OrderActionButtonsList extends StatelessWidget {
  const OrderActionButtonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (BuildContext context, OrderProvider orderPro, _) {
        final OrderEntity order = orderPro.order!;
        return Column(
          children: <Widget>[
            if (order.orderStatus == StatusType.pending)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'start_order',
                color: order.orderStatus.color,
                onTap: () => orderPro.updateSellerOrder(
                  order.orderId,
                  StatusType.processing,
                ),
              ),
            if (order.orderStatus == StatusType.processing &&
                order.deliveryPaidBy == 'buyer')
              OrderActionButton(
                isLoading: false,
                keyName: 'buy_label',
                color: order.orderStatus.color,
                onTap: () {
                  BuyLabelUsecase(
                    locator(),
                  ).call(BuyLabelParams(orderId: order.orderId));
                },
              ),
            if (order.orderStatus == StatusType.processing &&
                order.deliveryPaidBy == 'seller')
              OrderActionButton(
                isLoading: false,
                keyName: 'choose_postage',
                color: order.orderStatus.color,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        OrderPostageBottomSheet(orderId: order.orderId),
                  );
                },
              ),
            if (order.orderStatus == StatusType.delivered)
              OrderActionButton(
                isLoading: false,
                keyName: 'posted',
                color: order.orderStatus.color,
                onTap: () {},
              ),
            if (order.orderStatus == StatusType.cancelled)
              OrderActionButton(
                isLoading: false,
                keyName: 'cancelled',
                color: order.orderStatus.color,
                onTap: () {},
              ),
            if (order.orderStatus == StatusType.pending)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'cancel_order',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                onTap: () => orderPro.updateSellerOrder(
                  order.orderId,
                  StatusType.cancelled,
                ),
              ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'contact_buyer',
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              onTap: () {
                Provider.of<CreatePrivateChatProvider>(
                  context,
                  listen: false,
                ).startPrivateChat(context, order.buyerId);
              },
            ),
            InDevMode(
              child: OrderActionButton(
                isLoading: false,
                keyName: 'leave_feedback',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                onTap: () {},
              ),
            ),
            InDevMode(
              child: OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'view_payment_details',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                onTap: () {},
              ),
            ),
            InDevMode(
              child: OrderActionButton(
                isLoading: false,
                keyName: 'report_buyer',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                onTap: () {},
              ),
            ),
            InDevMode(
              child: OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'send_refund',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                onTap: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({
    required this.keyName,
    required this.color,
    required this.onTap,
    required this.isLoading,
    super.key,
  });

  final String keyName;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      padding: const EdgeInsets.all(4),
      isLoading: isLoading,
      onTap: onTap,
      textStyle: TextTheme.of(context).bodyMedium?.copyWith(color: color),
      bgColor: Colors.transparent,
      textColor: color,
      border: Border.all(color: color),
      title: keyName.tr(),
    );
  }
}

class OrderScreenPostInfo extends StatelessWidget {
  const OrderScreenPostInfo({
    required this.post,
    required this.order,
    super.key,
  });
  final PostEntity post;
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomNetworkImage(
            imageURL: post.imageURL,
            size: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),

        // Title and Date + Amount Column
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title and Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${CountryHelper.currencySymbolHelper(order.paymentDetail.postCurrency)}${order.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Ordered on Date
              Text(
                '${'ordered_on'.tr()}: ${DateFormat.yMMMMd().format(order.createdAt)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ColorScheme.of(
                    context,
                  ).onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderRecieverNameAddressWidget extends StatefulWidget {
  const OrderRecieverNameAddressWidget({
    required this.name,
    required this.address,
    this.nameTextStyle,
    this.addressTextStyle,
    super.key,
  });

  final String name;
  final AddressEntity address;
  final TextStyle? nameTextStyle;
  final TextStyle? addressTextStyle;

  @override
  State<OrderRecieverNameAddressWidget> createState() =>
      _OrderRecieverNameAddressWidgetState();
}

class _OrderRecieverNameAddressWidgetState
    extends State<OrderRecieverNameAddressWidget> {
  final GlobalKey _rowKey = GlobalKey();
  OverlayEntry? _overlayEntry;


  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    final RenderBox? renderBox =
        _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double overlayWidth = size.width + 50; // wider overlay

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 6,
        width: overlayWidth > screenWidth ? screenWidth - 16 : overlayWidth,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.color,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  '${widget.address.city} /  ${widget.address.address1}',
                  style:
                      widget.addressTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Text(
                  '${widget.address.state.stateName} / ${widget.address.country.countryName}',
                  style:
                      widget.addressTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _rowKey,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                widget.nameTextStyle ??
                Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: _toggleOverlay,
          borderRadius: BorderRadius.circular(16),
          child: Icon(
            _overlayEntry == null
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
