import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/param/create_review_params.dart';
import '../../domain/param/get_review_param.dart';
import '../../domain/repositories/review_repository.dart';
import '../sources/review_remote_api.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this._remoteApi);
  final ReviewRemoteApi _remoteApi;

  @override
  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam params) {
    return _remoteApi.getReviews(params);
  }


  @override
  Future<DataState<bool>> postReview(CreateReviewParams params) {
    return _remoteApi.postReview(params);
  }
}
