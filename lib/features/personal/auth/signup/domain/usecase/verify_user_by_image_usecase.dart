import '../../../../../../core/usecase/usecase.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../repositories/signup_repository.dart';

class VerifyUserByImageUsecase implements UseCase<bool, PickedAttachment> {
  const VerifyUserByImageUsecase(this.repository);
  final SignupRepository repository;

  @override
  Future<DataState<bool>> call(PickedAttachment attachment) async {
    return await repository.verifyImage(attachment);
  }
}
