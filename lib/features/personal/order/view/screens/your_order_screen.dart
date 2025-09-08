import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../post/data/sources/local/local_post.dart';
import '../../domain/params/get_order_params.dart';
import '../../domain/usecase/get_orders_buyer_id.dart';
import '../../domain/entities/order_entity.dart';
import '../order_buyer_screen/widgets/buyer_order_tile.dart';
import '../../../post/domain/entities/post/post_entity.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({super.key});
  static String routeName = 'your-orders-screen';

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  late Future<DataState<List<OrderEntity>>> futureOrders;
  List<OrderEntity> allOrders = <OrderEntity>[];
  List<OrderEntity> filteredOrders = <OrderEntity>[];
  Map<String, PostEntity?> postCache =
      <String, PostEntity?>{}; // cache posts, nullable for loading
  String searchQuery = '';
  final TextEditingController searchController =
      TextEditingController(); // persistent controller

  @override
  void initState() {
    super.initState();
    final String uid = LocalAuth.uid ?? '';
    futureOrders = GetOrderByUidUsecase(locator()).call(
      GetOrderParams(user: GetOrderUserType.buyerId, value: uid),
    );

    // Fetch orders and posts asynchronously
    futureOrders.then((DataState<List<OrderEntity>> dataState) async {
      if (dataState is DataSuccess<List<OrderEntity>>) {
        allOrders = dataState.entity ?? <OrderEntity>[];
        filteredOrders = allOrders;

        // Initialize postCache with nulls (loading state)
        for (final OrderEntity order in allOrders) {
          postCache[order.postId] = null;
        }
        setState(() {});

        // Fetch posts for all orders in the background
        for (final OrderEntity order in allOrders) {
          final PostEntity? post = await LocalPost().getPost(order.postId);
          if (post != null) {
            postCache[order.postId] = post;
            setState(() {}); // update UI once post is available
          }
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterOrders(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
      filteredOrders = allOrders.where((OrderEntity order) {
        final PostEntity? post = postCache[order.postId];
        final String title = post?.title ?? 'loading...';
        return title.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(titleKey: 'your_orders'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Search Tile
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextFormField(
              hint: 'search'.tr(),
              controller: searchController,
              onChanged: filterOrders,
            ),
          ),

          // Orders List
          Expanded(
            child: FutureBuilder<DataState<List<OrderEntity>>>(
              future: futureOrders,
              builder: (BuildContext context,
                  AsyncSnapshot<DataState<List<OrderEntity>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading placeholders
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 10,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      endIndent: 12,
                      indent: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return const BuyerOrderTileLoader();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('something_wrong'.tr()));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('no_data_found'.tr()));
                }

                if (filteredOrders.isEmpty) {
                  return Center(child: Text('no_data_found'.tr()));
                }

                // Show orders
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final OrderEntity order = filteredOrders[index];
                    final PostEntity? post = postCache[order.postId];
                    return BuyerOrderTileWidget(order: order, post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
