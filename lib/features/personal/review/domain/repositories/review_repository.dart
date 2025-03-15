import '../../../../../core/sources/data_state.dart';
import '../entities/review_entity.dart';
import '../param/create_review_params.dart';
import '../param/get_review_param.dart';

abstract interface class ReviewRepository {
  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam params);
  Future<DataState<bool>> postReview(CreateReviewParams params);

}
