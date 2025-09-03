import 'package:hive/hive.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../size_color/size_color_entity.dart';
part 'post_cloth_foot_entity.g.dart';

@HiveType(typeId: 68)
class PostClothFootEntity {
  PostClothFootEntity({
    required this.sizeColors,
    required this.sizeChartUrl,
    required this.brand,
  });
  @HiveField(71)
  final List<SizeColorEntity> sizeColors;
  @HiveField(60)
  final AttachmentEntity? sizeChartUrl;
  @HiveField(72)
  final String? brand;
}
