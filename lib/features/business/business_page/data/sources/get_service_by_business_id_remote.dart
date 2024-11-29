import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../core/data/models/service/service_model.dart';
import '../../../core/data/sources/service/local_service.dart';
import '../../../core/domain/entity/service/service_entity.dart';
import '../../domain/entities/services_list_responce_entity.dart';
import '../models/services_list_responce_model.dart';

abstract interface class GetServiceByBusinessIdRemote {
  Future<DataState<ServicesListResponceEntity>> services(
    String businessId, {
    String? nextKey,
    String sort,
  });
}

class GetServiceByBusinessIdRemoteImpl implements GetServiceByBusinessIdRemote {
  @override
  Future<DataState<ServicesListResponceEntity>> services(
    String businessId, {
    String? nextKey,
    String sort = 'lowToHigh',
  }) async {
    try {
      final String endpoint =
          '/getServices/query?business_id=$businessId&sort=$sort';

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty response from server',
            name: 'GetServiceByBusinessIdRemoteImpl.services - Raw Empty',
            error: raw,
          );
          return DataFailer<ServicesListResponceEntity>(
              CustomException('something-wrong'.tr()));
        }
        final dynamic data = json.decode(raw);
        final List<dynamic> list = data['items'];
        final List<ServiceEntity> servicesList = <ServiceEntity>[];

        for (dynamic element in list) {
          final ServiceEntity service = ServiceModel.fromJson(element);
          await LocalService().save(service);
          servicesList.add(service);
        }
        return DataSuccess<ServicesListResponceEntity>(
            raw,
            ServicesListResponceModel(
              message: data['message'] ?? '',
              nextKey: data['nextKey'],
              services: servicesList,
            ));
      } else {
        AppLog.error(
          result.exception?.message ?? 'Failed to get services',
          name: 'GetServiceByBusinessIdRemoteImpl.services - DataFailer',
          error: result.exception?.message,
        );
        return DataFailer<ServicesListResponceEntity>(
            CustomException('something-wrong'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'GetServiceByBusinessIdRemoteImpl.services - catch',
        error: e,
      );
      return DataFailer<ServicesListResponceEntity>(
          CustomException(e.toString()));
    }
  }
}
