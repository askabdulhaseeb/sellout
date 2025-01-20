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
}
