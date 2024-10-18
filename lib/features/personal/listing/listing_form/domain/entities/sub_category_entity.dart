import 'package:hive/hive.dart';
part 'sub_category_entity.g.dart';

@HiveType(typeId: 8)
class SubCategoryEntity {
  SubCategoryEntity({
    required this.parent,
    required this.title,
    required this.listId,
    required this.subCategory,
    required this.cid,
    this.address,
  });

  @HiveField(0)
  String parent;
  @HiveField(1)
  String? address;
  @HiveField(2)
  String title;
  @HiveField(3)
  String listId;
  @HiveField(4)
  List<SubCategoryEntity> subCategory;
  @HiveField(5)
  String cid;
}
