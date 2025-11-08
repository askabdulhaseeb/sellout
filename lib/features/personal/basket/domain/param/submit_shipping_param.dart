class SubmitShippingParam {
  SubmitShippingParam({required this.shipping});

  final List<ShippingItemParam> shipping;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'shipping': shipping.map((ShippingItemParam e) => e.toJson()).toList(),
    };
  }

  factory SubmitShippingParam.fromJson(Map<String, dynamic> json) {
    return SubmitShippingParam(
      shipping: (json['shipping'] as List<dynamic>)
          .map((dynamic e) =>
              ShippingItemParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() => 'SubmitShippingParam(shipping: $shipping)';
}

class ShippingItemParam {
  ShippingItemParam({
    required this.cartItemId,
    required this.objectId,
  });

  final String cartItemId;
  final String objectId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cart_item_id': cartItemId,
      'object_id': objectId,
    };
  }

  factory ShippingItemParam.fromJson(Map<String, dynamic> json) {
    return ShippingItemParam(
      cartItemId: json['cart_item_id'] ?? '',
      objectId: json['object_id'] ?? '',
    );
  }

  @override
  String toString() =>
      'ShippingItemParam(cartItemId: $cartItemId, objectId: $objectId)';
}
