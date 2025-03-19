import '../../../../attachment/domain/entities/picked_attachment.dart';

class CreateReviewParams {
  CreateReviewParams({
    required this.postId,
    required this.rating,
    required this.title,
    required this.text,
    required this.reviewType,
    this.attachments = const <PickedAttachment>[],
  });

  final String postId;
  final String rating;
  final String title;
  final String text;
  final String reviewType;
  final List<PickedAttachment> attachments; // Include attachments

  Map<String, String>? toMap() {
    return <String, String>{
      'post_id': postId.trim(),
      'rating': rating,
      'title': title.trim(),
      'text': text.trim(),
      'review_type': reviewType,
    };
  }
}
