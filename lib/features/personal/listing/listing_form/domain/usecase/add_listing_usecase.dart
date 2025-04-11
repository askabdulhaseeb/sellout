import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/add_listing_param.dart';
import '../repository/add_listing_repo.dart';

class AddListingUsecase implements UseCase<String, AddListingParam> {
  const AddListingUsecase(this.repository);
  final AddListingRepo repository;

  @override
  Future<DataState<String>> call(AddListingParam params) async =>
      await repository.addListing(params);
}
