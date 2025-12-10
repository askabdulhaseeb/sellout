import 'package:hive_ce/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entity/service_category_entity.dart';

class LocalServiceCategory extends LocalHiveBox<ServiceCategoryEntity> {
   @override
  String get boxName => AppStrings.localServiceCategoriesBox;

  Box<ServiceCategoryEntity> get _box => box;

  static Future<Box<ServiceCategoryEntity>> get openBox async =>
      await Hive.openBox<ServiceCategoryEntity>(AppStrings.localServiceCategoriesBox);

  List<ServiceCategoryEntity> getAllCategories() {
    return all;
  }

  /// Save multiple service categories at once
  Future<void> saveAllServiceCategroies(
    List<ServiceCategoryEntity> categories,
  ) async {
    final Map<String, ServiceCategoryEntity> map =
        <String, ServiceCategoryEntity>{
          for (ServiceCategoryEntity category in categories)
            category.value: category,
        };
    await _box.putAll(map);
  }

  /// Get a specific service category by id
  ServiceCategoryEntity? getCategory(String id) => _box.get(id);

  /// Get all service categories
  List<ServiceCategoryEntity> get all => _box.values.toList();

  /// Get DataState for a specific category
  DataState<ServiceCategoryEntity> dataState(String id) {
    final ServiceCategoryEntity? category = getCategory(id);
    if (category == null) {
      return DataFailer<ServiceCategoryEntity>(
        CustomException('Loading...'.tr()),
      );
    } else {
      return DataSuccess<ServiceCategoryEntity>('', category);
    }
  }
}
