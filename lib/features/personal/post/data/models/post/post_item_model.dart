import '../../../domain/entities/post/post_item_entity.dart';

class PostItemModel extends PostItemEntity {
  PostItemModel({required super.address});

  factory PostItemModel.fromJson(Map<String, dynamic> json) {
    return PostItemModel(
      address: json['address']?.toString() ?? '',
    );
  }

  // Map representation for request params (values as strings)
  Map<String, String> toParamMap() => <String, String>{
        'address': address ?? '',
      };
}
