import 'package:hive_ce/hive.dart';

import '../../../../../../core/enums/listing/core/listing_type.dart';
import 'sub_category_entity.dart';
part 'listing_entity.g.dart';

@HiveType(typeId: 7)
class ListingEntity {
  ListingEntity({
    required this.listId,
    required this.subCategory,
    required this.parent,
    required this.isActive,
    required this.cid,
    required this.title,
    required this.type,
    this.address,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  String listId;
  @HiveField(1)
  List<SubCategoryEntity> subCategory;
  @HiveField(2)
  String parent;
  @HiveField(3)
  String? address;
  @HiveField(4)
  bool isActive;
  @HiveField(5)
  String cid;
  @HiveField(6)
  String title;
  @HiveField(7)
  ListingType type;
  @HiveField(99)
  final DateTime inHiveAt;
}
