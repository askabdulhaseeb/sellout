import '../../../../sources/data_state.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repository/phone_number_repository.dart';
import '../sources/country_api.dart';

class PhoneNumberRepositoryImpl implements PhoneNumberRepository {
  PhoneNumberRepositoryImpl(this._countryApi);
  final CountryApi _countryApi;

  @override
  Future<DataState<List<CountryEntity>>> countries(Duration duration) async {
    return await _countryApi.countries(duration);
  }
}
