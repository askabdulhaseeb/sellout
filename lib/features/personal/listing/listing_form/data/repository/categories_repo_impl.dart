import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../domain/repository/categories_repo.dart';
import '../sources/local/local_categories.dart';
import '../sources/remote/remote_categories_source.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  CategoriesRepoImpl({required this.remoteApi});

  final RemoteCategoriesSource remoteApi;

  @override
  Future<DataState<String>> getCategoriesByEndPoint(String endpoint) async {
    try {
      // Fetch local data
      final ApiRequestEntity? localData =
          await LocalRequestHistory().request(endpoint: endpoint);

      if (localData != null && localData.decodedData.isNotEmpty) {
        return DataSuccess<String>(
          localData.decodedData,
          'Fetched from local storage',
        );
      }

      // If no local data, fetch from remote API
      final DataState<String> remoteData =
          await remoteApi.fetchCategoriesFromApi(endpoint);
      if (remoteData is DataSuccess<String>) {
        await LocalCategoriesSource().save(remoteData);
      }

      return remoteData;
    } catch (e) {
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
