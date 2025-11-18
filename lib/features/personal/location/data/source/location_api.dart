import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../models/nomination_location_model/nomination_location_model.dart';
import '../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';

abstract class LocationApi {
  Future<DataState<List<NominationLocationEntity>>> fetchNominationLocations(
      String params);
}

class LocationApiImpl extends LocationApi {
  @override
  Future<DataState<List<NominationLocationEntity>>> fetchNominationLocations(
      String params) async {
    final String baseURL = dotenv.env['NOMINATION_API_KEY'] ?? '';
    final String endPoint =
        '/search?q=$params&format=json&addressdetails=1&limit=5';

    try {
      // ✅ Check local cache first
      final ApiRequestEntity? localData = await LocalRequestHistory().request(
        baseURL: baseURL,
        endpoint: endPoint,
        duration: const Duration(days: 7),
      );

      if (localData != null) {
        try {
          final List<dynamic> cachedJson =
              jsonDecode(localData.encodedData) as List<dynamic>;
          final List<NominationLocationModel> cachedLocations = cachedJson
              .map((json) => NominationLocationModel.fromJson(json))
              .toList();

          return DataSuccess<List<NominationLocationModel>>(
            'cached_data',
            cachedLocations,
          );
        } catch (e) {
          AppLog.error('$e',
              name: 'LocationApi.fetchNominationLocations - local decode');
        }
      }
      // ✅ No cache → hit API
      final DataState<dynamic> response = await ApiCall<dynamic>().call(
        baseURL: baseURL,
        endpoint: endPoint,
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
        extraHeader: <String, String>{
          'User-Agent': 'com.selleout.sellout',
        },
      );

      if (response is DataSuccess) {
        dynamic rawData = response.data;
        final List<dynamic> jsonData = rawData is String
            ? jsonDecode(rawData)
            : (rawData as List<dynamic>);

        final List<NominationLocationModel> locationData = jsonData
            .map((json) => NominationLocationModel.fromJson(json))
            .toList();
        return DataSuccess<List<NominationLocationModel>>(
          'fresh_data',
          locationData,
        );
      } else {
        AppLog.error(
          response.exception?.message ?? 'something_wrong'.tr(),
          name: 'LocationApi.fetchNominationLocations - else',
        );
        return DataFailer<List<NominationLocationModel>>(
          CustomException('Location fetching Failed'),
        );
      }
    } catch (e, stc) {
      AppLog.error('$e,$stc',
          name: 'LocationApi.fetchNominationLocations - catch');
      return DataFailer<List<NominationLocationModel>>(
        CustomException('Location fetching Failed: $e'),
      );
    }
  }
}
