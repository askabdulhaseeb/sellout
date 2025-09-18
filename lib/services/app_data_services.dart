import 'dart:developer';
import '../core/enums/listing/core/listing_type.dart';
import '../core/functions/app_log.dart';
import '../core/sources/data_state.dart';
import '../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';
import 'get_it.dart';

class AppDataService {
  static final AppDataService _instance = AppDataService._internal();
  factory AppDataService() => _instance;
  AppDataService._internal();

  final GetCategoryByEndpointUsecase _usecase =
      GetCategoryByEndpointUsecase(locator());

  Future<void> fetchAllData() async {
    // All endpoints in one list
    final List<String> endpoints = <String>[
      '/category/${ListingType.items.json}?list-id=',
      '/category/${ListingType.clothAndFoot.json}?list-id=',
      '/category/${ListingType.property.json}?list-id=',
      '/category/${ListingType.vehicle.json}?list-id=',
      '/category/${ListingType.pets.json}?list-id=',
      '/category/${ListingType.foodAndDrink.json}?list-id=',
    ];

    for (final String endpoint in endpoints) {
      try {
        final DataState<String> result = await _usecase.call(endpoint);

        if (result is DataSuccess) {
          AppLog.info('Successfully fetched $endpoint');
        } else if (result is DataFailer) {
          AppLog.error('Failed fetching',
              name: 'AppDataService.fetchAllData - failer',
              error: '$endpoint: ${result.exception}');
        }
      } catch (e, s) {
        AppLog.error(' Exception fetching',
            name: 'AppDataService.fetchAllData - catch',
            error: '$endpoint: $e',
            stackTrace: s);
      }
    }

    log('🔹 All dropdown endpoints attempted');
  }
}
