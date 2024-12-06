import '../../../../../core/usecase/usecase.dart';
import '../entities/review_entity.dart';
import '../param/get_review_param.dart';
import '../repositories/review_repository.dart';

class GetReviewsUsecase implements UseCase<List<ReviewEntity>, GetReviewParam> {
  const GetReviewsUsecase(this._repository);
  final ReviewRepository _repository;

  @override
  Future<DataState<List<ReviewEntity>>> call(GetReviewParam params) async {
    try {
      return await _repository.getReviews(params);
    } catch (e) {
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }
}
