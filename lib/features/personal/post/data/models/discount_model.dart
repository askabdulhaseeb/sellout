import '../../domain/entities/discount_entity.dart';

class DiscountModel extends DiscountEntity {
  DiscountModel({
    required super.twoItems,
    required super.threeItems,
    required super.fiveItems,
  });

  // From JSON
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      twoItems: json['discount_2_item'] ?? 0,
      threeItems: json['discount_3_item'] ?? 0,
      fiveItems: json['discount_5_item'] ?? 0,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'discount_2_item': twoItems,
      'discount_3_item': threeItems,
      'discount_5_item': fiveItems,
    };
  }
}
