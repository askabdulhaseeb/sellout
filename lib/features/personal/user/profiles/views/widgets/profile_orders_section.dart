import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../order/data/source/local/local_orders.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/domain/params/get_order_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../order/domain/usecase/get_orders_buyer_id.dart';
import 'list_types/profile_order_tile.dart';
import '../../../../../../../core/widgets/custom_toggle_switch.dart';

class ProfileOrdersSection extends StatefulWidget {
  const ProfileOrdersSection({required this.user, super.key});
  final UserEntity? user;

  @override
  State<ProfileOrdersSection> createState() => _ProfileOrdersSectionState();
}

class _ProfileOrdersSectionState extends State<ProfileOrdersSection> {
  late Future<DataState<List<OrderEntity>>> _futureOrders;
  StatusType selectedStatus = StatusType.pending;

  @override
  void initState() {
    super.initState();
    final String uid = widget.user?.uid ?? LocalAuth.uid ?? '';
    _futureOrders = GetOrderByUidUsecase(locator())(
        GetOrderParams(user: 'seller_id', uid: uid));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<List<OrderEntity>>>(
      future: _futureOrders,
      initialData:
          LocalOrders().orderBySeller(widget.user?.uid ?? LocalAuth.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<OrderEntity>>> snapshot) {
        final List<OrderEntity> allOrders =
            snapshot.data?.entity ?? <OrderEntity>[];
        final List<OrderEntity> filteredOrders = allOrders
            .where((OrderEntity order) =>
                StatusType.fromJson(order.orderStatus).code ==
                selectedStatus.code)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomToggleSwitch<StatusType>(
              isShaded: false,
              selectedColors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
                ColorScheme.of(context).outline
              ],
              seletedFontSize: MediaQuery.of(context).size.width * 0.03,
              labelText: '',
              labels: const <StatusType>[
                StatusType.pending,
                StatusType.completed,
                StatusType.cancelled
              ],
              labelStrs: <String>[
                'new_order'.tr(),
                'completed'.tr(),
                'canceled'.tr(),
              ],
              initialValue: selectedStatus,
              onToggle: (StatusType status) {
                if (selectedStatus != status) {
                  setState(() {
                    selectedStatus = status;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            if (filteredOrders.isEmpty)
              Center(
                child: Text('no_orders_found'.tr()),
              )
            else
              SizedBox(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final OrderEntity order = filteredOrders[index];
                    return ProfileOrderTile(
                      order: order,
                      selectedStatus: selectedStatus,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
