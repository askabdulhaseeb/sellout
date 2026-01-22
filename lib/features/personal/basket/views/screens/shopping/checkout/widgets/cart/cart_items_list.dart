import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../data/sources/local/local_cart.dart';
import '../../../../../providers/cart_provider.dart';
import 'cart_seller_header.dart';
import 'components/cart_item_tile.dart';

class CartItemsList extends StatefulWidget {
  const CartItemsList({super.key});

  @override
  State<CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends State<CartItemsList> {
  late Future<List<_SellerGroup>> _groupedFuture;

  @override
  void initState() {
    super.initState();
    _groupedFuture = _fetchAndGroup();
  }

  Future<List<_SellerGroup>> _fetchAndGroup() async {
    final CartProvider cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    final List<CartItemEntity> items = cartProvider.cartItems;

    // Use a map to group items by seller
    Map<String, List<CartItemEntity>> sellerItemsMap =
        <String, List<CartItemEntity>>{};
    Map<String, UserEntity?> sellerMap = <String, UserEntity?>{};

    // Load all posts for the cart items
    final List<PostEntity?> posts = await Future.wait(
      items.map((CartItemEntity item) => LocalPost().getPost(item.postID)),
    );

    // Group items by seller
    for (int i = 0; i < items.length; i++) {
      final CartItemEntity item = items[i];
      final PostEntity? post = posts[i];

      if (post != null && post.createdBy.isNotEmpty) {
        final String sellerId = post.createdBy;

        // Add item to seller's group
        sellerItemsMap
            .putIfAbsent(sellerId, () => <CartItemEntity>[])
            .add(item);

        // Load seller info if not already loaded
        if (!sellerMap.containsKey(sellerId)) {
          sellerMap[sellerId] = await LocalUser().user(sellerId);
        }
      } else {
        // Handle items without valid post or seller
        const String unknownSeller = 'unknown_seller';
        sellerItemsMap
            .putIfAbsent(unknownSeller, () => <CartItemEntity>[])
            .add(item);
        sellerMap.putIfAbsent(unknownSeller, () => null);
      }
    }

    // Convert map to list of groups
    List<_SellerGroup> groups = <_SellerGroup>[];
    sellerItemsMap.forEach((String sellerId, List<CartItemEntity> items) {
      groups.add(_SellerGroup(seller: sellerMap[sellerId], items: items));
    });

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_SellerGroup>>(
      future: _groupedFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<_SellerGroup>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<_SellerGroup> groups = snapshot.data ?? <_SellerGroup>[];
            if (groups.isEmpty) {
              return Center(
                child: Text(
                  'Your cart is empty',
                  style: TextTheme.of(context).bodyMedium,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    'items'.tr(),
                    style: TextTheme.of(context).titleMedium,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int groupIndex) {
                    final _SellerGroup group = groups[groupIndex];
                    final UserEntity? seller = group.seller;

                    return ShadowContainer(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (seller != null)
                            CartSellerHeader(
                              seller: seller,
                              itemCount: group.items.length,
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                for (
                                  int i = 0;
                                  i < group.items.length;
                                  i++
                                ) ...<Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    child: CartItemTile(item: group.items[i]),
                                  ),
                                  if (i < group.items.length - 1)
                                    Divider(
                                      height: 1,
                                      color: Colors.grey[200],
                                      indent: AppSpacing.md,
                                      endIndent: AppSpacing.md,
                                    ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
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

class _SellerGroup {
  _SellerGroup({required this.seller, required this.items});
  final UserEntity? seller;
  final List<CartItemEntity> items;
}

// CartItemsList section
// ...existing code will be moved here...
