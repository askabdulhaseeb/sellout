class OrderReturnParams {
  const OrderReturnParams({
    required this.orderId,
    required this.reason,
    this.objectId,
  });

  final String orderId;
  final String reason;
  final String? objectId;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'order_id': orderId,
    'reason': reason,
    if (objectId != null) 'object_id': objectId,
  };
}
