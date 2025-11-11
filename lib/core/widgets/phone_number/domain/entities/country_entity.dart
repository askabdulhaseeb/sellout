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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryEntity &&
        other.countryCode == countryCode &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => countryCode.hashCode ^ displayName.hashCode;
}

@HiveType(typeId: 84)
class NumberFormatEntity {
  NumberFormatEntity({required this.format, required this.regex});

  @HiveField(0)
  final String format;
  @HiveField(1)
  final String regex;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumberFormatEntity &&
        other.format == format &&
        other.regex == regex;
  }

  @override
  int get hashCode => format.hashCode ^ regex.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateEntity &&
        other.stateName == stateName &&
        other.stateCode == stateCode;
  }

  @override
  int get hashCode => stateName.hashCode ^ stateCode.hashCode;
}
