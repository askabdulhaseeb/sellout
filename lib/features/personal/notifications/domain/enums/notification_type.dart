enum NotificationType {
  all('all'),
  orders('orders'),
  services('services'),
  requests('requests');

  final String code;
  const NotificationType(this.code);

  String toJson() => code;

  static NotificationType fromJson(String code) {
    return NotificationType.values.firstWhere(
      (NotificationType e) => e.code == code,
      orElse: () => NotificationType.all,
    );
  }

  String get label {
    switch (this) {
      case NotificationType.all:
        return 'all';
      case NotificationType.orders:
        return 'orders';
      case NotificationType.services:
        return 'services';
      case NotificationType.requests:
        return 'requests';
    }
  }
}
