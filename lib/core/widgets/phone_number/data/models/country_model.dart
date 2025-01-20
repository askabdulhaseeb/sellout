import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.flag,
    required super.shortName,
    required super.displayName,
    required super.countryCode,
    required super.numberFormat,
    required super.currency,
    required super.isActive,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    final List<dynamic> country = List<String>.from((map['country_code']));
    return CountryModel(
      flag: map['flag']?.toString().trim() ?? '',
      shortName: map['short_name']?.toString().trim() ?? '',
      displayName: map['display_name']?.toString().trim() ?? '',
      countryCode: country.isEmpty ? '' : country.first.toString().trim(),
      numberFormat: map['number_format']?.toString().trim() ?? '',
      currency: List<String>.from(map['currency']),
      isActive: map['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flag': flag,
      'short_name': shortName,
      'display_name': displayName,
      'country_code': countryCode,
      'number_format': numberFormat,
      'currency': currency,
      'is_active': isActive,
    };
  }
}
