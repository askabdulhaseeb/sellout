import 'package:hive_ce/hive.dart';
part 'item_condition_type.g.dart';

@HiveType(typeId: 25)
enum ConditionType {
  @HiveField(0)
  newC('new', 'new'),
  @HiveField(1)
  used('used', 'used');

  const ConditionType(this.code, this.json);
  final String code;
  final String json;

  static ConditionType fromJson(String? json) {
    if (json == null) return ConditionType.newC;
    for (final ConditionType item in ConditionType.values) {
      if (item.json == json) return item;
    }
    return ConditionType.newC;
  }

  static List<ConditionType> get list => ConditionType.values;
}
