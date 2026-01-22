import '../../../../../../../../user/profiles/data/models/user_model.dart';
import '../../../../../../../data/sources/local/local_cart.dart';


/// Represents a group of cart items from a single seller
class SellerGroup {
  SellerGroup({required this.seller, required this.items});

  final UserEntity? seller;
  final List<CartItemEntity> items;
}
