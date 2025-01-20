import 'package:hive/hive.dart';
part 'country_entity.g.dart';

@HiveType(typeId: 51)
class CountryEntity {
  CountryEntity({
    required this.flag,
    required this.shortName,
    required this.displayName,
    required this.countryCode,
    required this.numberFormat,
    required this.currency,
    required this.isActive,
  });

  @HiveField(0)
  final String flag;
  @HiveField(1)
  final String shortName;
  @HiveField(2)
  final String displayName;
  @HiveField(3)
  final String countryCode;
  @HiveField(4)
  final String numberFormat;
  @HiveField(5)
  final List<String> currency;
  @HiveField(6)
  final bool isActive;
}
