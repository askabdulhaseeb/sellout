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

  CountryEntity country(String code) {
    final String id = code.trim().toLowerCase();
    if (id.isEmpty) throw Exception('Country code cannot be empty');

    final CountryEntity found = _box.get(id) ??
        _box.values.firstWhere(
          (CountryEntity c) => <String>[
            c.countryCode,
            c.shortName,
            c.displayName,
            c.countryName
          ].map((String e) => e.trim().toLowerCase()).contains(id),
          orElse: () => throw Exception('Country not found'),
        );
    return found;
  }

  StateEntity getStateByName(String name) {
    final String n = name.trim().toLowerCase();
    if (n.isEmpty) throw Exception('State name cannot be empty');

    return _box.values.expand((CountryEntity c) => c.states).firstWhere(
          (StateEntity s) => <String>[s.stateName, s.stateCode]
              .map((String e) => e.trim().toLowerCase())
              .contains(n),
          orElse: () => throw Exception('State not found'),
        );
  }

  List<CountryEntity> get activeCountries =>
      _box.values.where((CountryEntity e) => e.isActive).toList();

  DataState<CountryEntity> dataState(String id) {
    try {
      final CountryEntity value = country(id);
      return DataSuccess<CountryEntity>('', value);
    } on CustomException catch (error) {
      return DataFailer<CountryEntity>(error);
    } on Exception catch (error) {
      return DataFailer<CountryEntity>(
        CustomException(
          'loading...'.tr(),
          detail: error.toString(),
        ),
      );
    }
  }
}
