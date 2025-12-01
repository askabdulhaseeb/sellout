import 'package:hive_ce/hive.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../models/color_option_model.dart';

class LocalColors extends LocalHiveBox<ColorOptionEntity> {
  @override
  String get boxName => AppStrings.localColorBox;

  static Box<ColorOptionEntity> get _box =>
      Hive.box<ColorOptionEntity>(AppStrings.localColorBox);

  Future<void> saveAllColors(List<ColorOptionEntity> values) async {
    for (final ColorOptionEntity value in values) {
      await save(value.value, value);
    }
  }

  static Future<Box<ColorOptionEntity>> get openBox async =>
      await Hive.openBox<ColorOptionEntity>(AppStrings.localColorBox);

  /// Return all colors as models
  List<ColorOptionModel> get colors => _box.values
      .map((ColorOptionEntity e) => ColorOptionModel.fromEntity(e))
      .toList();

  ColorOptionEntity? getColor(String hexValue) {
    return _box.get(hexValue);
  }
}
