import '../../domain/entities/country_entity.dart';
import 'dart:convert';

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final String lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1';
  }
  return false;
}

class CountryModel extends CountryEntity {
  CountryModel({
    required super.flag,
    required super.shortName,
    required super.displayName,
    required super.countryName,
    required super.countryCode,
    required super.countryCodes,
    required super.language,
    required super.iosCode,
    required super.isoCode,
    required super.alpha2,
    required super.alpha3,
    required super.numberFormat,
    required super.currency,
    required super.isActive,
    required super.states,
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
          .where((String s) => s.isNotEmpty)
          .toList();
    }

    // number_format might be an object with {format, regex} or a string
    final dynamic nf = map['number_format'];
    String nfFormat = '';
    String nfRegex = '';
    if (nf is Map) {
      nfFormat = nf['format']?.toString().trim() ?? '';
      nfRegex = nf['regex']?.toString().trim() ?? '';
    } else if (nf is String) {
      // try to decode JSON-like string
      try {
        final String candidate = nf.replaceAll("'", '"');
        final dynamic dec = candidate.isNotEmpty ? jsonDecode(candidate) : null;
        if (dec is Map) {
          nfFormat = dec['format']?.toString().trim() ?? '';
          nfRegex = dec['regex']?.toString().trim() ?? '';
        } else {
          nfFormat = nf.trim();
        }
      } catch (_) {
        nfFormat = nf.trim();
      }
    }

    // parse states list if present
    final dynamic rawStates = map['states'];
    final List<StateEntity> statesList = <StateEntity>[];
    if (rawStates is Iterable) {
      for (final dynamic s in rawStates) {
        try {
          final String stateName = s['state_name']?.toString().trim() ?? '';
          final String stateCode = s['state_code']?.toString().trim() ?? '';
          final List<String> cities = <String>[];
          if (s['cities'] is Iterable) {
            for (final dynamic c in s['cities']) {
              final String city = c?.toString().trim() ?? '';
              if (city.isNotEmpty) cities.add(city);
            }
          }
          statesList.add(StateEntity(
              stateName: stateName, stateCode: stateCode, cities: cities));
        } catch (_) {
          statesList.add(
              StateEntity(stateName: '', stateCode: '', cities: <String>[]));
        }
      }
    }

    return CountryModel(
      flag: map['flag']?.toString().trim() ?? '',
      shortName: map['short_name']?.toString().trim() ?? '',
      displayName: map['display_name']?.toString().trim() ?? '',
      countryName: map['country_name']?.toString().trim() ?? '',
      countryCode: country.isEmpty ? '' : country.first.toString().trim(),
      countryCodes: country,
      language: map['language']?.toString().trim() ?? '',
      iosCode: map['ios_code']?.toString().trim() ?? '',
      isoCode: map['iso_code']?.toString().trim() ?? '',
      alpha2: map['alpha_2']?.toString().trim() ?? '',
      alpha3: map['alpha_3']?.toString().trim() ?? '',
      numberFormat: NumberFormatEntity(format: nfFormat, regex: nfRegex),
      currency: map['currency']?.toString().trim() ?? '',
      isActive: _parseBool(map['is_active']),
      states: statesList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flag': flag,
      'short_name': shortName,
      'display_name': displayName,
      'country_name': countryName,
      'country_code': countryCodes,
      'language': language,
      'ios_code': iosCode,
      'iso_code': isoCode,
      'alpha_2': alpha2,
      'alpha_3': alpha3,
      'number_format': <String, String>{
        'format': numberFormat.format,
        'regex': numberFormat.regex,
      },
      'states': states
          .map((StateEntity s) => <String, dynamic>{
                'state_name': s.stateName,
                'state_code': s.stateCode,
                'cities': s.cities,
              })
          .toList(),
      'currency': currency,
      'is_active': isActive,
    };
  }
}
