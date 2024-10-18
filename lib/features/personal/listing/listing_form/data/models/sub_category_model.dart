import '../../domain/entities/sub_category_entity.dart';
export '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    required super.parent,
    required super.title,
    required super.listId,
    required super.subCategory,
    required super.cid,
    super.address,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['sub_category'] ?? <Map<String, dynamic>>[];
    final List<SubCategoryModel> subCategoryList = <SubCategoryModel>[];
    for (int i = 0; i < data.length; i++) {
      subCategoryList.add(SubCategoryModel.fromJson(data[i]));
    }
    return SubCategoryModel(
      parent: json['parent'] ?? '',
      address: json['address'] ?? '',
      title: json['title'] ?? '',
      listId: json['list_id'] ?? '',
      subCategory: subCategoryList,
      cid: json['cid'] ?? '',
    );
  }
}
