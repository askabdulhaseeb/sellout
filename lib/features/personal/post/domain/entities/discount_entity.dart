import 'package:hive_ce_flutter/hive_flutter.dart';

part 'discount_entity.g.dart';

@HiveType(typeId: 21)
class DiscountEntity {
  DiscountEntity({
    required this.twoItems,
    required this.threeItems,
    required this.fiveItems,
  });

  @HiveField(0)
  num twoItems;

  @HiveField(1)
  num threeItems;

  @HiveField(2)
  num fiveItems;

  // copyWith method
  DiscountEntity copyWith({num? twoItems, num? threeItems, num? fiveItems}) {
    return DiscountEntity(
      twoItems: twoItems ?? this.twoItems,
      threeItems: threeItems ?? this.threeItems,
      fiveItems: fiveItems ?? this.fiveItems,
    );
  }
}
