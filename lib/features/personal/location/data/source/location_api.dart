import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../models/nomination_location_model/nomination_location_model.dart';
import '../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';

abstract class LocationApi {
  Future<DataState<List<NominationLocationEntity>>> fetchNominationLocations(
      String params);
}

class LocationApiImpl extends LocationApi {
  @override
  Future<DataState<List<NominationLocationModel>>> fetchNominationLocations(
      String params) async {
    try {
      final DataState<dynamic> response = await ApiCall<dynamic>().call(
        baseURL: 'https://nominatim.openstreetmap.org',
        endpoint: '/search?q=$params&format=json&addressdetails=1&limit=5',
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
        extraHeader: <String, String>{
          'User-Agent': 'com.selleout.sellout',
        },
      );

      if (response is DataSuccess) {
        dynamic rawData = response.data;

        // ✅ handle if ApiCall already parsed JSON or not
        final List<dynamic> jsonData = rawData is String
            ? jsonDecode(rawData)
            : (rawData as List<dynamic>);

        final List<NominationLocationModel> locationData = jsonData
            .map((json) => NominationLocationModel.fromJson(json))
            .toList();

        return DataSuccess<List<NominationLocationModel>>(
          '', // message (optional, if your DataState supports it)
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
