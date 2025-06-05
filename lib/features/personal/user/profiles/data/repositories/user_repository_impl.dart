import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repositories.dart';
import '../../views/params/add_remove_supporter_params.dart';
import '../../views/params/update_user_params.dart';
import '../models/order_model.dart';
import '../sources/remote/my_visting_remote.dart';
import '../sources/remote/order_by_user_remote.dart';
import '../sources/remote/post_by_user_remote.dart';
import '../sources/remote/user_profile_remote_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(
    this.userProfileRemoteSource,
    this.postByUserRemote,
    this.myVisitingRemote,
    this.orderByUserRemote,
  );
  final UserProfileRemoteSource userProfileRemoteSource;
  final PostByUserRemote postByUserRemote;
  final MyVisitingRemote myVisitingRemote;
  final OrderByUserRemote orderByUserRemote;

  @override
  Future<DataState<UserEntity?>> byUID(String uid) async {
    return await userProfileRemoteSource.byUID(uid);
  }

  @override
  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await postByUserRemote.getPostByUser(uid);
  }

  @override
  Future<DataState<List<VisitingEntity>>> iMvisiter() async {
    return await myVisitingRemote.iMvisiter();
  }

  @override
  Future<DataState<List<VisitingEntity>>> iMhost() async {
    return await myVisitingRemote.iMhost();
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? uid) async {
    return await orderByUserRemote.getOrderByUser(uid);
  }

  @override
  Future<DataState<bool>> createOrder(List<OrderModel> orderData) async {
    return await orderByUserRemote.createOrder(orderData);
  }

  @override
  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
      PickedAttachment photo) async {
    return await userProfileRemoteSource.updateProfilePicture(photo);
  }

  @override
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo) async {
    return await userProfileRemoteSource.updatePRofileDetail(photo);
  } @override
  Future<DataState<String>> addRemoveSupporters(AddRemoveSupporterParams params) async {
    return await userProfileRemoteSource.addRemoveSupporters(params);
  }
}
