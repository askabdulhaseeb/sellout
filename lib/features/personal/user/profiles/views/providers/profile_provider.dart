import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/edit_profile_detail_usecase.dart';
import '../../domain/usecase/edit_profile_picture_usecase.dart';
import '../../domain/usecase/get_orders_buyer_id.dart';
import '../../domain/usecase/get_post_by_id_usecase.dart';
import '../../domain/usecase/get_user_by_uid.dart';
import '../enums/profile_page_tab_type.dart';
import '../params/update_user_params.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(
    this._getUserByUidUsecase,
    this._getPostByIdUsecase,
    this._getReviewsUsecase,
    this._getOrderByIdUsecase,
    this._getPostByPostIdUsecase,
    this._updateProfilePictureUsecase,
    this._updateProfileDetailUsecase,
  );
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetSpecificPostUsecase _getPostByPostIdUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetOrderByUidUsecase _getOrderByIdUsecase;
  final UpdateProfilePictureUsecase _updateProfilePictureUsecase;
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  DataState<UserEntity?>? _user;
  UserEntity? get user => _user?.entity;

  TextEditingController namecontroller =
      TextEditingController(text: LocalAuth.currentUser?.displayName);
  TextEditingController biocontroller = TextEditingController();

  ProfilePageTabType _displayType =
      kDebugMode ? ProfilePageTabType.viewing : ProfilePageTabType.orders;
  ProfilePageTabType get displayType => _displayType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AttachmentEntity>? _profilePhoto;
  List<AttachmentEntity>? get profilePhoto => _profilePhoto;

  void setProfilePhoto() {
    _profilePhoto = LocalAuth.currentUser?.profileImage;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set displayType(ProfilePageTabType value) {
    _displayType = value;
    notifyListeners();
  }

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    AppLog.info(
      'Profile Provider: User loaded: ${_user?.entity?.displayName}',
      name: 'ProfileProvider.getUserByUid',
    );
    displayType = ProfilePageTabType.store;
    return _user;
  }

  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await _getPostByIdUsecase(uid);
  }

  Future<DataState<PostEntity>> getPostByPostId(
      GetSpecificPostParam uid) async {
    return await _getPostByPostIdUsecase(uid);
  }

  Future<DataState<List<OrderEntity>>> getOrderByUser(String uid) async {
    return await _getOrderByIdUsecase(uid);
  }

  Future<List<ReviewEntity>> getReviews(String? uid) async {
    final DataState<List<ReviewEntity>> reviews =
        await _getReviewsUsecase(GetReviewParam(
      id: uid ?? _user?.entity?.uid ?? '',
      type: ReviewApiQueryOptionType.sellerID,
    ));
    return reviews.entity ?? <ReviewEntity>[];
  }

  Future<void> updateProfilePicture(BuildContext context) async {
    final List<PickedAttachment>? pickedAttachment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PickableAttachmentScreen(
          option: PickableAttachmentOption(type: AttachmentType.image),
        ),
      ),
    );
    setLoading(true);
    if (pickedAttachment != null && pickedAttachment.isNotEmpty) {
      debugPrint(pickedAttachment.length.toString());
      debugPrint(pickedAttachment.first.selectedMedia!.relativePath);
      final DataState<List<AttachmentEntity>> result =
          await _updateProfilePictureUsecase.call(pickedAttachment.single);
      if (result is DataSuccess) {
        setProfilePhoto();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'profile_picture_updated_successfully'.tr(),
          )),
        );
        notifyListeners();
        setLoading(false);
      } else {
        AppLog.error(result.exception!.message,
            name: 'ProfileProvider.updateProfilePicture - else');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('something_wrong'.tr())),
        );

        setLoading(false);
      }
    }
  }

  Future<void> updateProfileDetail(BuildContext context) async {
    setLoading(true);
    final UpdateUserParams params = UpdateUserParams(
      uid: _user?.entity?.uid ?? '',
      name: namecontroller.text,
      bio: biocontroller.text,
    );

    final DataState<String> result = await _updateProfileDetailUsecase(params);
    if (result is DataSuccess) {
      AppLog.info('profile_updated_successfully'.tr());
      setLoading(false);
      Navigator.pop(context);
    } else {
      AppLog.error(result.exception!.message,
          name: 'ProfileProvider.updateProfileDetail - else');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
      setLoading(false);
    }
  }
}
