class UpdateOrderParams {
  // optional

  UpdateOrderParams({
    required this.orderId,
    required this.status,
    this.reason,
  });
  final String orderId;
  final String status; // 'processing', 'shipped', 'delivered', 'canceled'
  final String? reason;

  Map<String, dynamic> toMap() {
    final Map<String, String> map = <String, String>{
      'order_id': orderId,
      'status': status,
    };

    if (reason != null) {
      map['reason'] = reason ?? '';
    }

    return map;
  }
}
