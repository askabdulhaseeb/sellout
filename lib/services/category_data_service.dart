import 'package:hive/hive.dart';
import '../../features/personal/listing/listing_form/data/sources/local/local_categories.dart';
import '../../features/personal/listing/listing_form/domain/entities/category_entites/categories_entity.dart';
import '../../core/functions/app_log.dart';
import '../../core/enums/listing/core/listing_type.dart';
import '../../core/sources/data_state.dart';
import '../../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';
import 'get_it.dart';

class CategoryDataService {
  factory CategoryDataService() => _instance;
  CategoryDataService._internal();
  static final CategoryDataService _instance = CategoryDataService._internal();

  final GetCategoryByEndpointUsecase _categoryUsecase =
      GetCategoryByEndpointUsecase(locator());

  /// Checks if local categories are empty and fetches if needed.
  Future<void> ensureCategoriesLoaded() async {
    try {
      final Box<CategoriesEntity> box = await LocalCategoriesSource().refresh();
      if (box.isEmpty) {
        AppLog.info('Categories empty → fetching...');
        await fetchCategories();
      } else {
        AppLog.info('Categories already exist → skipping fetch');
      }
    } catch (e, s) {
      AppLog.error('Error checking categories box',
          error: e,
          stackTrace: s,
          name: 'CategoryDataService.ensureCategoriesLoaded');
    }
  }

  /// Fetches all category endpoints and logs results.
  Future<void> fetchCategories() async {
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
              error: result.exception,
              name: 'CategoryDataService.fetchCategories');
        }
      } catch (e, s) {
        AppLog.error('Exception fetching $endpoint',
            error: e,
            stackTrace: s,
            name: 'CategoryDataService.fetchCategories');
      }
    }
  }
}
