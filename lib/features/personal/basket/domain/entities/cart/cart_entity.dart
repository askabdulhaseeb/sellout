import 'package:hive/hive.dart';
import '../../../../post/data/sources/local/local_post.dart';
import 'cart_item_entity.dart';
export 'cart_item_entity.dart';
part 'cart_entity.g.dart';

@HiveType(typeId: 37)
class CartEntity {
  CartEntity({
    required this.updatedAt,
    required this.createdAt,
    required this.cartID,
    required this.items,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  final DateTime updatedAt;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final String cartID;
  @HiveField(3)
  final List<CartItemEntity> items;
  @HiveField(99)
  final DateTime inHiveAt;

  List<CartItemEntity> get cartItems =>
      items.where((CartItemEntity item) => item.inCart).toList();

  List<CartItemEntity> get saveLaterItems =>
      items.where((CartItemEntity item) => !item.inCart).toList();

  double get cartTotal {
    double tt = 0;
    for (final CartItemEntity item in items) {
      if (item.inCart) {
        tt += (item.quantity * (LocalPost().post(item.postID)?.price ?? 0));
      }
    }
    return tt;
  }

  double get saveLaterTotal {
    double tt = 0;
    for (final CartItemEntity item in items) {
      if (!item.inCart) {
        tt += (item.quantity * (LocalPost().post(item.postID)?.price ?? 0));
      }
    }
    return tt;
  }

  int get cartItemsCount =>
      items.where((CartItemEntity item) => item.inCart).length;

  int get saveLaterItemsCount => items.length - cartItemsCount;
}
