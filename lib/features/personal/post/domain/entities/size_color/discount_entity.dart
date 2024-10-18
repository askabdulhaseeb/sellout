import 'package:hive/hive.dart';
part 'discount_entity.g.dart';

@HiveType(typeId: 21)
class DiscountEntity {
  const DiscountEntity({
    required this.discount3Item,
    required this.discount5Item,
    required this.discount2Item,
  });

  @HiveField(0)
  final int discount3Item;
  @HiveField(1)
  final int discount5Item;
  @HiveField(2)
  final int discount2Item;
}
