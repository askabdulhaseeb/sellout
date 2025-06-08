import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';
import '../models/search_models.dart';

abstract class SearchRemoteDataSource {
  Future<DataState<SearchEntity>> searchData(
   SearchParams params
  );
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  @override
  Future<DataState<SearchEntity>> searchData(
SearchParams params
  ) async {
    try {
      final String entityTypeStr = params.entityType.name;

      final String endpoint =
          '/search?entity_type=${params.entityType.name}&query=${params.query}&sort_by=best_match&page_size=${params.pageSize}&last_evaluated_key=${params.lastEvaluatedKey}';

      final DataState<String> response = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );

      if (response is DataSuccess<String>) {
        final Map<String, dynamic> jsonData = jsonDecode(response.data!);
        final SearchModel searchModel = SearchModel.fromJson(jsonData, entityTypeStr);
        return DataSuccess<SearchEntity>(response.data!, searchModel);
      } else if (response is DataFailer<String>) {
        return DataFailer<SearchEntity>(response.exception ?? CustomException('Unknown error'));
      } else {
        return DataFailer<SearchEntity>(CustomException('Unknown error'));
      }
    } catch (e) {
      return DataFailer<SearchEntity>(CustomException('Failed to fetch or parse data: $e'));
    }
  }
}
