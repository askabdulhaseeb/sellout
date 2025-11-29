import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';
import '../models/search_models.dart';

abstract class SearchRemoteDataSource {
  Future<DataState<SearchEntity>> searchData(SearchParams params);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  @override
  Future<DataState<SearchEntity>> searchData(SearchParams params) async {
    try {
      final String entityTypeStr = params.entityType.name;
      final DataState<String> response = await ApiCall<String>().call(
        endpoint: params.endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (response is DataSuccess<String>) {
        final Map<String, dynamic> jsonData = jsonDecode(response.data!);
        final SearchModel searchModel =
            SearchModel.fromJson(jsonData, entityTypeStr);
        return DataSuccess<SearchEntity>(response.data!, searchModel);
      } else if (response is DataFailer<String>) {
        return DataFailer<SearchEntity>(
            response.exception ?? CustomException('Unknown error'));
      } else {
        return DataFailer<SearchEntity>(CustomException('Unknown error'));
      }
    } catch (e) {
      return DataFailer<SearchEntity>(
          CustomException('Failed to fetch or parse data: $e'));
    }
  }
}
