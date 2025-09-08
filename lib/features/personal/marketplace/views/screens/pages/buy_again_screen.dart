import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/domain/params/get_order_params.dart';
import '../../../../order/domain/usecase/get_orders_buyer_id.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/post_buy_now_button.dart';
import '../../../../post/post_detail/views/screens/post_detail_screen.dart';

class BuyAgainScreen extends StatefulWidget {
  const BuyAgainScreen({super.key});
  static String routeName = 'buy-again-screen';

  @override
  State<BuyAgainScreen> createState() => _BuyAgainScreenState();
}

class _BuyAgainScreenState extends State<BuyAgainScreen> {
  late Future<DataState<List<OrderEntity>>> futureOrders;
  List<OrderEntity> deliveredOrders = <OrderEntity>[];
  Map<String, PostEntity?> postCache = <String, PostEntity?>{}; // cache posts
  bool postsLoading = true;

  @override
  void initState() {
    super.initState();
    final String uid = LocalAuth.uid ?? '';
    futureOrders = GetOrderByUidUsecase(locator()).call(
      GetOrderParams(
        user: GetOrderUserType.buyerId,
        value: uid,
        status: StatusType.delivered,
      ),
    );

    // Fetch orders and then posts
    futureOrders.then((DataState<List<OrderEntity>> dataState) async {
      if (dataState is DataSuccess<List<OrderEntity>>) {
        deliveredOrders = dataState.entity ?? <OrderEntity>[];

        // Initialize cache with null for loading
        for (final order in deliveredOrders) {
          postCache[order.postId] = null;
        }
        setState(() {});

        // Fetch posts asynchronously
        for (final order in deliveredOrders) {
          final PostEntity? post = await LocalPost().getPost(order.postId);
          if (post != null) {
            postCache[order.postId] = post;
            setState(() {}); // refresh UI
          }
        }
      }
      postsLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(titleKey: 'buy_again'.tr()),
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
            return Center(child: Text('something_wrong'.tr()));
          } else if (!snapshot.hasData) {
            return Center(child: Text('no_data_found'.tr()));
          }

          if (deliveredOrders.isEmpty) {
            return Center(child: Text('no_data_found'.tr()));
          }

          // Build a list of posts for the grid
          final List<PostEntity> posts = deliveredOrders
              .map((order) => postCache[order.postId])
              .whereType<PostEntity>()
              .toList();

          if (posts.isEmpty && postsLoading) {
            // Still loading posts
            return const Center(child: CircularProgressIndicator());
          } else if (posts.isEmpty) {
            return Center(child: Text('no_data_found'.tr()));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _PostGridViewTile(post: posts[index]);
            },
          );
        },
      ),
    );
  }
}

class _PostGridViewTile extends StatelessWidget {
  const _PostGridViewTile({required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: <String, dynamic>{'pid': post.postID},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomNetworkImage(
                fit: BoxFit.cover,
                imageURL: post.imageURL,
              ),
            ),
          ),
          // Title and price section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title
              Text(
                post.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingDisplayWidget(
                          fontSize: 10,
                          size: 12,
                          ratingList: post.listOfReviews ?? <double>[],
                        ),
                        Text(
                          post.priceStr,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PostBuyNowButton(
                    margin: const EdgeInsets.all(0),
                    detailWidgetColor: null,
                    detailWidgetSize: null,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    post: post,
                    detailWidget: false,
                    buyNowColor: Colors.transparent,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    buyNowText: 'buy_again'.tr(),
                    buyNowTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
