import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../services/get_it.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../provider/order_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});
  static String routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String orderId = args['order-id'] ?? '';

    final OrderProvider orderPro =
        Provider.of<OrderProvider>(context, listen: false);
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
        final GetSpecificPostUsecase getPostUsecase =
            GetSpecificPostUsecase(locator());
        final GetUserByUidUsecase getUserUsecase =
            GetUserByUidUsecase(locator());
        final GetBusinessByIdUsecase getBusinessUsecase =
            GetBusinessByIdUsecase(locator());

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'order_details'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
              style: IconButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.outline.withAlpha(25),
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
            builder: (BuildContext context,
                AsyncSnapshot<DataState<PostEntity>> postSnap) {
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
                builder: (BuildContext context,
                    AsyncSnapshot<DataState<dynamic>> userSnap) {
                  if (userSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
  const OrderDispatchedToWidget({
    required this.order,
    super.key,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'dispatched_to'.tr()}: ',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorScheme.of(context).outline.withValues(alpha: 0.3)),
        ),
        OrderRecieverNameAddressWidget(
          address: order.shippingAddress.address,
          name: order.shippingAddress.recipientName,
        ),
      ],
    );
  }
}

class OrderInfoWidget extends StatelessWidget {
  const OrderInfoWidget({
    required this.order,
    super.key,
  });

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
              color: ColorScheme.of(context).outline.withValues(alpha: 0.3)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                order.orderId,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontSize: 10),
              ),
            ),
            const ViewInvoiceButton()
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
            // Add your invoice viewing logic here
          },
          child: Text(
            'view_invoice'.tr(),
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 10,
              decorationColor: _getStatusColor(context, order.orderStatus),
              color: _getStatusColor(context, order.orderStatus),
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
            if (order.orderStatus == StatusType.pending.json)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'post_now',
                color: _getStatusColor(context, order.orderStatus),
                onTap: () => orderPro.updateOrder(order.orderId, 'delivered'),
              ),
            if (order.orderStatus == StatusType.delivered.json)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'posted',
                color: _getStatusColor(context, order.orderStatus),
                onTap: () {},
              ),
            if (StatusType.fromJson(order.orderStatus) == StatusType.cancelled)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'cancelled',
                color: _getStatusColor(context, order.orderStatus),
                onTap: () {},
              ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'add_tracking_number',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {},
            ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'leave_feedback',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {},
            ),
            if (order.orderStatus == StatusType.pending.json)
              OrderActionButton(
                isLoading: orderPro.isLoading,
                keyName: 'cancel_order',
                color: Theme.of(context).colorScheme.outline,
                onTap: () => orderPro.updateOrder(order.orderId, 'cancelled'),
              ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'view_payment_details',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {},
            ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'contact_buyer',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {
                Provider.of<CreatePrivateChatProvider>(context, listen: false)
                    .startPrivateChat(context, order.buyerId);
              },
            ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'report_buyer',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {},
            ),
            OrderActionButton(
              isLoading: orderPro.isLoading,
              keyName: 'send_refund',
              color: Theme.of(context).colorScheme.outline,
              onTap: () {},
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
                    '${order.paymentDetail.postCurrency}${order.totalAmount}',
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
                      color: ColorScheme.of(context)
                          .outline
                          .withValues(alpha: 0.4),
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
    super.key,
  });
  final String name;
  final String address;

  @override
  State<OrderRecieverNameAddressWidget> createState() =>
      _OrderRecieverNameAddressWidgetState();
}

class _OrderRecieverNameAddressWidgetState
    extends State<OrderRecieverNameAddressWidget> {
  final GlobalKey _rowKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      final RenderBox renderBox =
          _rowKey.currentContext!.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;

      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 4,
          width: size.width,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.color,
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2)),
              ),
              child: Text(
                maxLines: 10,
                widget.address,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        key: _rowKey,
        children: <Widget>[
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              widget.name,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontSize: 12),
            ),
          ),
          InkWell(
            onTap: _toggleOverlay,
            child: Icon(
              size: 16,
              _overlayEntry == null
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
            ),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(BuildContext context, String statusJson) {
  if (statusJson == StatusType.pending.json) {
    return Theme.of(context).primaryColor;
  } else if (statusJson == StatusType.delivered.json) {
    return Theme.of(context).colorScheme.secondary;
  } else if (statusJson == StatusType.cancelled.json) {
    return Theme.of(context).colorScheme.outline;
  } else {
    return Theme.of(context).colorScheme.outline;
  }
}
