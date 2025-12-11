import 'payment_item_shipping_details_entity.dart';

class PaymentItemEntity {
  const PaymentItemEntity({
    required this.name,
    required this.cartItemId,
    required this.sellerId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.imageUrls,
    required this.currencyExchangeRate,
    required this.deliveryPrice,
    required this.shippingDetails,
  });

  final String name;
  final String cartItemId;
  final String sellerId;
  final int quantity;
  final String price;
  final String totalPrice;
  final List<String> imageUrls;
  final double currencyExchangeRate;
  final int deliveryPrice;
  final List<PaymentItemShippingDetailsEntity> shippingDetails;
}
