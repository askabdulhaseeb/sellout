import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/params/get_specific_post_param.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../enums/order_type.dart';
import '../providers/profile_provider.dart';

class ProfileOrdersSection extends StatefulWidget {
  const ProfileOrdersSection({super.key, this.user});

  final UserEntity? user;

  @override
  State<ProfileOrdersSection> createState() => _ProfileOrdersSectionState();
}

class _ProfileOrdersSectionState extends State<ProfileOrdersSection> {
  OrderType selectedStatus = OrderType.newOrder;

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro = Provider.of<ProfileProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CustomToggleSwitch<OrderType>(
            labels: OrderType.list,
            labelStrs:
                OrderType.values.map((OrderType e) => e.label.tr()).toList(),
            labelText: '',
            initialValue: selectedStatus,
            onToggle: (OrderType value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),
          FutureBuilder<DataState<List<OrderEntity>?>>(
            future: pro.getOrderByUser(widget.user?.uid ?? ''),
            builder: (BuildContext context,
                AsyncSnapshot<DataState<List<OrderEntity>?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  snapshot.data == null ||
                  snapshot.data!.entity == null) {
                return const Center(child: Text('No orders found.'));
              }
              List<OrderEntity> allOrders = snapshot.data!.entity!;
              List<OrderEntity> filteredOrders =
                  allOrders.where((OrderEntity order) {
                debugPrint('orderStatus: ${order.orderStatus}');
                return order.orderStatus == selectedStatus.code;
              }).toList();
              if (filteredOrders.isEmpty) {
                return const Center(child: Text('No orders in this category.'));
              }
              return SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.5, // Adjust height
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future: pro.getPostByPostId(GetSpecificPostParam(
                          postId: filteredOrders[index].postId)),
                      builder: (BuildContext context,
                          AsyncSnapshot<DataState<PostEntity>> postSnapshot) {
                        if (postSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (postSnapshot.hasError || !postSnapshot.hasData) {
                          return Center(child: Text('something_wrong'.tr()));
                        }

                        final DataState<PostEntity>? post = postSnapshot.data;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CustomNetworkImage(
                                    imageURL: post?.entity?.imageURL ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(post?.entity?.title ?? '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    Text(
                                        '\$${filteredOrders[index].price}', // Assuming price exists
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    Text('sale_completed'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios,
                                    size: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
