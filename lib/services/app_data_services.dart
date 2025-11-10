import 'dart:async';
import 'dart:developer';
import '../core/enums/listing/core/listing_type.dart';
import '../core/functions/app_log.dart';
import '../core/sources/data_state.dart';
import '../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../features/personal/auth/signin/domain/params/refresh_token_params.dart';
import '../features/personal/auth/signin/domain/usecase/refresh_token_usecase.dart';
import '../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';
import 'get_it.dart';

class AppDataService {
  factory AppDataService() => _instance;
  AppDataService._internal();
  static final AppDataService _instance = AppDataService._internal();
  final GetCategoryByEndpointUsecase _usecase =
      GetCategoryByEndpointUsecase(locator());
  final RefreshTokenUsecase _refreshTokenUsecase =
      RefreshTokenUsecase(locator());
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
