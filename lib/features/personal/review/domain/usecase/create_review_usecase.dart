import '../../../../../core/usecase/usecase.dart';
import '../entities/review_entity.dart';
import '../param/create_review_params.dart';
import '../repositories/review_repository.dart';

class CreateReviewUsecase implements UseCase<bool, CreateReviewParams> {
  CreateReviewUsecase(this.repository);
  final ReviewRepository repository;

  @override
  Future<DataState<bool>> call(CreateReviewParams params) async {
    try {
      final DataState<bool> result = await repository.postReview(params);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Error: $e'));
    }
  }
}