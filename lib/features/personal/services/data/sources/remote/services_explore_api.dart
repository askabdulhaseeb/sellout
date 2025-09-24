import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../business/core/data/models/service/service_model.dart';
import '../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../domain/entity/service_category_entity.dart';
import '../../../domain/params/services_by_filters_params.dart';
import '../../models/service_category_model.dart';
import '../local/local_service_categories.dart';

abstract interface class ServicesExploreApi {
  Future<DataState<List<ServiceEntity>>> specialOffers();
  Future<DataState<List<ServiceCategoryENtity>>> serviceCategories();
  Future<DataState<List<ServiceEntity>>> getServicesbyFilters(
      ServiceByFiltersParams params);
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

  Future<DataState<List<ServiceCategoryENtity>>> serviceCategories() async {
    final List<ServiceCategoryENtity> categories = <ServiceCategoryENtity>[];

    // 1️⃣ Try fetching cached raw data from LocalRequestHistory
    final ApiRequestEntity? cachedRaw = await LocalRequestHistory().request(
      endpoint: 'category/services',
      baseURL: '', // your baseURL
      duration: const Duration(days: 1),
    );

    if (cachedRaw?.decodedData != null && cachedRaw?.decodedData != '') {
      try {
        final dynamic cachedData = cachedRaw?.decodedData;
        final Map<String, dynamic> servicesMap =
            cachedData[0]['services'] ?? <String, dynamic>{};
        servicesMap.forEach((_, dynamic value) {
          final ServiceCategoryENtity category =
              ServiceCategoryModel.fromMap(value);
          categories.add(category);
        });
        return DataSuccess<List<ServiceCategoryENtity>>('cached', categories);
      } catch (e) {
        // if parsing cached data fails, continue to fetch API
      }
    }

    // 2️⃣ Fetch from API if no valid cached data
    try {
      const String endpoint = 'category/services';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
      );
      if (result is DataSuccess) {
        final String? raw = result.data;
        if (raw == null || raw.isEmpty) {
          return DataFailer<List<ServiceCategoryENtity>>(
              CustomException('No data found'));
        }

        final dynamic data = json.decode(raw);
        final Map<String, dynamic> servicesMap =
            data[0]['services'] ?? <String, dynamic>{};

        servicesMap.forEach((_, dynamic value) {
          final ServiceCategoryENtity category =
              ServiceCategoryModel.fromMap(value);
          categories.add(category);
        });
        await LocalServiceCategory().saveAll(categories);
        return DataSuccess<List<ServiceCategoryENtity>>(raw, categories);
      } else {
        return DataFailer<List<ServiceCategoryENtity>>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      return DataFailer<List<ServiceCategoryENtity>>(
          CustomException(e.toString()));
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
  Future<DataState<List<ServiceEntity>>> getServicesbyFilters(
      ServiceByFiltersParams params) async {
    try {
      String endpoint = '/getServices/query?';

      if (params.sort != null) {
        endpoint += 'sort=${params.sort?.json}&';
      }
      if (params.distance != null) {
        endpoint += 'distance=${params.distance}&';
      }
      if (params.query != '') {
        endpoint += 'query=${params.query}&';
      }
      if (params.clientLat != null) {
        endpoint += 'lat=${params.clientLat}&';
      }
      if (params.clientLng != null) {
        endpoint += 'lng=${params.clientLng}&';
      }
      if (params.category != null && params.category!.isNotEmpty) {
        endpoint += 'category=${params.category}&';
      }
      if (params.lastKey != null && params.lastKey!.isNotEmpty) {
        // Append raw lastKey JSON
        endpoint += 'next_key=${params.lastKey}&';
      }
      if (params.filters.isNotEmpty) {
        final String filtersStr = jsonEncode(
          params.filters.map((FilterParam e) => e.toMap()).toList(),
        );
        // Append raw JSON
        endpoint += 'filters=$filtersStr&';
      }

      if (endpoint.endsWith('&')) {
        endpoint = endpoint.substring(0, endpoint.length - 1);
      }
      // 🔧 Fix: Expect response as String
      final DataState<String> result = await ApiCall<String>().call(
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
          return DataFailer<List<ServiceEntity>>(
            CustomException('something_wrong'.tr()),
          );
        }

        final Map<String, dynamic> data = json.decode(raw);
        final List<dynamic> list = data['items'];

        final List<ServiceEntity> servicesList = list
            .map((dynamic item) =>
                ServiceModel.fromJson(item as Map<String, dynamic>))
            .toList();
        final pageKey =
            (data.containsKey('next_key') && data['next_key'] != null)
                ? data['next_key']
                : '';
        return DataSuccess<List<ServiceEntity>>(pageKey, servicesList);
      } else {
        AppLog.error(
          result.exception?.message ?? 'Failed to get services',
          name: 'ServicesExploreApiImpl.getservicesCategories - DataFailer',
          error: result.exception?.message,
        );
        return DataFailer<List<ServiceEntity>>(
          CustomException('something_wrong'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        '',
        name: 'ServicesExploreApiImpl.getservicesCategories - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<List<ServiceEntity>>(
        CustomException(e.toString()),
      );
    }
  }
}
