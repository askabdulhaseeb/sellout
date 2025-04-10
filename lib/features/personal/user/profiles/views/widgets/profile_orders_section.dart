import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../enums/order_type.dart';
import '../providers/profile_provider.dart';
import 'list_types/profile_order_listview.dart';

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
                return Center(child: Text('no_orders'.tr()));
              }
              return SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.5, // Adjust height
                child: ProfileOrderListview(
                    filteredOrders: filteredOrders,
                    pro: pro,
                    selectedStatus: selectedStatus),
              );
            },
          ),
        ],
      ),
    );
  }
}
