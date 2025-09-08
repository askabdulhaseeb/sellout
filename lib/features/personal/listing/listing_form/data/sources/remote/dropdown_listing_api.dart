import 'package:flutter/foundation.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../domain/entities/dropdown_listings_entity.dart';
import '../local/local_dropdown_listings.dart';

class DropDownListingAPI {
  Future<List<DropdownCategoryEntity>> fetchAndStore(String endpoint) async {
    AppLog.info(
        'DropDownListingAPI: Starting fetchAndStore for endpoint: $endpoint',
        name: 'DropDownListingAPI');
    debugPrint('🔍 [DropDownListingAPI] Fetching data from: $endpoint');

    try {
      final DataState<String> req = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
      );
      if (req is DataSuccess && req.data != null) {
        debugPrint('✅ [DropDownListingAPI] API call successful');
        AppLog.info('DropDownListingAPI: API call succeeded. Parsing data...',
            name: 'DropDownListingAPI');
        final List<dynamic> rawData = json.decode(req.data!);
        final List<DropdownCategoryEntity> categories =
            <DropdownCategoryEntity>[];

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
                name: 'DropDownListingAPI');
          }
        }
        AppLog.info(
            'DropDownListingAPI: Successfully processed ${categories.length} categories.',
            name: 'DropDownListingAPI');
        debugPrint(
            '🎉 [DropDownListingAPI] Processed ${categories.length} categories');

        return categories;
      } else {
        AppLog.error(
            'DropDownListingAPI: API request failed or returned null data.',
            name: 'DropDownListingAPI');
        debugPrint(
            '⚠️ [DropDownListingAPI] API request failed or returned null data');
        return <DropdownCategoryEntity>[];
      }
    } catch (e, stack) {
      AppLog.error('DropDownListingAPI: Exception -> $e',
          name: 'DropDownListingAPI', stackTrace: stack);
      debugPrint('❌ [DropDownListingAPI] Exception occurred: $e');
      return <DropdownCategoryEntity>[];
    }
  }
}
