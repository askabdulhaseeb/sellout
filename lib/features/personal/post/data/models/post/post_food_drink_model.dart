import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../domain/entities/post/post_food_drink_entity.dart';

class PostFoodDrinkModel extends PostFoodDrinkEntity {
  PostFoodDrinkModel({required super.type, required super.address});

  factory PostFoodDrinkModel.fromJson(Map<String, dynamic> json) {
    return PostFoodDrinkModel(
      type: json['type']?.toString() ?? ListingType.foodAndDrink.cids.first,
      address: json['address']?.toString() ?? '',
    );
  }

  // Map representation for request params (values as strings)
  Map<String, String> toParamMap() => <String, String>{
        'type': type,
        'address': address ?? '',
      };
}
