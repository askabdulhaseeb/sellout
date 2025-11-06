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
    // country_code may be a List or a single String
    final dynamic rawCountryCode = map['country_code'];
    List<String> country = <String>[];
    if (rawCountryCode is String) {
      country = <String>[rawCountryCode];
    } else if (rawCountryCode is Iterable) {
      country = rawCountryCode
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // currency may be a String like "GBP" or a List
    final dynamic rawCurrency = map['currency'];
    List<String> currencyList = <String>[];
    if (rawCurrency is String) {
      currencyList = <String>[rawCurrency];
    } else if (rawCurrency is Iterable) {
      currencyList = rawCurrency
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // number_format might be an object; normalize to a string representation
    final dynamic nf = map['number_format'];
    final String numberFormat = nf is String
        ? nf.trim()
        : nf != null
            ? nf.toString()
            : '';

    return CountryModel(
      flag: map['flag']?.toString().trim() ?? '',
      shortName: map['short_name']?.toString().trim() ?? '',
      displayName: map['display_name']?.toString().trim() ?? '',
      countryCode: country.isEmpty ? '' : country.first.toString().trim(),
      numberFormat: numberFormat,
      currency: currencyList,
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
