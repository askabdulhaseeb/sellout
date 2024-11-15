import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';

class CheckOutItemEntity {
  CheckOutItemEntity({
    required this.title,
    required this.postId,
    required this.image,
    required this.price,
    required this.quantity,
    required this.quantityDifference,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.condition,
    required this.deliveryType,
  });
  final String title;
  final String postId;
  final List<AttachmentEntity> image;
  final double price;
  final int quantity;
  final int quantityDifference;
  final double totalPrice;
  final double deliveryPrice;
  final ConditionType condition;
  final DeliveryType deliveryType;
}
