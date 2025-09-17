import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/sources/data_state.dart';

abstract interface class RemoteCategoriesSource {
  Future<DataState<String>> fetchCategoriesFromApi(String endpoint);
}

class RemoteCategoriesSourceImpl implements RemoteCategoriesSource {
  @override
  Future<DataState<String>> fetchCategoriesFromApi(String endpoint) async {
    try {
      final DataState<String> req = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
      );
      if (req is DataSuccess<String>) {
        AppLog.info(
          'RemoteCategoriesSourceImpl.fetchCategoriesFromApi: Success for $endpoint',
          name: 'RemoteCategoriesSourceImpl - fetchCategoriesFromApi . success',
        );
        return DataSuccess<String>(req.data ?? '', req.entity);
      } else if (req is DataFailer<String>) {
        AppLog.error(
          'RemoteCategoriesSourceImpl.fetchCategoriesFromApi: API returned failure for $endpoint',
          name: 'RemoteCategoriesSourceImpl - fetchCategoriesFromApi . failure',
          error: req.exception,
        );
        return req;
      } else {
        AppLog.error(
          'RemoteCategoriesSourceImpl.fetchCategoriesFromApi: Unknown DataState for $endpoint',
          name:
              'RemoteCategoriesSourceImpl - fetchCategoriesFromApi . else block',
        );
        return DataFailer<String>(CustomException(
          'Unknown DataState from API',
        ));
      }
    } catch (e, stack) {
      AppLog.error(
        'RemoteCategoriesSourceImpl.fetchCategoriesFromApi: Exception occurred for $endpoint',
        name:
            'RemoteCategoriesSourceImpl - fetchCategoriesFromApi . catch block',
        error: e,
        stackTrace: stack,
      );
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
