enum NotificationType {
  all(
    code: 'all',
    jsonKey: 'notifications.all',
    cids: <String>[],
  ),
  orders(
    code: 'orders',
    jsonKey: 'notifications.orders',
    cids: <String>[
      'order_status_update',
      'new_order',
      'booking_created',
      'booking_accepted',
    ],
  ),
  services(
    code: 'services',
    jsonKey: 'notifications.services',
    cids: <String>[
      'business_removed',
      'business_left',
    ],
  ),
  requests(
    code: 'requests',
    jsonKey: 'notifications.requests',
    cids: <String>[
      'new_chat_message',
    ],
  );

  final String code;
  final String jsonKey;
  final List<String> cids;

  const NotificationType({
    required this.code,
    required this.jsonKey,
    required this.cids,
  });

  String toJson() => code;

  static NotificationType fromJson(String code) {
    return NotificationType.values.firstWhere(
      (NotificationType e) => e.code == code,
      orElse: () => NotificationType.all,
    );
  }

  String get label => jsonKey; // You can call `.tr()` in the widget

  bool containsCid(String cid) {
    if (this == NotificationType.all) return true;
    return cids.contains(cid);
  }
}
