import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/local/local_request_history.dart';
import '../../../domain/entities/dropdown_listings_entity.dart';
import '../local/local_dropdown_listings.dart';

class DropDownListingAPI {
  Future<List<DropdownCategoryEntity>> fetchAndStore(String endpoint) async {
    AppLog.info(
      'DropDownListingAPI: Checking LocalRequestHistory for endpoint: $endpoint',
      name: 'DropDownListingAPI',
    );
    debugPrint('🔍 [DropDownListingAPI] Checking cache for: $endpoint');

    try {
      // 1️⃣ — Try to get data from LocalRequestHistory first
      final ApiRequestEntity? cachedData =
          await LocalRequestHistory().request(endpoint: endpoint);

      if (cachedData != null && cachedData.encodedData.isNotEmpty) {
        // Cached data exists
        debugPrint('💾 [DropDownListingAPI] Found cached data for $endpoint');
        AppLog.info(
          'DropDownListingAPI: Using cached data for endpoint: $endpoint',
          name: 'DropDownListingAPI',
        );
        return _parseAndStoreLocally(cachedData.encodedData);
      }

      // 2️⃣ — If no cached data, hit the API
      AppLog.info(
        'DropDownListingAPI: No cached data found. Hitting API for $endpoint',
        name: 'DropDownListingAPI',
      );
      debugPrint('🌐 [DropDownListingAPI] Fetching from API: $endpoint');

      final DataState<String> req = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
      );

      if (req is DataSuccess && req.data != null) {
        // Save API response to local history
        await LocalRequestHistory().request(
          endpoint: endpoint,
          baseURL: '',
          duration: const Duration(days: 7),
        );

        debugPrint('✅ [DropDownListingAPI] API call successful');
        AppLog.info(
          'DropDownListingAPI: API call succeeded. Parsing data...',
          name: 'DropDownListingAPI',
        );

        return _parseAndStoreLocally(req.data!);
      } else {
        AppLog.error(
          'DropDownListingAPI: API request failed or returned null data.',
          name: 'DropDownListingAPI',
        );
        debugPrint(
            '⚠️ [DropDownListingAPI] API request failed or returned null data');
        return <DropdownCategoryEntity>[];
      }
    } catch (e, stack) {
      AppLog.error(
        'DropDownListingAPI: Exception -> $e',
        name: 'DropDownListingAPI',
        stackTrace: stack,
      );
      debugPrint('❌ [DropDownListingAPI] Exception occurred: $e');
      return <DropdownCategoryEntity>[];
    }
  }

  /// Private method to parse JSON data and save locally
  Future<List<DropdownCategoryEntity>> _parseAndStoreLocally(
      String jsonData) async {
    final List<dynamic> rawData = json.decode(jsonData);
    final List<DropdownCategoryEntity> categories = <DropdownCategoryEntity>[];

    for (final data in rawData) {
      for (final MapEntry<String, dynamic> entry
          in (data as Map<String, dynamic>).entries) {
        final DropdownCategoryEntity cat =
            DropdownCategoryEntity.fromDynamic(entry.key, entry.value);
        await LocalDropDownListings().save(entry.key, cat);
        categories.add(cat);

        debugPrint('💾 [DropDownListingAPI] Saved category: ${entry.key}');
        AppLog.info(
          'DropDownListingAPI: Saved category "${entry.key}" to local storage.',
          name: 'DropDownListingAPI',
        );
      }
    }

    debugPrint(
        '🎉 [DropDownListingAPI] Processed ${categories.length} categories');
    return categories;
  }
}
