import 'dart:convert';

import '../entities/post_entity.dart';
import '../entities/size_color/color_entity.dart';
import '../entities/size_color/size_color_entity.dart';

class AddToCartParam {
  AddToCartParam({
    required this.post,
    this.size,
    this.color,
    this.quantity = 1,
  });

  final PostEntity post;
  final int quantity;
  final SizeColorEntity? size;
  final ColorEntity? color;

  String addToCart() {
    return json.encode(<String, dynamic>{
      'list_id': post.listId,
      'post_id': post.postId,
      'color': color?.code,
      'size': size?.id,
      'quantity': quantity,
    });
  }
}
