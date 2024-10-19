import '../../../domain/entities/size_color/discount_entity.dart';

class DiscountModel extends DiscountEntity {
  DiscountModel({
    required super.discount3Item,
    required super.discount5Item,
    required super.discount2Item,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
        discount3Item: json['discount_3_item'] ?? 0,
        discount5Item: json['discount_5_item'] ?? 0,
        discount2Item: json['discount_2_item'] ?? 0,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'discount_3_item': discount3Item,
        'discount_5_item': discount5Item,
        'discount_2_item': discount2Item,
      };
}
