import 'package:hive/hive.dart';
import 'color_entity.dart';
part 'size_color_entity.g.dart';

@HiveType(typeId: 22)
class SizeColorEntity {
  const SizeColorEntity({
    required this.value,
    required this.colors,
    required this.id,
  });

  @HiveField(0)
  final String value;

  @HiveField(1)
  final List<ColorEntity> colors;

  @HiveField(2)
  final String id;
}
