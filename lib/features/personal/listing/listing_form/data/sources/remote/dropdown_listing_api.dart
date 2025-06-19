import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../domain/entities/dropdown_listings_entity.dart';
import '../local/local_dropdown_listings.dart';

class DropDownListingAPI {
  Future<List<DropdownCategoryEntity>> fetchAndStore(String endpoint) async {
    try {
      final DataState<String> req = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
      );

      if (req is DataSuccess && req.data != null) {
        final List<dynamic> rawData = json.decode(req.data!);
        final List<DropdownCategoryEntity> categories =
            <DropdownCategoryEntity>[];

        for (final data in rawData) {
          for (final MapEntry<String, dynamic> entry
              in (data as Map<String, dynamic>).entries) {
            final DropdownCategoryEntity cat =
                DropdownCategoryEntity.fromMap(entry.key, entry.value);
            await LocalDropDownListings().save(entry.key, cat);
            categories.add(cat);
          }
        }

        return categories;
      } else {
        AppLog.error('DropDownListingAPI: API request failed',
            name: 'DropDownListingAPI');
        return <DropdownCategoryEntity>[];
      }
    } catch (e) {
      AppLog.error('DropDownListingAPI: Exception -> $e',
          name: 'DropDownListingAPI');
      return <DropdownCategoryEntity>[];
    }
  }
}
