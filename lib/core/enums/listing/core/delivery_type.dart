import 'package:hive/hive.dart';
part 'delivery_type.g.dart';

@HiveType(typeId: 24)
enum DeliveryType {
  @HiveField(0)
  paid('paid_delivery', 'paid'),
  @HiveField(1)
  freeDelivery('free_delivery', 'free'),
  @HiveField(2)
  collection('collection', 'collection');

  const DeliveryType(this.code, this.json);
  final String code;
  final String json;

  static DeliveryType fromJson(String? json) {
    if (json == null) return DeliveryType.collection;
    for (final DeliveryType item in DeliveryType.values) {
      if (item.json == json) return item;
    }
    return DeliveryType.collection;
  }

  static List<DeliveryType> get list => DeliveryType.values;
}
