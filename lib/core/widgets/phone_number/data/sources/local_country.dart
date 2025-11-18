import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../../utilities/app_string.dart';
import '../../domain/entities/country_entity.dart';

class LocalCountry {
  static final String boxTitle = AppStrings.localCountryBox;
  static Box<CountryEntity> get _box => Hive.box<CountryEntity>(boxTitle);
  static Future<Box<CountryEntity>> get openBox async =>
      Hive.openBox<CountryEntity>(boxTitle);

  Future<Box<CountryEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    return isOpen ? _box : Hive.openBox<CountryEntity>(boxTitle);
  }

  CountryEntity? country(String code) {
    final String trimmed = code.trim();
    if (trimmed.isEmpty) return null;

    final String normalized = trimmed.toLowerCase();

    final CountryEntity? direct = _box.get(trimmed) ??
        _box.get(normalized) ??
        _box.get(trimmed.toUpperCase());
    if (direct != null) return direct;

    for (final CountryEntity candidate in _box.values) {
      final Iterable<String> identifiers = <String>[
        candidate.countryCode,
        candidate.shortName,
        candidate.displayName,
        candidate.countryName,
        ...candidate.countryCodes,
      ];
      final bool matches = identifiers.any(
        (String value) => value.trim().toLowerCase() == normalized,
      );
      if (matches) return candidate;
    }

    debugPrint('LocalCountry.country: no match for "$code"');
    return null;
  }

  StateEntity? getStateByName(String countryName, String stateName) {
    final String trimmedCountry = countryName.trim();
    final String trimmedState = stateName.trim();

    if (trimmedCountry.isEmpty || trimmedState.isEmpty) return null;

    final CountryEntity? foundCountry = country(trimmedCountry);
    if (foundCountry == null) {
      debugPrint(
          'LocalCountry.getStateByName: no country found for "$countryName"');
      return null;
    }

    final String normalizedState = trimmedState.toLowerCase();

    for (final StateEntity state in foundCountry.states) {
      final String name = state.stateName.trim().toLowerCase();
      final String code = state.stateCode.trim().toLowerCase();
      if (name == normalizedState || code == normalizedState) {
        return state;
      }
    }

    debugPrint(
        'LocalCountry.getStateByName: no state "$stateName" found in "$countryName"');
    return null;
  }

  List<CountryEntity> get activeCountries =>
      _box.values.where((CountryEntity entity) => entity.isActive).toList();
}
