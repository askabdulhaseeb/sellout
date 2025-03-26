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
      final DataState<dynamic> response = await ApiCall<dynamic>().call(
        baseURL: 'https://maps.googleapis.com/maps/api/place/autocomplete',
        endpoint: '/json?input=${params.input}&key=${params.apiKey}',
        requestType: ApiRequestType.get,
        isAuth: false,
      );


      if (response is DataSuccess) {
final Map<String, dynamic> jsonData = jsonDecode(response.data ?? '');
final List<dynamic> predictions = jsonData['predictions'] ?? <dynamic>[];
        final List<LocationNameModel> locationData = predictions
            .map((json) => LocationNameModel.fromJson(json))
            .toList();


        return DataSuccess('', locationData);
      } else {
        return DataFailer<List<LocationNameModel>>(
            CustomException('Location fetching Failed'));
      }
    } catch (e) {
      return DataFailer<List<LocationNameModel>>(
          CustomException('Location fetching Failed: $e'));
    }
  }
}
