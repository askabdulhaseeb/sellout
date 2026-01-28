enum NotificationType {
  all(code: 'all', jsonKey: '', cids: <String>[]),
  orders(
    code: 'orders',
    jsonKey: 'new_order',
    cids: <String>[
      'order_status_update',
      'new_order',
      'booking_created',
      'booking_accepted',
    ],
  ),
  requests(
    code: 'requests',
    jsonKey: 'new_chat_message',
    cids: <String>['new_chat_message'],
  ),
  services(
    code: 'services',
    jsonKey: 'booking_created',
    cids: <String>['business_removed', 'business_left'],
  ),
  share(code: 'share', jsonKey: '', cids: <String>['new_chat_message']);

  const NotificationType({
    required this.code,
    required this.jsonKey,
    required this.cids,
  });

  final String code;
  final String jsonKey;
  final List<String> cids;

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
