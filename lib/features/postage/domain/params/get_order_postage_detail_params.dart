class GetOrderPostageDetailParam {
  const GetOrderPostageDetailParam({required this.orderId});

  factory GetOrderPostageDetailParam.fromJson(Map<String, dynamic> json) {
    return GetOrderPostageDetailParam(orderId: json['order_id'] ?? '');
  }
  final String orderId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'order_id': orderId};
  }
}
