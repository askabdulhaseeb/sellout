import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'get_it.dart';
import '../core/functions/app_log.dart';
import '../core/sources/data_state.dart';
import '../core/enums/listing/core/listing_type.dart';
import '../core/widgets/phone_number/data/sources/country_api.dart';
import '../core/widgets/phone_number/data/sources/local_country.dart';
import '../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../features/personal/auth/signin/domain/usecase/refresh_token_usecase.dart';
import '../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';

class AppDataService extends WidgetsBindingObserver {
  factory AppDataService() => _instance;
  AppDataService._internal();
  static final AppDataService _instance = AppDataService._internal();

  final GetCategoryByEndpointUsecase _categoryUsecase =
      GetCategoryByEndpointUsecase(locator());
  final RefreshTokenUsecase _refreshUsecase = RefreshTokenUsecase(locator());
  final CountryApi _countryApi = locator<CountryApi>();

  Timer? _refreshTimer;

  void startTokenRefreshScheduler() {
    // Start periodic refresh every 10 minutes
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await ensureTokenRefreshed();
    });
    // Listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  void stopTokenRefreshScheduler() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      ensureTokenRefreshed();
    }
  }

  Future<void> ensureTokenRefreshed() async {
    try {
      await _refreshUsecase.refreshIfNeeded();
    } catch (e, s) {
      AppLog.error('Exception ensuring token refresh',
          error: e,
          stackTrace: s,
          name: 'AppDataService.ensureTokenRefreshed - catch');
    }
  }

  Future<void> fetchAllData() async {
    await ensureTokenRefreshed();
    await _fetchCountries();
    await _fetchCategories();
  }

  Future<void> _fetchCountries() async {
    try {
      final DataState<List<CountryEntity>> result =
          await _countryApi.countries(const Duration(days: 7));

      if (result is DataSuccess<List<CountryEntity>>) {
        final Box<CountryEntity> box = await LocalCountry.openBox;

        for (final c in result.entity ?? <dynamic>[]) {
          box.put(c.shortName, c);
        }

        AppLog.info('Countries updated');
        return;
      }

      if (result is DataFailer) {
        AppLog.error('Failed fetching countries',
            error: result.exception, name: 'AppDataService._fetchCountries');
      }
    } catch (e, s) {
      AppLog.error('Exception fetching countries',
          error: e, stackTrace: s, name: 'AppDataService._fetchCountries');
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch Category Endpoints
  // ---------------------------------------------------------------------------

  Future<void> _fetchCategories() async {
    final List<String> endpoints = <String>[
      '/category/${ListingType.items.json}?list-id=',
      '/category/${ListingType.clothAndFoot.json}?list-id=',
      '/category/${ListingType.property.json}?list-id=',
      '/category/${ListingType.vehicle.json}?list-id=',
      '/category/${ListingType.pets.json}?list-id=',
      '/category/${ListingType.foodAndDrink.json}?list-id=',
      '/category/services',
    ];

    for (final String endpoint in endpoints) {
      try {
        final DataState<String> result = await _categoryUsecase(endpoint);

        if (result is DataSuccess) {
          AppLog.info('Fetched: $endpoint');
        } else if (result is DataFailer) {
          AppLog.error('Failed fetching $endpoint',
              error: result.exception, name: 'AppDataService._fetchCategories');
        }
      } catch (e, s) {
        AppLog.error('Exception fetching $endpoint',
            error: e, stackTrace: s, name: 'AppDataService._fetchCategories');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Token refresh logic is now fully handled by RefreshTokenUsecase
  // ---------------------------------------------------------------------------
}
