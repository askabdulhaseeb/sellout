import 'package:hive/hive.dart';
part 'delivery_type.g.dart';

@HiveType(typeId: 24)
enum DeliveryType {
  @HiveField(0)
  paid('paid_delivery', 'paid', 'paid_delivery_subtitle'),
  @HiveField(1)
  freeDelivery('free_delivery', 'free', 'free_delivery_subtitle'),
  @HiveField(2)
  collection('collection', 'collection', 'collection_delivery_subtitle');

  const DeliveryType(this.code, this.json, this.subtitle);
  final String code;
  final String json;
  final String subtitle;

  static DeliveryType fromJson(String? json) {
    if (json == null) return DeliveryType.collection;
    for (final DeliveryType item in DeliveryType.values) {
      if (item.json == json) return item;
    }
    return DeliveryType.collection;
  }

  static List<DeliveryType> get list => DeliveryType.values;
}
