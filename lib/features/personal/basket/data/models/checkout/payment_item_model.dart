import '../../../domain/entities/checkout/payment_item_entity.dart';
import 'shipping_details_model.dart';

class PaymentItemModel extends PaymentItemEntity {
  const PaymentItemModel({
    required super.name,
    required super.cartItemId,
    required super.sellerId,
    required super.quantity,
    required super.price,
    required super.totalPrice,
    required super.imageUrls,
    required super.currencyExchangeRate,
    required super.deliveryPrice,
    required super.shippingDetails,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) =>
      PaymentItemModel(
        name: json['name'] ?? '',
        cartItemId: json['cart_item_id'] ?? '',
        sellerId: json['seller_id'] ?? '',
        quantity: int.tryParse(json['quantity'].toString()) ?? 0,
        price: json['price'] ?? '',
        totalPrice: json['total_price'] ?? '',
        imageUrls: List<String>.from(json['image_urls'] ?? <dynamic>[]),
        currencyExchangeRate: double.tryParse(
                json['currency_exchange_rate']?.toString() ?? '1') ??
            1.0,
        deliveryPrice: int.tryParse(json['delivery_price'].toString()) ?? 0,
        shippingDetails: List<ShippingDetailsModel>.from(
            (json['shipping_details'] ?? <dynamic>[])
                .map((dynamic x) => ShippingDetailsModel.fromJson(x))),
      );
}
