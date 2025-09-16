import 'package:hive/hive.dart';

import 'dropdown_option_data_entity.dart';
part 'dropdown_option_entity.g.dart';

@HiveType(typeId: 75)
class DropdownOptionEntity {
  DropdownOptionEntity({
    required this.label,
    required this.value,
  });

  @HiveField(0)
  final String label;

  @HiveField(1)
  final DropdownOptionDataEntity value;
}
