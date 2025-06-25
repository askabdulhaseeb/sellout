import '../../../../../../core/usecase/usecase.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../repositories/user_repositories.dart';

class GetPostByIdUsecase implements UseCase<List<PostEntity>, String?> {
  const GetPostByIdUsecase(this.repository);
  final UserProfileRepository repository;

  @override
  Future<DataState<List<PostEntity>>> call(String? params) async {
    return repository.getPostByUser(params);
  }
}
