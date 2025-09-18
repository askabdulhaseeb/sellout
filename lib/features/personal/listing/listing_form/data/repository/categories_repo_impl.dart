import 'package:flutter/cupertino.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../domain/repository/categories_repo.dart';
import '../models/categories_models.dart/category_model.dart';
import '../sources/local/local_categories.dart';
import '../sources/remote/remote_categories_source.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  CategoriesRepoImpl(this.remoteApi);
  final RemoteCategoriesSource remoteApi;

  @override
  Future<DataState<String>> getCategoriesByEndPoint(String endpoint) async {
    try {
      debugPrint('getCategoriesByEndPoint . CategoriesRepoImpl');

      // 1️⃣ Try fetching from local storage
      final ApiRequestEntity? localData = await LocalRequestHistory()
          .request(endpoint: endpoint, duration: const Duration(days: 7));
      final String? localJson = localData?.encodedData;

      if (localJson != '' && localJson != null) {
        await _processResponse(localJson);
        return DataSuccess<String>(
          localData?.encodedData ?? '',
          'Fetched from local storage',
        );
      }
      final DataState<String> remoteData =
          await remoteApi.fetchCategoriesFromApi(endpoint);

      if (remoteData is DataSuccess<String>) {
        await _processResponse(remoteData.data ?? '');
      }

      return remoteData;
    } catch (e, stc) {
      AppLog.error('Error in getCategoriesByEndPoint:',
          name: 'CategoriesRepoImpl.getCategoriesByEndPoint - catch',
          error: e,
          stackTrace: stc);
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  Future<void> _processResponse(dynamic data) async {
    debugPrint('processing response');
    final CategoriesModel model = CategoriesModel.fromJson(data);
    debugPrint('parsed response in  model');
    await LocalCategoriesSource().saveNonNullFields(model);

    debugPrint('✅ Categories processed & saved locally.');
  }
}
