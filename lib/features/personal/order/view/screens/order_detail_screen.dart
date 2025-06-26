import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../services/get_it.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../user/profiles/domain/entities/order_entity.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({required this.order, super.key});
  final OrderEntity order;
  bool get isBusiness => order.sellerId.startsWith('BU');
  @override
  Widget build(BuildContext context) {
    final GetSpecificPostUsecase getPostUsecase =
        GetSpecificPostUsecase(locator());
    final GetUserByUidUsecase getUserUsecase = GetUserByUidUsecase(locator());
    final GetBusinessByIdUsecase getBusinessUsecase =
        GetBusinessByIdUsecase(locator());

    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr()),
        leading: IconButton(
          style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          icon: const Icon(Icons.arrow_back),
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

              final String dispatchTo = isBusiness
                  ? (userSnap.data?.entity as BusinessEntity?)?.displayName ??
                      'Business'
                  : (userSnap.data?.entity as UserEntity?)?.username ?? 'User';

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Product info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomNetworkImage(
                            imageURL: post.imageURL,
                            size: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                post.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${order.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${'ordered_on'.tr()}: ${order.createdAt}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Order number + invoice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${'order_number'.tr()}: ${order.orderId}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'view_invoice'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Dispatched to dropdown
                    Row(
                      children: <Widget>[
                        Text(
                          '${'dispatched_to'.tr()}: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        DropdownButton<String>(
                          value: dispatchTo,
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: dispatchTo,
                              child: Text(dispatchTo),
                            )
                          ],
                          onChanged: (_) {},
                          underline: const SizedBox(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Primary button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: Text('post_now'.tr()),
                    ),
                    const SizedBox(height: 8),

                    // Repeated InDevMode Buttons
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'add_tracking_number',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'leave_feedback',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'cancel_order',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'view_payment_details',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'contact_buyer',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'report_buyer',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    InDevMode(
                      child: OrderActionButton(
                        keyName: 'send_refund',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
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

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({
    super.key,
    required this.keyName,
    required this.color,
    required this.onTap,
  });

  final String keyName;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomElevatedButton(
        isLoading: false,
        onTap: onTap,
        bgColor: Colors.transparent,
        textColor: color,
        border: Border.all(color: color),
        title: keyName.tr(),
      ),
    );
  }
}
