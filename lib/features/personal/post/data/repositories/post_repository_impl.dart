import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/remote/post_remote_api.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.remoteApi);
  final PostRemoteApi remoteApi;

  @override
  Future<DataState<List<PostEntity>>> getFeed() async {
    return await remoteApi.getFeed();
  }
}
