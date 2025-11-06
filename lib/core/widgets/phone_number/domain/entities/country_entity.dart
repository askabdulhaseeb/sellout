import 'package:hive/hive.dart';
part 'country_entity.g.dart';

@HiveType(typeId: 51)
class CountryEntity {
  CountryEntity({
    required this.flag,
    required this.shortName,
    required this.displayName,
    required this.countryName,
    required this.countryCode,
    required this.countryCodes,
    required this.language,
    required this.iosCode,
    required this.isoCode,
    required this.alpha2,
    required this.alpha3,
    required this.numberFormat,
    required this.currency,
    required this.isActive,
    required this.states,
  });

  @HiveField(0)
  final String flag;
  @HiveField(1)
  final String shortName;
  @HiveField(2)
  final String displayName;
  @HiveField(3)
  final String countryName;
  @HiveField(4)
  final String countryCode;
  @HiveField(5)
  final List<String> countryCodes;
  @HiveField(6)
  final String language;
  @HiveField(7)
  final String iosCode;
  @HiveField(8)
  final String isoCode;
  @HiveField(9)
  final String alpha2;
  @HiveField(10)
  final String alpha3;
  @HiveField(11)
  final NumberFormatEntity numberFormat;
  @HiveField(12)
  final List<String> currency;
  @HiveField(13)
  final bool isActive;
  @HiveField(14)
  final List<StateEntity> states;
}

@HiveType(typeId: 84)
class NumberFormatEntity {
  NumberFormatEntity({required this.format, required this.regex});

  @HiveField(0)
  final String format;
  @HiveField(1)
  final String regex;
}

@HiveType(typeId: 85)
class StateEntity {
  StateEntity(
      {required this.stateName, required this.stateCode, required this.cities});

  @HiveField(0)
  final String stateName;
  @HiveField(1)
  final String stateCode;
  @HiveField(2)
  final List<String> cities;
}
