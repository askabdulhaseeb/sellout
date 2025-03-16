import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../view/params/book_visit_params.dart';

abstract interface class BookVisitApi {
  Future<DataState<bool>> bookvisit(BookVisitParams params);
}

class BookVisitApiImpl implements BookVisitApi {
  @override
  Future<DataState<bool>> bookvisit(BookVisitParams params) async {
    const String endpoint = '/visit/create';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess) {
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ??
              'ERROR - BookVisitRemoteApiImpl.BookVisit',
          name: 'BookVisitRemoteApiImpl.BookVisit - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitRemoteApiImpl.BookVisit - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
