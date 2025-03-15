import 'package:flutter/material.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/location_name_entity.dart';
import '../../views/params/location_by_name_params.dart';
import '../models/location_name_model.dart';

abstract class ExploreRemoteSource {
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(
      FetchLocationParams params);
}

class ExploreRemoteSourceImpl implements ExploreRemoteSource {
  @override
  Future<DataState<List<LocationNameModel>>> fetchLocationNames(
      FetchLocationParams params) async {
    try {
      final response = await ApiCall<dynamic>().call(
        baseURL: 'https://maps.googleapis.com/maps/api/place/autocomplete',
        endpoint: '/json?input=${params.input}&key=${params.apiKey}',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      debugPrint('${response.data}');

      if (response is DataSuccess) {
        debugPrint('Location fetching Success in Remote Source');
final Map<String, dynamic> jsonData = jsonDecode(response.data ?? '');
final List<dynamic> predictions = jsonData['predictions'] ?? [];
        final List<LocationNameModel> locationData = predictions
            .map((json) => LocationNameModel.fromJson(json))
            .toList();

        debugPrint('Successfully assigned location data: $locationData');

        return DataSuccess('', locationData);
      } else {
        debugPrint(
            'Location fetching Failed in Remote Source - else ${response.data}');
        return DataFailer<List<LocationNameModel>>(
            CustomException('Location fetching Failed'));
      }
    } catch (e) {
      debugPrint('Location fetching Catch in Remote Source - $e');
      return DataFailer<List<LocationNameModel>>(
          CustomException('Location fetching Failed: $e'));
    }
  }
}
