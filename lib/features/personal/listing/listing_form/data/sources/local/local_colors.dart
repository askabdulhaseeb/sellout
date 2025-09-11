import 'package:hive/hive.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../models/color_option_model.dart';

class LocalColors {
  static final String boxTitle = AppStrings.localColorBox;
  static Box<ColorOptionEntity> get _box =>
      Hive.box<ColorOptionEntity>(boxTitle);

  Future<Box<ColorOptionEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ColorOptionEntity>(boxTitle);
    }
  }

  Future<void> saveAll(List<ColorOptionEntity> values) async {
    for (final ColorOptionEntity value in values) {
      await save(value);
    }
  }

  static Future<Box<ColorOptionEntity>> get openBox async =>
      await Hive.openBox<ColorOptionEntity>(boxTitle);

  Future<void> save(ColorOptionEntity value) async =>
      await _box.put(value.value, value); // Use color hex as key

  Future<void> clear() async => await _box.clear();

  /// Return all colors as models
  List<ColorOptionModel> get colors => _box.values
      .map((ColorOptionEntity e) => ColorOptionModel.fromEntity(e))
      .toList();

ColorOptionEntity? getColor(String hexValue) {
  return _box.get(hexValue);
}
}
