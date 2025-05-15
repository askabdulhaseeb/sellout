class OrderBillingEntity {
  OrderBillingEntity({
    required this.clientSecret,
    required this.billingDetails,
    required this.items,
  });
  final String clientSecret;
  final BillingDetailsEntity billingDetails;
  final List<OrderItemEntity> items;
}

class BillingDetailsEntity {
  BillingDetailsEntity({
    required this.subtotal,
    required this.deliveryTotal,
    required this.grandTotal,
    required this.currency,
  });
  final String subtotal;
  final String deliveryTotal;
  final String grandTotal;
  final String currency;
}

class OrderItemEntity {
  OrderItemEntity({
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.imageUrls,
    required this.currencyExchangeRate,
    required this.deliveryPrice,
  });
  final String name;
  final int quantity;
  final String price;
  final String totalPrice;
  final List<String> imageUrls;
  final double currencyExchangeRate;
  final String deliveryPrice;
}
