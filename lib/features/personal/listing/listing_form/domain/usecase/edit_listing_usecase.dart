import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/add_listing_param.dart';
import '../repository/add_listing_repo.dart';

class EditListingUsecase implements UseCase<String, AddListingParam> {
  const EditListingUsecase(this.repository);
  final AddListingRepo repository;

  @override
  Future<DataState<String>> call(AddListingParam params) async =>
      await repository.editListing(params);
}
