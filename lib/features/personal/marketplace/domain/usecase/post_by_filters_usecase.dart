import '../../../../../core/usecase/usecase.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../params/post_by_filter_params.dart';
import '../repository/marketplace_repo.dart';

class GetPostByFiltersUsecase
    implements UseCase<List<PostEntity>, PostByFiltersParams> {
  GetPostByFiltersUsecase(this.repository);
  final MarketPlaceRepo repository;

  @override
  Future<DataState<List<PostEntity>>> call(PostByFiltersParams params) {
    return repository.postByFilters(params);
  }
}
