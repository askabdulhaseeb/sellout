import 'package:hive_ce/hive.dart';
import 'dropdown_option_entity.dart';
part 'parent_dropdown_entity.g.dart';

@HiveType(typeId: 81)
class ParentDropdownEntity {
  ParentDropdownEntity({required this.category, required this.options});

  @HiveField(0)
  final String category;

  @HiveField(1)
  final List<DropdownOptionEntity> options;

  /// Simple helper — no parsing logic here
  static DropdownOptionEntity? getOptionByValue(
    String value,
    List<DropdownOptionEntity> options,
  ) {
    try {
      return options.firstWhere(
        (DropdownOptionEntity opt) => opt.value.value == value,
      );
    } catch (e) {
      return null;
    }
  }
}
