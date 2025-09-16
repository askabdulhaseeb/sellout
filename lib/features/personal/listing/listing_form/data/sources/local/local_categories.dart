import 'package:hive/hive.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/category_entites/categories_entity.dart';

class LocalCategoriesSource {
  static String boxTitle = AppStrings.localDropDownListingBox;
  static const String _mainKey = 'categories';

  static Future<Box<CategoriesEntity>> openBox() async {
    return await Hive.openBox<CategoriesEntity>(boxTitle);
  }

  static Box<CategoriesEntity> get _box => Hive.box<CategoriesEntity>(boxTitle);

  Future<void> save(CategoriesEntity value) async {
    await _box.put(_mainKey, value);
  }

  CategoriesEntity? getCategory() => _box.get(_mainKey);

  Future<void> updateCategory(CategoriesEntity newEntity) async {
    await save(newEntity);
  }

  Future<void> clear() async => await _box.clear();
}
