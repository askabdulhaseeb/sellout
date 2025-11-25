import 'package:hive/hive.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
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
    final String userCurrency = LocalAuth.currency;
    for (final CartItemEntity item in items) {
      if (item.inCart) {
        final PostEntity? post = LocalPost().post(item.postID);
        if (post != null) {
          final String postCurrency = post.currency ?? 'GBP';
          final double rate =
              CountryHelper.getExchangeRate(postCurrency, userCurrency);
          final double convertedPrice = post.price * rate;
          tt += (item.quantity * convertedPrice);
        }
      }
    }
    return tt;
  }

  double get saveLaterTotal {
    double tt = 0;
    final String userCurrency = LocalAuth.currency;
    for (final CartItemEntity item in items) {
      if (!item.inCart) {
        final PostEntity? post = LocalPost().post(item.postID);
        if (post != null) {
          final String postCurrency = post.currency ?? 'GBP';
          final double rate =
              CountryHelper.getExchangeRate(postCurrency, userCurrency);
          final double convertedPrice = post.price * rate;
          tt += (item.quantity * convertedPrice);
        }
      }
    }
    return tt;
  }

  int get cartItemsCount =>
      items.where((CartItemEntity item) => item.inCart).length;

  int get saveLaterItemsCount => items.length - cartItemsCount;
}
