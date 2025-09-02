import '../../../../../core/usecase/usecase.dart';
import '../repositories/post_repository.dart';

class SavePostUsecase implements UseCase<bool, String> {
  const SavePostUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(String params) async {
    return await repository.savePost(params);
  }
}
