import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/domain/params/get_order_params.dart';
import '../../../../order/domain/usecase/get_orders_buyer_id.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';

class BuyAgainScreen extends StatelessWidget {
  const BuyAgainScreen({super.key});
  static String routeName = 'buy-again-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(titleKey: 'buy_again'.tr()),
        centerTitle: true,
      ),
      body: const BuyAgainSection(),
    );
  }
}

class BuyAgainSection extends StatefulWidget {
  const BuyAgainSection({
    super.key,
    this.shrinkWrap = true,
    this.physics,
  });
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  State<BuyAgainSection> createState() => _BuyAgainSectionState();
}

class _BuyAgainSectionState extends State<BuyAgainSection> {
  late Future<DataState<List<OrderEntity>>> futureOrders;
  List<OrderEntity> deliveredOrders = <OrderEntity>[];
  Map<String, PostEntity?> postCache = <String, PostEntity?>{};
  bool postsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrdersAndPosts();
  }

  void _loadOrdersAndPosts() {
    final String uid = LocalAuth.uid ?? '';

    futureOrders = GetOrderByUidUsecase(locator()).call(
      GetOrderParams(
        user: GetOrderUserType.buyerId,
        value: uid,
        status: StatusType.delivered,
      ),
    );

    futureOrders.then((DataState<List<OrderEntity>> dataState) async {
      try {
        if (dataState is DataSuccess<List<OrderEntity>>) {
          deliveredOrders = dataState.entity ?? <OrderEntity>[];

          // Initialize cache with nulls
          for (final OrderEntity order in deliveredOrders) {
            postCache[order.postId] = null;
          }

          // If the widget was removed from the tree, stop processing.
          if (!mounted) return;
          setState(() {});
          // Load posts one by one. Break early if unmounted to avoid calling
          // setState after dispose and to stop unnecessary work.
          for (final OrderEntity order in deliveredOrders) {
            if (!mounted) break;
            final PostEntity? post = await LocalPost().getPost(order.postId);
            if (!mounted) break;
            if (post != null) {
              postCache[order.postId] = post;
              if (mounted) setState(() {});
            }
          }
        }
      } catch (e) {
        // Swallow/log error as needed. We avoid rethrowing to keep the
        // FutureBuilder happy; the builder will still receive the completed
        // future and render an appropriate UI.
      } finally {
        if (!mounted) return;
      
        postsLoading = false;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPhysics? effectivePhysics = widget.physics ??
        (widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null);

    return FutureBuilder<DataState<List<OrderEntity>>>(
      future: futureOrders,
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<OrderEntity>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: widget.shrinkWrap,
            physics: effectivePhysics,
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (BuildContext context, int index) {
              return const _SkeletonGridViewTile();
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('something_wrong'.tr()));
        } else if (!snapshot.hasData) {
          return Center(child: Text('no_data_found'.tr()));
        }

        if (deliveredOrders.isEmpty) {
          return const Center(
              child: EmptyPageWidget(icon: Icons.shopping_cart_outlined));
        }

        final List<PostEntity> posts = deliveredOrders
            .map((OrderEntity order) => postCache[order.postId])
            .whereType<PostEntity>()
            .toList();

        if (posts.isEmpty && postsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (posts.isEmpty) {
          return Center(child: Text('no_data_found'.tr()));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: widget.shrinkWrap,
          physics: effectivePhysics,
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.66,
          ),
          itemBuilder: (BuildContext context, int index) {
            return const BuyerOrderTileLoader();
          },
        );
      },
    );
  }
}

class _SkeletonGridViewTile extends StatelessWidget {
  const _SkeletonGridViewTile();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image skeleton
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Text and button skeleton
        Container(
          height: 60,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
