import '../../../../../core/enums/core/attachment_type.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/enums/review_sort_type.dart';

class ReviewListScreenParam {
  ReviewListScreenParam({
    required this.reviews,
    this.star,
    this.sortType,
    this.attachmentType,
  });

  final int? star;
  final ReviewSortType? sortType;
  final AttachmentType? attachmentType;
  final List<ReviewEntity> reviews;
}
