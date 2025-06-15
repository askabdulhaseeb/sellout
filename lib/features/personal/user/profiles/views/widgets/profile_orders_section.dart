import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import 'list_types/profile_order_listview.dart';

class ProfileOrdersSection extends StatefulWidget {
  const ProfileOrdersSection({super.key, this.user});

  final UserEntity? user;

  @override
  State<ProfileOrdersSection> createState() => _ProfileOrdersSectionState();
}

class _ProfileOrdersSectionState extends State<ProfileOrdersSection> {
  StatusType selectedStatus = StatusType.pending;

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro = Provider.of<ProfileProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          OrderStatusToggle(
            initialStatus: selectedStatus,
            onStatusChanged: (StatusType status) {
              setState(() {
                selectedStatus = status;
              });
            },
          ),
          OrderListBuilder(
            pro: pro,
            userId: widget.user?.uid ?? '',
            selectedStatus: selectedStatus,
          ),
        ],
      ),
    );
  }
}

class OrderStatusToggle extends StatelessWidget {
  const OrderStatusToggle({
    required this.initialStatus,
    required this.onStatusChanged,
    super.key,
  });

  final StatusType initialStatus;
  final ValueChanged<StatusType> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return CustomToggleSwitch<StatusType>(
      seletedFontSize: MediaQuery.of(context).size.width * 0.033,
      labels: const <StatusType>[
        StatusType.pending,
        StatusType.accepted,
        StatusType.rejected,
      ],
      labelStrs: <String>[
        'new_order'.tr(),
        'completed'.tr(),
        'cancelled'.tr(),
      ],
      labelText: '',
      initialValue: initialStatus,
      onToggle: onStatusChanged,
      selectedColors: <Color>[
        AppTheme.primaryColor,
        AppTheme.secondaryColor,
        ColorScheme.of(context).outline
      ],
      isShaded: false,
    );
  }
}

class OrderListBuilder extends StatelessWidget {
  const OrderListBuilder({
    required this.pro,
    required this.userId,
    required this.selectedStatus,
    super.key,
  });

  final ProfileProvider pro;
  final String userId;
  final StatusType selectedStatus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<List<OrderEntity>?>>(
      future: pro.getOrderByUser(userId),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<OrderEntity>?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data?.entity == null) {
          return const Center(child: Text('No orders found.'));
        }

        final List<OrderEntity> filteredOrders = snapshot.data!.entity!
            .where(
                (OrderEntity order) => order.orderStatus == selectedStatus.code)
            .toList();

        if (filteredOrders.isEmpty) {
          return Center(child: Text('no_orders'.tr()));
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ProfileOrderListview(
            filteredOrders: filteredOrders,
            pro: pro,
            selectedStatus: selectedStatus,
          ),
        );
      },
    );
  }
}
