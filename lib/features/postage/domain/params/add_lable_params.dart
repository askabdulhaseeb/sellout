class BuyLabelParams {
  const BuyLabelParams({required this.orderId});

  factory BuyLabelParams.fromJson(Map<String, dynamic> json) {
    return BuyLabelParams(orderId: json['order_id'] ?? '');
  }
  final String orderId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'order_id': orderId};
  }
}
