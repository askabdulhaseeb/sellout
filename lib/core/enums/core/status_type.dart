import 'package:hive/hive.dart';

part 'status_type.g.dart';

@HiveType(typeId: 35)
enum StatusType {
  @HiveField(0)
  pending('pending', 'pending');

  const StatusType(this.code, this.json);
  final String code;
  final String json;

  static StatusType fromJson(String? map) {
    if (map == null) return StatusType.pending;
    return StatusType.values.firstWhere((StatusType e) => e.code == map);
  }
}
