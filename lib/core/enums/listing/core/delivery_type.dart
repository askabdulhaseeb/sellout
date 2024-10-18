import 'package:hive/hive.dart';
part 'delivery_type.g.dart';

@HiveType(typeId: 24)
enum DeliveryType {
  @HiveField(0)
  paid('Paid Delivery', 'paid'),
  @HiveField(1)
  freeDelivery('Free Delivery', 'free'),
  @HiveField(2)
  collocation('Collection', 'collection');

  const DeliveryType(this.title, this.json);
  final String title;
  final String json;

  static DeliveryType fromJson(String? json) {
    if (json == null) return DeliveryType.collocation;
    for (final DeliveryType item in DeliveryType.values) {
      if (item.json == json) return item;
    }
    return DeliveryType.collocation;
  }

  static List<DeliveryType> get list => DeliveryType.values;
}
