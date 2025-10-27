import 'package:hive/hive.dart';
part 'post_item_entity.g.dart';

@HiveType(typeId: 73)
class PostItemEntity {
  PostItemEntity({required this.address});

  @HiveField(1)
  final String? address;
}
