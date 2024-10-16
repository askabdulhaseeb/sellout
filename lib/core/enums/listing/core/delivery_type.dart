enum DeliveryType {
  paid('Paid Delivery', 'paid'),
  freeDelivery('Free Delivery', 'free'),
  collocation('Collection', 'collection');

  const DeliveryType(this.title, this.json);
  final String title;
  final String json;

  static DeliveryType? fromJson(String? json) {
    if (json == null) return null;
    for (final DeliveryType item in DeliveryType.values) {
      if (item.json == json) return item;
    }
    return null;
  }

  static List<DeliveryType> get list => DeliveryType.values;
}
