import '../../../../../attachment/data/attchment_model.dart';
import '../../../domain/entities/post/post_cloth_foot_entity.dart';
import '../size_color/size_color_model.dart';

class PostClothFootModel extends PostClothFootEntity {
  PostClothFootModel({
    
    required super.sizeColors,
    required super.sizeChartUrl,
    required super.brand,
  });

  factory PostClothFootModel.fromJson(Map<String, dynamic> json) {
    return PostClothFootModel(
      sizeColors: (json['size_colors'] as List<dynamic>? ?? [])
          .map((e) => SizeColorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sizeChartUrl: json['size_chart'] == null
          ? null
          : AttachmentModel.fromJson(
              json['size_chart'] as Map<String, dynamic>),
      brand: json['brand']?.toString() ?? '',
    );
  }
}
