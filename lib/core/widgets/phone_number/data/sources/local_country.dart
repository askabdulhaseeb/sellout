import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

import '../../../../sources/data_state.dart';
import '../../../../utilities/app_string.dart';
import '../../domain/entities/country_entity.dart';

class LocalCountry {
  static final String boxTitle = AppStrings.localCountryBox;
  static Box<CountryEntity> get _box => Hive.box<CountryEntity>(boxTitle);

  static Future<Box<CountryEntity>> get openBox async =>
      await Hive.openBox<CountryEntity>(boxTitle);

  Future<Box<CountryEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<CountryEntity>(boxTitle);
    }
  }

  Future<void> save(CountryEntity value) async =>
      await _box.put(value.countryCode, value);

  CountryEntity? country(String code) => _box.get(code);

  List<CountryEntity> get activeCounties =>
      _box.values.where((CountryEntity e) => e.isActive).toList();

  DataState<CountryEntity> dataState(String id) {
    final CountryEntity? po = country(id);
    if (po == null) {
      return DataFailer<CountryEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<CountryEntity>('', po);
    }
  }

  /// Find a [StateEntity] by name across all countries in the local box.
  ///
  /// Returns the first matching [StateEntity] where either `stateName`
  /// or `stateCode` matches [stateName] (case-insensitive). If no match
  /// is found, returns null.
  StateEntity? getStateByName(String stateName) {
    if (stateName.isEmpty) return null;
    final String needle = stateName.toLowerCase();
    for (final CountryEntity c in _box.values) {
      for (final StateEntity s in c.states) {
        if (s.stateName.toLowerCase() == needle ||
            s.stateCode.toLowerCase() == needle) {
          return s;
        }
      }
    }
    return null;
  }

  /// Find a [StateEntity] for a specific country identified by [countryCode].
  /// Matches country by its `countryCode`, `shortName`, or `displayName`.
  StateEntity? getStateInCountry(String countryCode, String stateName) {
    if (countryCode.isEmpty || stateName.isEmpty) return null;
    final String needleState = stateName.toLowerCase();
    CountryEntity? found;
    for (final CountryEntity c in _box.values) {
      if (c.countryCode == countryCode ||
          c.shortName == countryCode ||
          c.displayName == countryCode) {
        found = c;
        break;
      }
    }
    if (found == null) return null;
    for (final StateEntity s in found.states) {
      if (s.stateName.toLowerCase() == needleState ||
          s.stateCode.toLowerCase() == needleState) {
        return s;
      }
    }
    return null;
  }
}
