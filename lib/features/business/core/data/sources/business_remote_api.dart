import 'package:flutter/foundation.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../../domain/entity/business_entity.dart';
import '../models/business_model.dart';
import 'local_business.dart';

abstract interface class BusinessCoreAPI {
  Future<DataState<BusinessEntity?>> getBusiness(String businessID);
  Future<DataState<List<BusinessEntity>>> getBusinesses();
}

class BusinessRemoteAPIImpl implements BusinessCoreAPI {
  @override
  Future<DataState<BusinessEntity?>> getBusiness(String businessID) async {
    try {
      final String endpoint = 'business/$businessID';
      final ApiRequestEntity? local = await LocalRequestHistory().request(
        endpoint: endpoint,
        duration:
            kDebugMode ? const Duration(hours: 1) : const Duration(minutes: 5),
      );
      if (local != null) {
        final BusinessEntity business =
            BusinessModel.fromRawJson(local.encodedData);
        return DataSuccess<BusinessEntity?>(local.encodedData, business);
      }
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );
      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty response',
            name: 'BusinessRemoteAPIImpl.getBusiness - empty',
          );
          return DataFailer<BusinessEntity?>(
              CustomException('something_wrong'));
        }
        final BusinessEntity business = BusinessModel.fromRawJson(raw);
        await LocalBusiness().save(business);
        return DataSuccess<BusinessEntity?>(raw, business);
      } else {
        AppLog.error(
          '${result.exception?.message.toString() ?? 'BusinessRemoteAPIImpl.getBusiness - else'} - $businessID',
          error: result.exception,
          name: 'BusinessRemoteAPIImpl.getBusiness - else',
        );
        return DataFailer<BusinessEntity?>(
            result.exception ?? CustomException('something_wrong'));
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        error: e,
        name: 'BusinessRemoteAPIImpl.getBusiness - catch,$stc',
      );
      return DataFailer<BusinessEntity?>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<List<BusinessEntity>>> getBusinesses() {
    throw UnimplementedError();
  }
}
