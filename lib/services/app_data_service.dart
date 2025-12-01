import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';
import 'category_data_service.dart';
import '../core/functions/app_log.dart';
import '../core/sources/data_state.dart';
import '../core/widgets/phone_number/data/sources/country_api.dart';
import '../core/widgets/phone_number/data/sources/local_country.dart';
import '../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../features/personal/auth/signin/domain/usecase/refresh_token_usecase.dart';
import 'token_refresh_scheduler.dart';
import 'get_it.dart';

class AppDataService extends WidgetsBindingObserver {
  factory AppDataService() => _instance;
  AppDataService._internal() {
    _tokenRefreshScheduler.start();
    WidgetsBinding.instance.addObserver(this);
  }
  static final AppDataService _instance = AppDataService._internal();

  final CategoryDataService _categoryDataService = CategoryDataService();
  final RefreshTokenUsecase _refreshUsecase = RefreshTokenUsecase(locator());
  final CountryApi _countryApi = locator<CountryApi>();

  final TokenRefreshScheduler _tokenRefreshScheduler = TokenRefreshScheduler(
    onRefresh: () => AppDataService().ensureTokenRefreshed(),
  );

  // Use the category data service for category logic
  Future<void> fetchCategoriesIfEmpty() async {
    await _categoryDataService.ensureCategoriesLoaded();
  }

  // ---------------------------------------------------------------
  // SCHEDULER AND LIFECYCLE
  // ---------------------------------------------------------------
  void setTokenRefreshInterval(Duration interval) {
    _tokenRefreshScheduler.setInterval(interval);
  }

  void stopTokenRefreshScheduler() {
    _tokenRefreshScheduler.stop();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ensureTokenRefreshed();
      fetchCategoriesIfEmpty(); // auto-check on resume if you want
    }
  }

  // ---------------------------------------------------------------
  // TOKEN REFRESH
  // ---------------------------------------------------------------
  Future<void> ensureTokenRefreshed() async {
    try {
      await _refreshUsecase.refreshIfNeeded();
    } catch (e, s) {
      AppLog.error(
        'Exception ensuring token refresh',
        error: e,
        stackTrace: s,
        name: 'AppDataService.ensureTokenRefreshed - catch',
      );
    }
  }

  // ---------------------------------------------------------------
  // Fetch all initial data
  // ---------------------------------------------------------------
  Future<void> fetchAllData() async {
    try {
      await ensureTokenRefreshed();
    } catch (e, s) {
      AppLog.error('Error refreshing token', error: e, stackTrace: s);
    }
    try {
      await _fetchCountries();
    } catch (e, s) {
      AppLog.error('Error fetching countries', error: e, stackTrace: s);
    }
    try {
      await fetchCategoriesIfEmpty();
    } catch (e, s) {
      AppLog.error('Error fetching categories', error: e, stackTrace: s);
    }
  }

  // ---------------------------------------------------------------
  // COUNTRIES
  // ---------------------------------------------------------------
  Future<void> _fetchCountries() async {
    try {
      final DataState<List<CountryEntity>> result = await _countryApi.countries(
        const Duration(days: 7),
      );

      if (result is DataSuccess<List<CountryEntity>>) {
        final List<CountryEntity> processed = await compute(
          _processCountries,
          result.entity ?? [],
        );
        final Box<CountryEntity> box = LocalCountry().localBox;
        for (final c in processed) {
          box.put(c.shortName, c);
        }
        AppLog.info('Countries updated');
        return;
      }

      if (result is DataFailer) {
        AppLog.error(
          'Failed fetching countries',
          error: result.exception,
          name: 'AppDataService._fetchCountries',
        );
      }
    } catch (e, s) {
      AppLog.error(
        'Exception fetching countries',
        error: e,
        stackTrace: s,
        name: 'AppDataService._fetchCountries',
      );
    }
  }

  // Top-level function for isolate
  List<CountryEntity> _processCountries(List<CountryEntity> countries) {
    // Do heavy processing here if needed
    return countries;
  }
}
