import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../../../../business/business_page/data/models/services_list_responce_model.dart';
import '../../../../business/business_page/domain/entities/services_list_responce_entity.dart';
import '../../../../business/core/data/models/service/service_model.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../domain/params/get_categorized_services_params.dart';

abstract interface class ServicesExploreApi {
  Future<DataState<List<ServiceEntity>>> specialOffers();
  Future<DataState<ServicesListResponceEntity>> getservicesCategories(
      GetServiceCategoryParams type);
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

  @override
  Future<DataState<ServicesListResponceEntity>> getservicesCategories(
      GetServiceCategoryParams type) async {
    try {
      final String endpoint =
          '/getServices/query?service_category=${type.type.json}';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );
      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty response from server',
            name: 'ServicesExploreApiImpl.getservicesCategories - Raw Empty',
            error: raw,
          );
          return DataFailer<ServicesListResponceEntity>(
              CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(raw);
        final List<dynamic> list = data['items'];
        final List<ServiceEntity> servicesList = <ServiceEntity>[];
        if (list.isEmpty) {
          return DataSuccess<ServicesListResponceEntity>(
            raw,
            ServicesListResponceModel(
              message: data['message'] ?? '',
              nextKey: data['nextKey'],
              services: servicesList,
            ),
          );
        }
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
          name: 'ServicesExploreApiImpl.getservicesCategories - DataFailer',
          error: result.exception?.message,
        );
        return DataFailer<ServicesListResponceEntity>(
            CustomException('something_wrong'));
      }
    } catch (e) {
      AppLog.error(
        '${type.type.json} - ${e.toString()}',
        name: 'ServicesExploreApiImpl.getservicesCategories - catch',
        error: e,
      );
      return DataFailer<ServicesListResponceEntity>(
          CustomException(e.toString()));
    }
  }
}
