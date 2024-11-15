import 'dart:convert';

import '../../../domain/entities/cart/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.quantity,
    required super.postID,
    required super.listID,
    required super.color,
    required super.size,
    required super.cartItemID,
    required super.status,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        quantity: json['quantity'] ?? 0,
        postID: json['post_id'] ?? '',
        listID: json['list_id'] ?? '',
        color: json['color'],
        size: json['size'],
        cartItemID: json['cart_item_id'],
        status: json['status'],
      );

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
        quantity: entity.quantity,
        postID: entity.postID,
        listID: entity.listID,
        color: entity.color,
        size: entity.size,
        cartItemID: entity.cartItemID,
        status: entity.status,
      );

  String moveTocart() =>
      json.encode(<String, dynamic>{'quantity': super.quantity});
}
