import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/location_name_entity.dart';
import '../models/location_name_model.dart';

abstract class ExploreRemoteSource {
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(String params);
}

class ExploreRemoteSourceImpl implements ExploreRemoteSource {
  @override
  Future<DataState<List<LocationNameModel>>> fetchLocationNames(
      String params) async {
    try {
      final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

      final DataState<dynamic> response = await ApiCall<dynamic>().call(
        baseURL: 'https://maps.googleapis.com/maps/api/place/autocomplete',
        endpoint: '/json?input=$params&key=$apiKey',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (response is DataSuccess) {
        final String rawJson = response.data ?? '';
        final Map<String, dynamic> jsonData = jsonDecode(rawJson);
        final List<dynamic> predictions =
            jsonData['predictions'] ?? <dynamic>[];
        debugPrint(predictions.toString());
        final List<LocationNameModel> locationData = predictions
            .map((json) => LocationNameModel.fromJson(json))
            .toList();

        return DataSuccess<List<LocationNameModel>>('', locationData);
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: 'locationrepositoryimpl.locationbyname - else');

        return DataFailer<List<LocationNameModel>>(
          CustomException('Location fetching Failed'),
        );
      }
    } catch (e, stc) {
      AppLog.error('$e,$stc',
          name: 'locationrepositoryimpl.locationbyname - else');
      return DataFailer<List<LocationNameModel>>(
        CustomException('Location fetching Failed: $e'),
      );
    }
  }
}
