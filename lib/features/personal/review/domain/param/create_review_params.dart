
import '../../../../attachment/domain/entities/attachment_entity.dart';

class CreateReviewParams {
  CreateReviewParams({
    required this.postId,
    required this.rating,
    required this.title,
    required this.text,
    required this.reviewType,

  });
  final String postId;
  final double rating;
  final String title;
  final String text;
  final String reviewType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'rating': rating,
      'title': title,
      'text': text,
      'review_type': reviewType,
      
    };
  }
}
