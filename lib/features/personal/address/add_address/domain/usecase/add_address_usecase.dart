import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/add_address_param.dart';
import '../repo_impl/add_address_repo.dart';

class AddAddressUsecase implements UseCase<bool, AddressParams> {
  const AddAddressUsecase(this.repository);
  final AddAddressRepository repository;

  @override
  Future<DataState<bool>> call(AddressParams params) async {
    try {
      return await repository.addAddress(params);
    } catch (e) {
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
