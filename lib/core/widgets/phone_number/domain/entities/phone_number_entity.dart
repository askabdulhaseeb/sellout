import 'package:hive_ce/hive.dart';
import '../../../../../services/get_it.dart';
import '../../../../sources/data_state.dart';
import '../../data/sources/local_country.dart';
import '../usecase/get_counties_usecase.dart';
import 'country_entity.dart';

class PhoneNumberEntity {
  PhoneNumberEntity({required this.countryCode, required this.number});

  final String countryCode;
  final String number;

  String get fullNumber => '$countryCode$number';

  static Future<PhoneNumberEntity> fromJson(String fullPhone) async {
    // Open the Hive box to access stored country data
    final Box<CountryEntity> box = await LocalCountry.openBox;

    // If the box is empty, we need to fetch countries
    if (box.isEmpty) {
      await _fetchAndStoreCountries(); // Fetch and store the countries if box is empty
    }

    // Get all active countries from Hive
    final List<CountryEntity> allCountries = box.values
        .where((CountryEntity country) => country.isActive)
        .toList();

    // Sort country codes descending by length to match longest one first
    allCountries.sort(
      (CountryEntity a, CountryEntity b) =>
          b.countryCode.length.compareTo(a.countryCode.length),
    );

    // Try to match the phone number with a country code
    for (final CountryEntity country in allCountries) {
      if (fullPhone.startsWith(country.countryCode)) {
        final String code = country.countryCode;
        final String rest = fullPhone.substring(code.length);
        return PhoneNumberEntity(countryCode: code, number: rest);
      }
    }

    // Fallback if no country code matched
    throw Exception('No matching country code found for: $fullPhone');
  }

  // Fetch and store countries in Hive
  static Future<void> _fetchAndStoreCountries() async {
    GetCountiesUsecase getCountiesUsecase = GetCountiesUsecase(
      locator(),
    ); // Make sure to initialize it properly
    final DataState<List<CountryEntity>> result = await getCountiesUsecase.call(
      const Duration(days: 1),
    );

    if (result is DataSuccess) {
      final List<CountryEntity> countries = result.entity ?? <CountryEntity>[];
      final Box<CountryEntity> box = await LocalCountry.openBox;

      // Clear the existing data and store the new countries in Hive
      await box.clear();
      await box.addAll(countries);
    } else if (result is DataFailer) {
      throw Exception('Failed to fetch country data: ${result.exception}');
    }
  }
}
