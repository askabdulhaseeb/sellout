import 'package:hive_ce/hive.dart';
import '../../data/sources/local_country.dart';
import 'country_entity.dart';

class PhoneNumberEntity {
  PhoneNumberEntity({required this.countryCode, required this.number});

  final String countryCode;
  final String number;

  String get fullNumber => '$countryCode$number';

  static Future<PhoneNumberEntity> fromJson(String fullPhone) async {
    final Box<CountryEntity> box = LocalCountry().localBox;
    if (box.isEmpty) {
      // You may want to trigger a country fetch here if needed
      return PhoneNumberEntity(countryCode: '', number: fullPhone);
    }
    final List<CountryEntity> allCountries = box.values
        .where((CountryEntity country) => country.isActive)
        .toList();
    allCountries.sort(
      (CountryEntity a, CountryEntity b) =>
          b.countryCode.length.compareTo(a.countryCode.length),
    );
    for (final CountryEntity country in allCountries) {
      if (fullPhone.startsWith(country.countryCode)) {
        final String code = country.countryCode;
        final String rest = fullPhone.substring(code.length);
        return PhoneNumberEntity(countryCode: code, number: rest);
      }
    }
    return PhoneNumberEntity(countryCode: '', number: fullPhone);
  }
}

