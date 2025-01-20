import '../../../../usecase/usecase.dart';
import '../entities/country_entity.dart';
import '../repository/phone_number_repository.dart';

class GetCountiesUsecase implements UseCase<List<CountryEntity>, Duration> {
  GetCountiesUsecase(this._repository);
  final PhoneNumberRepository _repository;

  @override
  Future<DataState<List<CountryEntity>>> call(Duration params) async {
    return await _repository.countries(params);
  }
}
