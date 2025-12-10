import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../../../../sources/local/local_hive_box.dart';
import '../../../../utilities/app_string.dart';
import '../../domain/entities/country_entity.dart';

class LocalCountry extends LocalHiveBox<CountryEntity> {
  @override
  String get boxName => AppStrings.localCountryBox;
  Box<CountryEntity> get localBox => box;

  CountryEntity? country(String code) {
    final String trimmed = code.trim();
    if (trimmed.isEmpty) return null;

    final String normalized = trimmed.toLowerCase();

    final CountryEntity? direct =
        localBox.get(trimmed) ??
        localBox.get(normalized) ??
        localBox.get(trimmed.toUpperCase());
    if (direct != null) return direct;

    for (final CountryEntity candidate in localBox.values) {
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
        'LocalCountry.getStateByName: no country found for "$countryName"',
      );
      return null;
    }

    final String normalizedState = trimmedState.toLowerCase();

    for (final StateEntity state in foundCountry.states) {
      final String name = state.stateName.trim().toLowerCase();
      final String code = state.stateCode.trim().toLowerCase();
      // Also try removing spaces for more robust matching
      final String nameNoSpace = name.replaceAll(' ', '');
      final String codeNoSpace = code.replaceAll(' ', '');
      final String normalizedNoSpace = normalizedState.replaceAll(' ', '');
      if (name == normalizedState ||
          code == normalizedState ||
          nameNoSpace == normalizedNoSpace ||
          codeNoSpace == normalizedNoSpace) {
        return state;
      }
    }

    debugPrint(
      'LocalCountry.getStateByName: no state match for "$stateName" (normalized: "$normalizedState") found in "$countryName"',
    );
    return null;
  }

  List<CountryEntity> get activeCountries =>
      localBox.values.where((CountryEntity entity) => entity.isActive).toList();
}
