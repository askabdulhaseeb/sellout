import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entity/service_category_entity.dart';

class LocalServiceCategory {
  static final String boxTitle = AppStrings.localServiceCategoriesBox;

  static Box<ServiceCategoryENtity> get _box =>
      Hive.box<ServiceCategoryENtity>(boxTitle);

  static Future<Box<ServiceCategoryENtity>> get openBox async =>
      await Hive.openBox<ServiceCategoryENtity>(boxTitle);

  /// Refresh the box if not open
  Future<Box<ServiceCategoryENtity>> refresh() async {
    if (Hive.isBoxOpen(boxTitle)) {
      return _box;
    } else {
      return await Hive.openBox<ServiceCategoryENtity>(boxTitle);
    }
  }

  /// Save a single service category
  Future<void> save(ServiceCategoryENtity value) async {
    await _box.put(value.value, value); // Using 'value' as the unique key
  }

  List<ServiceCategoryENtity> getAllCategories() {
    return all;
  }

  /// Save multiple service categories at once
  Future<void> saveAll(List<ServiceCategoryENtity> categories) async {
    final Map<String, ServiceCategoryENtity> map = {
      for (ServiceCategoryENtity category in categories)
        category.value: category,
    };
    await _box.putAll(map);
  }

  /// Clear all stored categories
  Future<void> clear() async => await _box.clear();

  /// Get a specific service category by id
  ServiceCategoryENtity? getCategory(String id) => _box.get(id);

  /// Get all service categories
  List<ServiceCategoryENtity> get all => _box.values.toList();

  /// Get DataState for a specific category
  DataState<ServiceCategoryENtity> dataState(String id) {
    final ServiceCategoryENtity? category = getCategory(id);
    if (category == null) {
      return DataFailer<ServiceCategoryENtity>(
        CustomException('Loading...'.tr()),
      );
    } else {
      return DataSuccess<ServiceCategoryENtity>('', category);
    }
  }
}
