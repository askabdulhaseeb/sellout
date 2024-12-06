import '../../../../../core/extension/string_ext.dart';
import '../../../../attachment/data/attchment_model.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.postID,
    required super.reviewID,
    required super.sellerID,
    required super.businessID,
    required super.serviceID,
    required super.rating,
    required super.title,
    required super.text,
    required super.typeSTR,
    required super.reviewBy,
    // required super.comments,
    required super.fileUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        postID: json['post_id'],
        reviewID: json['review_id'],
        businessID: json['business_id'],
        serviceID: json['service_id'],
        sellerID: json['seller_id'],
        typeSTR: json['review_type'] ?? '',
        reviewBy: json['review_by'] ?? '',
        rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
        text: json['text'] ?? '',
        title: json['title'] ?? '',
        fileUrls: List<AttachmentModel>.from((json['file_urls'] ?? <dynamic>[])
            .map((dynamic x) => AttachmentModel.fromJson(x))),
        // comments:
        //     List<dynamic>.from((json['comments'] ?? <dynamic>[]).map((x) => x)),
        createdAt:
            json['created_at']?.toString().toDateTime() ?? DateTime.now(),
      );
}
