import '../../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetFeedUsecase implements UseCase<List<PostEntity>, void> {
  GetFeedUsecase(this.repository);
  final PostRepository repository;
  
  @override
  Future<DataState<List<PostEntity>>> call(void params) async {
    return await repository.getFeed();
  }
}
