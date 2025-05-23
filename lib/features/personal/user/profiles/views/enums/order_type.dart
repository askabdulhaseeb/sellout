enum OrderType {
  newOrder(
    'pending',
    'new_order',
  ),

  completed(
    'delivered',
    'completed',
  ),

  cancelled(
    'canceled',
    'canceled',
  );

  const OrderType(
    this.code,
    this.label,
  );

  final String code;
  final String label;

  static OrderType fromJson(String? json) {
    if (json == null) return OrderType.newOrder;
    return OrderType.values.firstWhere(
      (OrderType type) => type.code == json,
      orElse: () => OrderType.newOrder,
    );
  }

  static List<OrderType> get list => OrderType.values;
}
