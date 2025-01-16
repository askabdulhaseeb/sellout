import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../../../../business/core/data/models/service/service_model.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';

abstract interface class ServicesExploreApi {
  Future<DataState<List<ServiceEntity>>> specialOffers();
}

class ServicesExploreApiImpl implements ServicesExploreApi {
  @override
  Future<DataState<List<ServiceEntity>>> specialOffers() async {
    final List<ServiceEntity> services = <ServiceEntity>[];
    try {
      //
      const String endpoint = 'getServices';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String? raw = result.data;
        if (raw == null || raw.isEmpty) {
          return DataSuccess<List<ServiceEntity>>(
            raw ?? '',
            await _localServices(const Duration(days: 30)),
          );
        }
        final dynamic data = json.decode(raw);
        final List<dynamic> responces = data['response'] ?? <dynamic>[];
        for (dynamic element in responces) {
          final ServiceEntity service = ServiceModel.fromJson(element);
          await LocalService().save(service);
          services.add(service);
        }
        return DataSuccess<List<ServiceEntity>>(raw, services);
      } else {
        return DataFailer<List<ServiceEntity>>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      return DataFailer<List<ServiceEntity>>(CustomException(e.toString()));
    }
  }

  Future<List<ServiceEntity>> _localServices(Duration duration) async {
    const String endpoint = 'getServices';
    final List<ServiceEntity> ser = <ServiceEntity>[];
    final ApiRequestEntity? local = await LocalRequestHistory().request(
      endpoint: endpoint,
      duration: duration,
    );

    if (local == null) return ser;

    final dynamic listt = local.decodedData;
    for (dynamic element in listt) {
      final ServiceEntity service = ServiceModel.fromJson(element);
      ser.add(service);
    }
    return ser;
  }
}
