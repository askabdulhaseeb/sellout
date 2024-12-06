import '../../../../../core/sources/data_state.dart';
import '../entities/review_entity.dart';
import '../param/get_review_param.dart';

abstract interface class ReviewRepository {
  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam params);
}
