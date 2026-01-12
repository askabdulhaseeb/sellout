class OrderReturnParams {
  const OrderReturnParams({
    required this.orderId,
    required this.reason,
    this.objectId,
  });

  final String orderId;
  final String reason;
  final String? objectId;

  Map<String, dynamic> toMap() {
    final String sanitizedOrderId = orderId.trim();
    final String sanitizedReason = reason.trim();
    final String? sanitizedObjectId = objectId?.trim();

    return <String, dynamic>{
      'order_id': sanitizedOrderId,
      'reason': sanitizedReason,
      if (sanitizedObjectId != null && sanitizedObjectId.isNotEmpty)
        'object_id': sanitizedObjectId,
    };
  }
}
