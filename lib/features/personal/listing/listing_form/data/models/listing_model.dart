import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../domain/entities/listing_entity.dart';
import 'sub_category_model.dart';

export '../../domain/entities/listing_entity.dart';

class ListingModel extends ListingEntity {
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['sub_category'] ?? <Map<String, dynamic>>[];
    final List<SubCategoryModel> subCategoryList = <SubCategoryModel>[];
    for (int i = 0; i < data.length; i++) {
      subCategoryList.add(SubCategoryModel.fromJson(data[i]));
    }
    return ListingModel(
      listId: json['list_id'],
      subCategory: subCategoryList,
      parent: json['parent'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? false,
      cid: json['cid'],
      title: json['title'] ?? '',
      type: ListingType.fromStrJson(json['list_id']),
    );
  }

  ListingModel({
    required super.listId,
    required super.subCategory,
    required super.parent,
    required super.isActive,
    required super.cid,
    required super.title,
    required super.type,
    super.address,
  });
}
