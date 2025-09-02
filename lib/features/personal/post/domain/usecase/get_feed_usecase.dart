import '../../../../../core/usecase/usecase.dart';
import '../params/feed_response_params.dart';
import '../params/get_feed_params.dart';
import '../repositories/post_repository.dart';

class GetFeedUsecase implements UseCase<GetFeedResponse, GetFeedParams> {
  GetFeedUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<GetFeedResponse>> call(GetFeedParams params) async {
    return await repository.getFeed(params);
  }
}
