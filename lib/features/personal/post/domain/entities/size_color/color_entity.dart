import 'package:hive_ce/hive.dart';
part 'color_entity.g.dart';

@HiveType(typeId: 23)
class ColorEntity {
  const ColorEntity({required this.code, required this.quantity});

  @HiveField(0)
  final String code;
  @HiveField(1)
  final int quantity;
}
