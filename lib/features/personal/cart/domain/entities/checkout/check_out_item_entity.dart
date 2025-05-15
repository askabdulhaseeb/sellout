import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../attachment/data/attchment_model.dart';

class CheckOutItemEntity {
  final String cartItemId;
  final String title;
  final String sellerId;
  final String buyerId;
  final String postId;
  final String postBusinessId;
  final List<AttachmentModel> image;
  final String postCurrency;
  final String buyerCurrency;
  final double currencyExchangeRate;
  final double originalPrice;
  final double price;
  final int quantity;
  final int quantityDifference;
  final double totalPrice;
  final double deliveryPrice;
  final double coreDeliverCharges;
  final ConditionType condition;
  final DeliveryType deliveryType;
  final String postType;
  final double itemGrandTotal;

  CheckOutItemEntity({
    required this.cartItemId,
    required this.title,
    required this.sellerId,
    required this.buyerId,
    required this.postId,
    required this.postBusinessId,
    required this.image,
    required this.postCurrency,
    required this.buyerCurrency,
    required this.currencyExchangeRate,
    required this.originalPrice,
    required this.price,
    required this.quantity,
    required this.quantityDifference,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.coreDeliverCharges,
    required this.condition,
    required this.deliveryType,
    required this.postType,
    required this.itemGrandTotal,
  });
}
