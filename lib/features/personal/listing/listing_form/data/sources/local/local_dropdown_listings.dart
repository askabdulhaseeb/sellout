import 'package:hive/hive.dart';
import '../../../domain/entities/dropdown_listings_entity.dart';

class LocalDropDownListings {
  static const String boxTitle = 'localDropDownListingsBox';

  static Future<Box<DropdownCategoryEntity>> openBox() async {
    return await Hive.openBox<DropdownCategoryEntity>(boxTitle);
  }

  Future<Box<DropdownCategoryEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<DropdownCategoryEntity>(boxTitle);
    }
  }

  static Box<DropdownCategoryEntity> get _box =>
      Hive.box<DropdownCategoryEntity>(boxTitle);

  Future<void> save(String key, DropdownCategoryEntity value) async {
    await _box.put(key, value);
  }

  DropdownCategoryEntity? getCategory(String key) {
    return _box.get(key);
  }

  Future<void> clear() async => await _box.clear();

  List<DropdownCategoryEntity> get allCategories => _box.values.toList();
}
