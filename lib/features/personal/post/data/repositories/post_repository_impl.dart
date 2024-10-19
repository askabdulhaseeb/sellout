import '../../../../../core/sources/data_state.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';
import '../sources/remote/post_remote_api.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.remoteApi);
  final PostRemoteApi remoteApi;

  @override
  Future<DataState<List<PostModel>>> getFeed() async {
    return await remoteApi.getFeed();
  }
}
