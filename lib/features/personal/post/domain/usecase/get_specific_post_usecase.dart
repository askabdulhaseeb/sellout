import '../../../../../core/usecase/usecase.dart';
import '../entities/post/post_entity.dart';
import '../params/get_specific_post_param.dart';
import '../repositories/post_repository.dart';

export '../params/get_specific_post_param.dart';

class GetSpecificPostUsecase
    implements UseCase<PostEntity, GetSpecificPostParam> {
  const GetSpecificPostUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<PostEntity>> call(GetSpecificPostParam params) async {
    return await repository.getPost(params.postId,
        silentUpdate: params.silentUpdate);
  }
}
