import 'package:hive_ce/hive.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../size_color/size_color_entity.dart';
part 'post_cloth_foot_entity.g.dart';

@HiveType(typeId: 68)
class PostClothFootEntity {
  PostClothFootEntity({
    required this.sizeColors,
    required this.sizeChartUrl,
    required this.type,
    required this.brand,
    required this.address,
  });
  @HiveField(71)
  final List<SizeColorEntity> sizeColors;
  @HiveField(60)
  final AttachmentEntity? sizeChartUrl;
  @HiveField(61)
  final String type;
  @HiveField(72)
  final String? brand;
  @HiveField(73)
  final String address;
}
