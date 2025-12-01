import 'package:hive_ce/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entity/service_category_entity.dart';

class LocalServiceCategory {
  static final String boxTitle = AppStrings.localServiceCategoriesBox;

  static Box<ServiceCategoryEntity> get _box =>
      Hive.box<ServiceCategoryEntity>(boxTitle);

  static Future<Box<ServiceCategoryEntity>> get openBox async =>
      await Hive.openBox<ServiceCategoryEntity>(boxTitle);

  /// Refresh the box if not open
  Future<Box<ServiceCategoryEntity>> refresh() async {
    if (Hive.isBoxOpen(boxTitle)) {
      return _box;
    } else {
      return await Hive.openBox<ServiceCategoryEntity>(boxTitle);
    }
  }

  /// Save a single service category
  Future<void> save(ServiceCategoryEntity value) async {
    await _box.put(value.value, value); // Using 'value' as the unique key
  }

  List<ServiceCategoryEntity> getAllCategories() {
    return all;
  }

  /// Save multiple service categories at once
  Future<void> saveAll(List<ServiceCategoryEntity> categories) async {
    final Map<String, ServiceCategoryEntity> map =
        <String, ServiceCategoryEntity>{
          for (ServiceCategoryEntity category in categories)
            category.value: category,
        };
    await _box.putAll(map);
  }

  /// Clear all stored categories
  Future<void> clear() async => await _box.clear();

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
