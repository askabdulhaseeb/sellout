import 'dart:async';
import 'get_it.dart';
import 'dart:developer';
import '../core/functions/app_log.dart';
import '../core/sources/data_state.dart';
import '../core/enums/listing/core/listing_type.dart';
import '../core/widgets/phone_number/data/sources/country_api.dart';
import '../core/widgets/phone_number/data/sources/local_country.dart';
import '../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../features/personal/auth/signin/domain/params/refresh_token_params.dart';
import '../features/personal/auth/signin/domain/usecase/refresh_token_usecase.dart';
import '../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';

class AppDataService {
  factory AppDataService() => _instance;
  AppDataService._internal();
  static final AppDataService _instance = AppDataService._internal();
  final GetCategoryByEndpointUsecase _usecase =
      GetCategoryByEndpointUsecase(locator());
  final RefreshTokenUsecase _refreshTokenUsecase =
      RefreshTokenUsecase(locator());
  final CountryApi _countryApi = locator<CountryApi>();
  Timer? _refreshTimer;
  Future<void> fetchAllData() async {
    _ensureRefreshScheduler();
    // All endpoints in one list
    final List<String> endpoints = <String>[
      '/category/${ListingType.items.json}?list-id=',
      '/category/${ListingType.clothAndFoot.json}?list-id=',
      '/category/${ListingType.property.json}?list-id=',
      '/category/${ListingType.vehicle.json}?list-id=',
      '/category/${ListingType.pets.json}?list-id=',
      '/category/${ListingType.foodAndDrink.json}?list-id=',
    ];

    // Fetch country list as well and update local Hive box
    try {
      final DataState<List<CountryEntity>> result =
          await _countryApi.countries(const Duration(days: 7));
      if (result is DataSuccess<List<CountryEntity>>) {
        AppLog.info('Successfully fetched countries');
        // Save to Hive
        final box = await LocalCountry.openBox;
        for (final country in result.entity ?? <CountryEntity>[]) {
          // Use country.shortName or another unique key as Hive key
          box.put(country.shortName, country);
        }
      } else if (result is DataFailer) {
        AppLog.error('Failed fetching countries',
            name: 'AppDataService.fetchAllData - country',
            error: result.exception);
      }
    } catch (e, s) {
      AppLog.error('Exception fetching countries',
          name: 'AppDataService.fetchAllData - country',
          error: e,
          stackTrace: s);
    }

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

  void _ensureRefreshScheduler() {
    if (_refreshTimer != null && _refreshTimer!.isActive) {
      return;
    }

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _scheduleRefresh(),
    );
  }

  void _scheduleRefresh() {
    if (LocalAuth.uid == null) {
      return;
    }

    final String refreshToken = LocalAuth.currentUser?.refreshToken ?? '';
    if (refreshToken.isEmpty) {
      return;
    }

    unawaited(_triggerRefresh(refreshToken));
  }

  Future<void> _triggerRefresh(String refreshToken) async {
    final DataState<String> result = await _refreshTokenUsecase(
      RefreshTokenParams(refreshToken: refreshToken),
    );

    if (result is DataSuccess<String>) {
      AppLog.info('Token refreshed');
      return;
    }

    if (result is DataFailer<String>) {
      AppLog.error('Failed refreshing token',
          name: 'AppDataService._triggerRefresh',
          error: result.exception?.message ?? result.exception);
    }
  }
}
