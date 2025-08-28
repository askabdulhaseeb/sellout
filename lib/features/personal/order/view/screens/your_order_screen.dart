import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../routes/app_linking.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../domain/params/get_order_params.dart';
import '../../domain/usecase/get_orders_buyer_id.dart';
import '../../domain/entities/order_entity.dart';
import '../order_buyer_screen/screen/order_buyer_screen.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({super.key});
  static String routeName = 'your-orders-screen';

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  late Future<DataState<List<OrderEntity>>> futureOrders;

  @override
  void initState() {
    super.initState();
    final String uid = LocalAuth.uid ?? '';
    futureOrders = GetOrderByUidUsecase(locator()).call(
      GetOrderParams(user: 'buyer_id', uid: uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: FutureBuilder<DataState<List<OrderEntity>>>(
        future: futureOrders,
        builder: (BuildContext context,
            AsyncSnapshot<DataState<List<OrderEntity>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final DataState<List<OrderEntity>> dataState = snapshot.data!;

          if (dataState is DataFailer<List<OrderEntity>>) {
            return const Center(child: Text('Failed to load orders'));
          }

          if (dataState is DataSuccess<List<OrderEntity>>) {
            final List<OrderEntity> orders =
                dataState.entity ?? <OrderEntity>[];

            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }

            return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final OrderEntity order = orders[index];
                  return YourOrderTileWidget(
                    order: order,
                  );
                });
          }

          // Fallback for unexpected DataState type
          return const Center(child: Text('Unknown state.'));
        },
      ),
    );
  }
}

class YourOrderTileWidget extends StatefulWidget {
  const YourOrderTileWidget({super.key, required this.order});
  final OrderEntity order;

  @override
  State<YourOrderTileWidget> createState() => _YourOrderTileWidgetState();
}

class _YourOrderTileWidgetState extends State<YourOrderTileWidget> {
  late Future<DataState<PostEntity>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = GetSpecificPostUsecase(locator())
        .call(GetSpecificPostParam(postId: widget.order.postId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<PostEntity>>(
      future: futurePost,
      builder: (BuildContext context,
          AsyncSnapshot<DataState<PostEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text('Error loading post',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
        }

        if (!snapshot.hasData) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text('No post data',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
        }

        final DataState<PostEntity> state = snapshot.data!;

        if (state is DataFailer<List<PostEntity>>) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text(
                state.exception?.message ?? 'Failed to load post',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }

        if (state is DataSuccess<PostEntity>) {
          final PostEntity post = state.entity!;
          return GestureDetector(
            onTap: () => AppNavigator.pushNamed(OrderBuyerScreen.routeName,
                arguments: <String, OrderEntity>{'order': widget.order}),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomNetworkImage(
                      imageURL: post.imageURL,
                      placeholder: post.title,
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          spacing: 4,
                          children: <Widget>[
                            Flexible(
                              child: Text(widget.order.orderStatus.code.tr(),
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              child: Text(
                                  maxLines: 1,
                                  DateFormat('yyyy/MM/dd')
                                      .format(widget.order.updatedAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          fontSize: 8,
                                          color:
                                              ColorScheme.of(context).outline)),
                            ),
                          ],
                        ),
                        Text(post.title,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: ColorScheme.of(context).outline)),
                        Row(
                          spacing: 2,
                          children: <Widget>[
                            Flexible(
                              child: Text(post.priceStr,
                                  maxLines: 1,
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ),
                            Flexible(
                              child: Text('Rs+2',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: ColorScheme.of(context)
                                              .secondary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: Column(
                      spacing: 6,
                      children: <Widget>[
                        CustomElevatedButton(
                          mWidth: 60,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          title: 'leave_feedback'.tr(),
                          isLoading: false,
                          onTap: () {},
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                        CustomElevatedButton(
                          mWidth: 60,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          title: 'track_package'.tr(),
                          isLoading: false,
                          onTap: () {},
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Fallback if state type is unexpected
        return SizedBox(
          height: 80,
          child: Center(
            child: Text('Unknown state',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        );
      },
    );
  }
}
