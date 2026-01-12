class ReturnEligibilityParams {
  const ReturnEligibilityParams({
    required this.orderId,
    required this.objectId,
  });

  final String orderId;
  final String objectId;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'order_id': orderId,
    'object_id': objectId,
  };
}
