import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../domain/entities/checkout/check_out_item_entity.dart';

class CheckOutItemModel extends CheckOutItemEntity {
  CheckOutItemModel({
    required super.cartItemId,
    required super.title,
    required super.sellerId,
    required super.buyerId,
    required super.postId,
    required super.postBusinessId,
    required super.image,
    required super.postCurrency,
    required super.buyerCurrency,
    required super.currencyExchangeRate,
    required super.originalPrice,
    required super.price,
    required super.quantity,
    required super.quantityDifference,
    required super.totalPrice,
    required super.deliveryPrice,
    required super.coreDeliverCharges,
    required super.condition,
    required super.deliveryType,
    required super.postType,
    required super.itemGrandTotal,
  });

  factory CheckOutItemModel.fromJson(Map<String, dynamic> json) =>
      CheckOutItemModel(
        cartItemId: json['cart_item_id'] ?? '',
        title: json['title'] ?? '',
        sellerId: json['seller_id'] ?? '',
        buyerId: json['buyer_id'] ?? '',
        postId: json['post_id'] ?? '',
        postBusinessId: json['post_business_id'] ?? '',
        image: List<AttachmentModel>.from((json['image'] ?? <dynamic>[])
            .map((dynamic x) => AttachmentModel.fromJson(x))),
        postCurrency: json['post_currency'] ?? '',
        buyerCurrency: json['buyer_currency'] ?? '',
        currencyExchangeRate: double.tryParse(
                json['currency_exchange_rate']?.toString() ?? '1') ??
            1,
        originalPrice:
            double.tryParse(json['original_price']?.toString() ?? '0.0') ?? 0.0,
        price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
        quantity: json['quantity'] ?? 0,
        quantityDifference: json['quantity_difference'] ?? 0,
        totalPrice:
            double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
        deliveryPrice:
            double.tryParse(json['delivery_price']?.toString() ?? '0.0') ?? 0.0,
        coreDeliverCharges: double.tryParse(
                json['core_deliver_charges']?.toString() ?? '0.0') ??
            0.0,
        condition: ConditionType.fromJson(json['condition']),
        deliveryType: DeliveryType.fromJson(json['delivery_type']),
        postType: json['post_type'] ?? '',
        itemGrandTotal:
            double.tryParse(json['item_grand_total']?.toString() ?? '0.0') ??
                0.0,
      );
}
