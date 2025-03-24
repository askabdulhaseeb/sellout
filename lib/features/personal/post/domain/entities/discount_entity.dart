import 'package:hive_flutter/hive_flutter.dart';

part 'discount_entity.g.dart';

@HiveType(typeId: 21)
class DiscountEntity {
  DiscountEntity({
    required this.quantity,
    required this.discount,
  });
  @HiveField(0)
  final int quantity;
  @HiveField(1)
  double discount;

  // this is copyWith method
  DiscountEntity copyWith({
    double? discount,
  }) {
    return DiscountEntity(
      quantity: quantity,
      discount: discount ?? this.discount,
    );
  }
}
