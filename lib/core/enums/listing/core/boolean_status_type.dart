import 'package:hive/hive.dart';

part 'boolean_status_type.g.dart';

@HiveType(typeId: 31)
enum BooleanStatusType {
  @HiveField(0)
  yes('yes', 'yes'),
  @HiveField(1)
  no('no', 'no');

  const BooleanStatusType(this.code, this.json);
  final String code;
  final String json;

  static BooleanStatusType fromJson(String? value) {
    if (value == null) return BooleanStatusType.no;
    // return BooleanStatusType.values.firstWhere(
    //   (BooleanStatusType element) => element.json == value,
    //   orElse: () => BooleanStatusType.no,
    // );
    switch (value) {
      case 'yes' || 'true':
        return BooleanStatusType.yes;
      case 'no' || 'false':
        return BooleanStatusType.no;
      default:
        return BooleanStatusType.no;
    }
  }
}
