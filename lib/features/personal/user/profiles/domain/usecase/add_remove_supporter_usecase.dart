import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/add_remove_supporter_params.dart';
import '../repositories/user_repositories.dart';

class AddRemoveSupporterUsecase implements UseCase<String,AddRemoveSupporterParams> {
  const AddRemoveSupporterUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<String>> call(AddRemoveSupporterParams params) async {
    return await userProfileRepository.addRemoveSupporters(params);
  }
}