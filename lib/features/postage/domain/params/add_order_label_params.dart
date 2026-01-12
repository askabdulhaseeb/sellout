class AddOrderShippingParams {
  AddOrderShippingParams({required this.orderId, required this.objectId});
  final String orderId;
  final String objectId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'order_id': orderId,
    'object_id': objectId,
  };
}
