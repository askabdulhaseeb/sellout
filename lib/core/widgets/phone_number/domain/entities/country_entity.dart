import 'package:hive_ce/hive.dart';
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

  factory CountryEntity.empty() => CountryEntity(
    flag: '',
    shortName: '',
    displayName: '',
    countryName: '',
    countryCode: '',
    countryCodes: const <String>[],
    language: '',
    iosCode: '',
    isoCode: '',
    alpha2: '',
    alpha3: '',
    numberFormat: NumberFormatEntity(format: '', regex: ''),
    currency: '',
    isActive: false,
    states: const <StateEntity>[],
  );

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
  final String currency;
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

  @override
  String toString() =>
      'CountryEntity(displayName: $displayName, countryCode: $countryCode)';
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
  StateEntity({
    required this.stateName,
    required this.stateCode,
    required this.cities,
  });

  factory StateEntity.empty() =>
      StateEntity(stateName: '', stateCode: '', cities: const <String>[]);

  /// Creates a StateEntity with the raw state name when lookup fails.
  /// This preserves the original value from the API instead of showing empty.
  factory StateEntity.fromRawName(String rawStateName) => StateEntity(
        stateName: rawStateName.trim(),
        stateCode: '',
        cities: const <String>[],
      );

  @HiveField(0)
  final String stateName;
  @HiveField(1)
  final String stateCode;
  @HiveField(2)
  final List<String> cities;

  /// Returns true if this state entity is empty/not set.
  bool get isEmpty => stateName.isEmpty || stateName == 'na';

  /// Returns true if this state entity has valid data.
  bool get isNotEmpty => !isEmpty;

  /// Returns the display name for UI, handling empty states gracefully.
  /// If state is empty/invalid, returns the fallback (defaults to empty string).
  String displayNameOrFallback({String fallback = ''}) =>
      isEmpty ? fallback : stateName;

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
