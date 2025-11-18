import '../../../../../core/sources/data_state.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../params/post_by_filter_params.dart';

abstract interface class MarketPlaceRepo {
  Future<DataState<List<PostEntity>>> postByFilters(PostByFiltersParams params);
}
