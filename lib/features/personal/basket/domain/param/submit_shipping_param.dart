import 'package:flutter/material.dart';

class SubmitShippingParam {
  factory SubmitShippingParam.fromJson(Map<String, dynamic> json) {
    debugPrint('SubmitShippingParam.fromJson: $json');
    return SubmitShippingParam(
      shipping: (json['shipping'] as List<dynamic>)
          .map(
            (dynamic e) =>
                ShippingItemParam.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
  SubmitShippingParam({required this.shipping});

  final List<ShippingItemParam> shipping;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{
      'shipping': shipping.map((ShippingItemParam e) => e.toJson()).toList(),
    };
    debugPrint('SubmitShippingParam.toJson: $result');
    return result;
  }

  @override
  String toString() => 'SubmitShippingParam(shipping: $shipping)';
}

class ShippingItemParam {
  factory ShippingItemParam.fromJson(Map<String, dynamic> json) {
    debugPrint('ShippingItemParam.fromJson: $json');
    return ShippingItemParam(
      cartItemId: json['cart_item_id'] ?? '',
      objectId: json['object_id'] ?? '',
    );
  }
  ShippingItemParam({required this.cartItemId, required this.objectId});

  final String cartItemId;
  final String objectId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{
      'cart_item_id': cartItemId,
      'object_id': objectId,
    };
    debugPrint('ShippingItemParam.toJson: $result');
    return result;
  }

  @override
  String toString() =>
      'ShippingItemParam(cartItemId: $cartItemId, objectId: $objectId)';
}
