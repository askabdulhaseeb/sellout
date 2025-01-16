import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/entity/service/service_entity.dart';
import '../../models/service/service_model.dart';
import 'local_service.dart';

abstract interface class ServiceRemoteApi {
  Future<DataState<ServiceEntity?>> getService(String serviceID);
}

class ServiceRemoteApiImpl implements ServiceRemoteApi {
  @override
  Future<DataState<ServiceEntity?>> getService(String serviceID) async {
    try {
      final String endpoint = '/service/$serviceID';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<ServiceEntity?>(CustomException('na'.tr()));
        }
        final ServiceEntity service = ServiceModel.fromRawJson(raw);
        await LocalService().save(service);
        return DataSuccess<ServiceEntity?>(raw, service);
      } else {
        AppLog.error(
          result.exception.toString(),
          name: 'ServiceRemoteApiImpl.getService - else',
          error: result.exception,
        );
        return DataFailer<ServiceEntity?>(
            result.exception ?? CustomException('something_wrong'.tr()));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'ServiceRemoteApiImpl.getService - catch',
        error: e,
      );
      return DataFailer<ServiceEntity?>(CustomException(e.toString()));
    }
  }
}
