import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Ensure this import is added
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/params/get_order_params.dart';
import '../../domain/usecase/get_orders_buyer_id.dart';
import '../../domain/entities/order_entity.dart';
import '../order_buyer_screen/widgets/buyer_order_tile.dart';

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
      GetOrderParams(user: GetOrderUserType.buyerId, value: uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(titleKey: 'your_orders'.tr()),
        centerTitle: true,
      ),
      body: FutureBuilder<DataState<List<OrderEntity>>>(
        future: futureOrders,
        builder: (BuildContext context,
            AsyncSnapshot<DataState<List<OrderEntity>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                return const BuyerOrderTileLoader();
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('something_wrong'.tr()),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text('no_data_found'.tr()));
          }

          final DataState<List<OrderEntity>> dataState = snapshot.data!;

          if (dataState is DataFailer<List<OrderEntity>>) {
            return Center(child: Text('something_wrong'.tr()));
          }

          if (dataState is DataSuccess<List<OrderEntity>>) {
            final List<OrderEntity> orders =
                dataState.entity ?? <OrderEntity>[];

            if (orders.isEmpty) {
              return Center(child: Text('no_data_found'.tr()));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final OrderEntity order = orders[index];
                return BuyerOrderTileWidget(order: order);
              },
            );
          }
          // Fallback for unexpected DataState type
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
