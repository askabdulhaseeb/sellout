import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../domain/entities/checkout/check_out_item_entity.dart';

class CheckOutItemModel extends CheckOutItemEntity {
  CheckOutItemModel({
    required super.title,
    required super.postId,
    required super.image,
    required super.price,
    required super.quantity,
    required super.quantityDifference,
    required super.totalPrice,
    required super.deliveryPrice,
    required super.condition,
    required super.deliveryType,
  });

  factory CheckOutItemModel.fromJson(Map<String, dynamic> json) =>
      CheckOutItemModel(
        title: json['title'] ?? '',
        postId: json['post_id'] ?? '',
        image: List<AttachmentModel>.from((json['image'] ?? <dynamic>[])
            .map((dynamic x) => AttachmentModel.fromJson(x))),
        price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0,
        quantity: json['quantity'] ?? 0,
        quantityDifference: json['quantity_difference'] ?? 0,
        totalPrice:
            double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0,
        deliveryPrice:
            double.tryParse(json['delivery_price']?.toString() ?? '0.0') ?? 0,
        condition: ConditionType.fromJson(json['condition']),
        deliveryType: DeliveryType.fromJson(json['delivery_type']),
      );
}
