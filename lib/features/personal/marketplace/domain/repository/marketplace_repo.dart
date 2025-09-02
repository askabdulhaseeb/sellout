import '../../../../../core/sources/data_state.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../entities/location_name_entity.dart';
import '../params/post_by_filter_params.dart';

abstract interface class MarketPlaceRepo {
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(String params);
  Future<DataState<List<PostEntity>>> postByFilters(PostByFiltersParams params);
}
