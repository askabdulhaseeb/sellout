import '../../../../sources/data_state.dart';
import '../entities/country_entity.dart';

abstract interface class PhoneNumberRepository {
  Future<DataState<List<CountryEntity>>> countries(Duration duration);
}
