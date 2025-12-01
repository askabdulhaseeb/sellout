import 'package:hive_ce/hive.dart';

part 'color_options_entity.g.dart';

@HiveType(typeId: 53)
class ColorOptionEntity {
  ColorOptionEntity({
    required this.label,
    required this.value,
    required this.shade,
    required this.tag,
  });

  @HiveField(0)
  final String label;

  @HiveField(1)
  final String value;

  @HiveField(2)
  final String shade;

  @HiveField(3)
  final List<String> tag;
}
