import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../data/models/order_model.dart';
import '../../views/params/update_user_params.dart';
import '../entities/orderentity.dart';
import '../entities/user_entity.dart';

abstract interface class UserProfileRepository {
  Future<DataState<UserEntity?>> byUID(String uid);
  Future<DataState<List<PostEntity>>> getPostByUser(String? uid);
  Future<DataState<List<VisitingEntity>>> iMvisiter();
  Future<DataState<List<VisitingEntity>>> iMhost();
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? uid);
  Future<DataState<bool>> createOrder(List<OrderModel> orderData);
  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
      PickedAttachment photo);
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo);
}
