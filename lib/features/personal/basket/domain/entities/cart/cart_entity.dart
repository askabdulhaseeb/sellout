import 'package:hive/hive.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
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

  Future<String> cartTotalPriceString() async {
    double tt = 0;
    for (final CartItemEntity item in items) {
      if (item.inCart) {
        final double price =
            await LocalPost().post(item.postID)?.getLocalPrice() ?? 0;
        tt += item.quantity * price;
      }
    }
    return '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}${tt.toStringAsFixed(2)}';
  }
 Future<double> cartTotalPrice() async {
    double total = 0.0;
    for (final CartItemEntity item in items) {
      if (item.inCart) {
        final double price = await LocalPost().post(item.postID)?.getLocalPrice() ?? 0.0;
        total += item.quantity * price;
      }
    }
    return total;
  }
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
