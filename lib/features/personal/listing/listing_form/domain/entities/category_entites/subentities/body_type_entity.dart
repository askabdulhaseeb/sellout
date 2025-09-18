import 'package:hive/hive.dart';
import 'dropdown_option_entity.dart';
part 'body_type_entity.g.dart';

@HiveType(typeId: 77)
class BodyTypeEntity {
  BodyTypeEntity({
    required this.category,
    required this.options,
  });
  @HiveField(0)
  final String category;

  @HiveField(1)
  final List<DropdownOptionEntity> options;

  /// Simple helper — no parsing logic here
  DropdownOptionEntity? getOptionByValue(String value) {
    try {
      return options
          .firstWhere((DropdownOptionEntity opt) => opt.value.value == value);
    } catch (e) {
      return null;
    }
  }
}
