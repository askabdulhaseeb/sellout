import '../../../../../core/sources/data_state.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../domain/params/post_by_filter_params.dart';
import '../../domain/repository/marketplace_repo.dart';
import '../source/marketplace_remote_source.dart';

class MarketPlaceRepoImpl implements MarketPlaceRepo {
  MarketPlaceRepoImpl(this.remoteSource);
  final MarketPlaceRemoteSource remoteSource;

  @override
  Future<DataState<List<PostEntity>>> postByFilters(
      PostByFiltersParams params) {
    return remoteSource.postByFilters(params);
  }
}
