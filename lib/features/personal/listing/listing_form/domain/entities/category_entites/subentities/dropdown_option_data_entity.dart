import 'package:hive/hive.dart';
part 'dropdown_option_data_entity.g.dart';

@HiveType(typeId: 76)
class DropdownOptionDataEntity {
  DropdownOptionDataEntity({
    required this.label,
    required this.value,
    this.no,
  });
  @HiveField(0)
  final String label;
  @HiveField(1)
  final String value;
  @HiveField(2)
  final String? no;
}
