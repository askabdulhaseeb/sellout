import '../../../domain/entities/checkout/order_billing_entity.dart';

class OrderBillingModel extends OrderBillingEntity {
  factory OrderBillingModel.fromMap(Map<String, dynamic> json) {
    return OrderBillingModel(
      billingDetails: BillingDetailsModel.fromMap(json['billingDetails']),
      items: List<OrderItemModel>.from(
        json['items'].map((item) => OrderItemModel.fromMap(item)),
      ),
    );
  }
  OrderBillingModel({
    required super.billingDetails,
    required super.items,
  });
  factory OrderBillingModel.fromEntity(OrderBillingEntity entity) {
    return OrderBillingModel(
        billingDetails: entity.billingDetails, items: entity.items);
  }
}

class BillingDetailsModel extends BillingDetailsEntity {
  factory BillingDetailsModel.fromMap(Map<String, dynamic> json) {
    return BillingDetailsModel(
      subtotal: json['subtotal'],
      deliveryTotal: json['deliveryTotal'],
      grandTotal: json['grandTotal'],
      currency: json['currency'],
    );
  }
  BillingDetailsModel({
    required super.subtotal,
    required super.deliveryTotal,
    required super.grandTotal,
    required super.currency,
  });

  factory BillingDetailsModel.fromEntity(BillingDetailsEntity entity) {
    return BillingDetailsModel(
      subtotal: entity.subtotal,
      deliveryTotal: entity.deliveryTotal,
      grandTotal: entity.grandTotal,
      currency: entity.currency,
    );
  }
  BillingDetailsEntity toEntity() {
    return BillingDetailsEntity(
      subtotal: subtotal,
      deliveryTotal: deliveryTotal,
      grandTotal: grandTotal,
      currency: currency,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'subtotal': subtotal,
        'deliveryTotal': deliveryTotal,
        'grandTotal': grandTotal,
        'currency': currency,
      };
}

class OrderItemModel extends OrderItemEntity {
  factory OrderItemModel.fromMap(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['total_price'],
      imageUrls: List<String>.from(json['image_urls']),
      currencyExchangeRate: (json['currency_exchange_rate'] as num).toDouble(),
      deliveryPrice: json['delivery_price'],
    );
  }
  OrderItemModel({
    required super.name,
    required super.quantity,
    required super.price,
    required super.totalPrice,
    required super.imageUrls,
    required super.currencyExchangeRate,
    required super.deliveryPrice,
  });

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
      totalPrice: entity.totalPrice,
      imageUrls: entity.imageUrls,
      currencyExchangeRate: entity.currencyExchangeRate,
      deliveryPrice: entity.deliveryPrice,
    );
  }
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      name: name,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
      imageUrls: imageUrls,
      currencyExchangeRate: currencyExchangeRate,
      deliveryPrice: deliveryPrice,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'price': price,
        'total_price': totalPrice,
        'image_urls': imageUrls,
        'currency_exchange_rate': currencyExchangeRate,
        'delivery_price': deliveryPrice,
      };
}
