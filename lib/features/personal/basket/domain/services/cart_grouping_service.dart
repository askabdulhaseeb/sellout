import '../../../post/data/sources/local/local_post.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../data/sources/local/local_cart.dart';
import '../../views/screens/shopping/checkout/widgets/checkout_items_list/models/seller_group.dart';

/// Service responsible for grouping cart items by seller.
/// Handles all business logic related to organizing cart items for checkout display.
class CartGroupingService {
  static const String _unknownSeller = 'unknown_seller';

  /// Groups cart items by their seller with associated seller information.
  ///
  /// Returns a list of [SellerGroup] objects, each containing a seller and their items.
  /// Items without valid post or seller information are grouped under 'unknown_seller'.
  Future<List<SellerGroup>> groupItemsBySeller(
    List<CartItemEntity> items,
  ) async {
    // Load all posts for the cart items in parallel
    final List<PostEntity?> posts = await Future.wait(
      items.map((CartItemEntity item) => LocalPost().getPost(item.postID)),
    );

    // Group items and load seller data
    final Map<String, List<CartItemEntity>> sellerItemsMap =
        <String, List<CartItemEntity>>{};
    final Map<String, UserEntity?> sellerMap = <String, UserEntity?>{};

    for (int i = 0; i < items.length; i++) {
      final CartItemEntity item = items[i];
      final PostEntity? post = posts[i];

      if (post != null && post.createdBy.isNotEmpty) {
        await _addItemToSellerGroup(
          post.createdBy,
          item,
          sellerItemsMap,
          sellerMap,
        );
      } else {
        _addItemToUnknownSellerGroup(item, sellerItemsMap, sellerMap);
      }
    }

    // Convert map to list of groups
    return _convertToSellerGroups(sellerItemsMap, sellerMap);
  }

  /// Adds an item to a seller's group, loading seller data if necessary.
  Future<void> _addItemToSellerGroup(
    String sellerId,
    CartItemEntity item,
    Map<String, List<CartItemEntity>> sellerItemsMap,
    Map<String, UserEntity?> sellerMap,
  ) async {
    sellerItemsMap.putIfAbsent(sellerId, () => <CartItemEntity>[]).add(item);

    if (!sellerMap.containsKey(sellerId)) {
      sellerMap[sellerId] = await LocalUser().user(sellerId);
    }
  }

  /// Adds an item to the unknown seller group.
  void _addItemToUnknownSellerGroup(
    CartItemEntity item,
    Map<String, List<CartItemEntity>> sellerItemsMap,
    Map<String, UserEntity?> sellerMap,
  ) {
    sellerItemsMap
        .putIfAbsent(_unknownSeller, () => <CartItemEntity>[])
        .add(item);
    sellerMap.putIfAbsent(_unknownSeller, () => null);
  }

  /// Converts the seller items map to a list of SellerGroup objects.
  List<SellerGroup> _convertToSellerGroups(
    Map<String, List<CartItemEntity>> sellerItemsMap,
    Map<String, UserEntity?> sellerMap,
  ) {
    final List<SellerGroup> groups = <SellerGroup>[];
    sellerItemsMap.forEach((String sellerId, List<CartItemEntity> items) {
      groups.add(SellerGroup(seller: sellerMap[sellerId], items: items));
    });
    return groups;
  }
}
