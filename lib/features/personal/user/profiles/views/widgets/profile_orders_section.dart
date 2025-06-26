import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../data/sources/local/local_orders.dart';
import '../../domain/entities/order_entity.dart';
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
  late Future<DataState<List<OrderEntity>?>> _futureOrders;
  List<OrderEntity> allOrders = <OrderEntity>[];

  @override
  void initState() {
    super.initState();

    // ✅ Load initial future once
    final List<OrderEntity> localOrders =
        LocalOrders().getBySeller(widget.user?.uid ?? '');
    final ProfileProvider pro =
        Provider.of<ProfileProvider>(context, listen: false);
    _futureOrders = pro.getOrderByUser(widget.user?.uid ?? '');

    // ✅ Use local as placeholder immediately
    allOrders = localOrders;
  }

  Future<Map<String, PostEntity>> _getPostsMap(List<OrderEntity> orders) async {
    final Map<String, PostEntity> map = <String, PostEntity>{};
    for (final OrderEntity order in orders) {
      final PostEntity? post = await LocalPost().getPost(order.postId);
      if (post != null) {
        map[order.postId] = post;
      }
    }
    return map;
  }

  void _onStatusChanged(StatusType status) {
    setState(() {
      selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<List<OrderEntity>?>>(
      future: _futureOrders,
      initialData: DataSuccess<List<OrderEntity>>('local', allOrders),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<OrderEntity>?>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          return Center(child: Text('no_orders_found'.tr()));
        }

        // ✅ Save full orders only once
        allOrders = snapshot.data!.entity!;

        final List<OrderEntity> filteredOrders = allOrders
            .where(
                (OrderEntity order) => order.orderStatus == selectedStatus.code)
            .toList();

        return Column(
          children: <Widget>[
            OrderStatusToggle(
              initialStatus: selectedStatus,
              onStatusChanged: _onStatusChanged,
            ),
            if (filteredOrders.isEmpty)
              Center(child: Text('no_orders'.tr()))
            else
              FutureBuilder<Map<String, PostEntity>>(
                future: _getPostsMap(filteredOrders),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, PostEntity>> postSnapshot) {
                  if (!postSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ProfileOrderListview(
                      filteredOrders: filteredOrders,
                      postMap: postSnapshot.data!,
                      selectedStatus: selectedStatus,
                    ),
                  );
                },
              ),
          ],
        );
      },
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
        ColorScheme.of(context).outline,
      ],
      isShaded: false,
    );
  }
}

class OrderListBuilder extends StatefulWidget {
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
  State<OrderListBuilder> createState() => _OrderListBuilderState();
}

class _OrderListBuilderState extends State<OrderListBuilder> {
  late Future<DataState<List<OrderEntity>?>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = widget.pro.getOrderByUser(widget.userId);
  }

  Future<Map<String, PostEntity>> _getPostsMap(List<OrderEntity> orders) async {
    final Map<String, PostEntity> map = <String, PostEntity>{};
    for (final OrderEntity order in orders) {
      final PostEntity? post = await LocalPost().getPost(order.postId);
      if (post != null) {
        map[order.postId] = post;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final List<OrderEntity> localOrders =
        LocalOrders().getBySeller(widget.userId);
    final DataState<List<OrderEntity>> localState =
        DataSuccess<List<OrderEntity>>('local', localOrders);

    return FutureBuilder<DataState<List<OrderEntity>?>>(
      future: _futureOrders,
      initialData: localState,
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<OrderEntity>?>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          return Center(child: Text('no_orders_found'.tr()));
        }

        final List<OrderEntity> filteredOrders = snapshot.data!.entity!
            .where((OrderEntity order) =>
                order.orderStatus == widget.selectedStatus.code)
            .toList();
        if (filteredOrders.isEmpty) {
          return Center(child: Text('no_orders'.tr()));
        }

        return FutureBuilder<Map<String, PostEntity>>(
          future: _getPostsMap(filteredOrders),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, PostEntity>> postSnapshot) {
            if (!postSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final Map<String, PostEntity> postMap = postSnapshot.data!;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ProfileOrderListview(
                filteredOrders: filteredOrders,
                postMap: postMap,
                selectedStatus: widget.selectedStatus,
              ),
            );
          },
        );
      },
    );
  }
}
