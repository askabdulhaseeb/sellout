import '../../../../attachment/domain/entities/picked_attachment.dart';

class CreateReviewParams {
  CreateReviewParams({
    required this.rating,
    required this.title,
    required this.text,
    required this.reviewType,
    this.postId,
    this.serviceId,
    // this.serviceBusinessId,
    this.attachments = const <PickedAttachment>[],
  });

  final String rating;
  final String title;
  final String text;
  final String reviewType;
  final String? postId;
  final String? serviceId;
  // final String? serviceBusinessId;
  final List<PickedAttachment> attachments;

  Map<String, String>? toMap() {
    return <String, String>{
      'rating': rating,
      'title': title.trim(),
      'text': text.trim(),
      'review_type': reviewType,
      if (postId != null) 'post_id': postId!,
      if (serviceId != null) 'service_id': serviceId!,
      // if (serviceBusinessId != null) 'service_business_id': serviceBusinessId!,
    };
  }
}
