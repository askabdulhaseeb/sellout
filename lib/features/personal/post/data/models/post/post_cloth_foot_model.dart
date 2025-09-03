import '../../../../../attachment/data/attchment_model.dart';
import '../../../domain/entities/post/post_cloth_foot_entity.dart';

class PostClothFootModel extends PostClothFootEntity {
  PostClothFootModel({
    required super.sizeColors,
    required super.sizeChartUrl,
    required super.brand,
  });

  factory PostClothFootModel.fromJson(Map<String, dynamic> json) {
    return PostClothFootModel(
      sizeColors: (json['size_colors'] ?? <dynamic>[])
          .map((dynamic e) =>
              e.toString()) // replace with SizeColorModel if needed
          .toList(),
      sizeChartUrl: json['size_chart'] == null
          ? null
          : AttachmentModel.fromJson(json['size_chart']),
      brand: json['brand']?.toString(),
    );
  }
}
