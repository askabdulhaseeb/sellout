import 'package:hive/hive.dart';

import '../../../../../core/enums/cart/cart_item_type.dart';
part 'cart_item_entity.g.dart';

@HiveType(typeId: 38)
class CartItemEntity {
  CartItemEntity({
    required this.quantity,
    required this.postID,
    required this.listID,
    required this.color,
    required this.size,
    required this.cartItemID,
    required this.status,
  });

  @HiveField(0)
  int quantity;
  @HiveField(1)
  final String postID;
  @HiveField(2)
  final String listID;
  @HiveField(3)
  final String? color;
  @HiveField(4)
  final String? size;
  @HiveField(5)
  final String cartItemID;
  @HiveField(6)
  final String status;

  bool get inCart => status == 'cart';
  CartItemType get type => inCart ? CartItemType.cart : CartItemType.saveLater;
}
