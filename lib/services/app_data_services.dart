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

class TokenRefreshScheduler {
  TokenRefreshScheduler({
    required this.onRefresh,
    this.refreshInterval = const Duration(minutes: 10),
  });
  final Future<void> Function() onRefresh;
  Duration refreshInterval;
  Timer? _refreshTimer;
  Timer? _remainingTimer;
  DateTime? _nextRefreshTime;

  void setInterval(Duration interval) {
    refreshInterval = interval;
    if (_refreshTimer != null) {
      start();
    }
  }

  void start() {
    _refreshTimer?.cancel();
    _remainingTimer?.cancel();
    _nextRefreshTime = DateTime.now().add(refreshInterval);
    _refreshTimer = Timer.periodic(refreshInterval, (_) async {
      await onRefresh();
      _nextRefreshTime = DateTime.now().add(refreshInterval);
    });
    _remainingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_nextRefreshTime != null) {
        final Duration remaining = _nextRefreshTime!.difference(DateTime.now());
        final int seconds = remaining.inSeconds > 0 ? remaining.inSeconds : 0;
        // ignore: avoid_print
        print('[Token Refresh] Time remaining for next refresh: ${seconds}s');
      }
    });
  }

  void stop() {
    _refreshTimer?.cancel();
    _remainingTimer?.cancel();
  }
}

class AppDataService extends WidgetsBindingObserver {
  factory AppDataService() => _instance;
  AppDataService._internal() {
    // Always start the token refresh scheduler when the service is created
    _tokenRefreshScheduler.start();
    WidgetsBinding.instance.addObserver(this);
  }
  static final AppDataService _instance = AppDataService._internal();

  final GetCategoryByEndpointUsecase _categoryUsecase =
      GetCategoryByEndpointUsecase(locator());
  final RefreshTokenUsecase _refreshUsecase = RefreshTokenUsecase(locator());
  final CountryApi _countryApi = locator<CountryApi>();

  final TokenRefreshScheduler _tokenRefreshScheduler = TokenRefreshScheduler(
    onRefresh: () => AppDataService().ensureTokenRefreshed(),
  );

  void setTokenRefreshInterval(Duration interval) {
    _tokenRefreshScheduler.setInterval(interval);
  }

  // The scheduler is always running. Only stop it if you want to fully shut down (e.g. on logout)
  void stopTokenRefreshScheduler() {
    _tokenRefreshScheduler.stop();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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

        for (final dynamic c in result.entity ?? <dynamic>[]) {
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
