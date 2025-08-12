import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../../marketplace/domain/params/post_by_filter_params.dart';
import '../../../../marketplace/domain/usecase/post_by_filters_usecase.dart';
import '../../../../order/domain/params/get_order_params.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/edit_profile_detail_usecase.dart';
import '../../domain/usecase/edit_profile_picture_usecase.dart';
import '../../../../order/domain/usecase/get_orders_buyer_id.dart';
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
    this._getPostByFiltersUsecase,
  );
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetSpecificPostUsecase _getPostByPostIdUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetOrderByUidUsecase _getOrderByIdUsecase;
  final UpdateProfilePictureUsecase _updateProfilePictureUsecase;
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  final GetPostByFiltersUsecase _getPostByFiltersUsecase;

  //---------------------------------------------------------------------------------variables

  bool _isLoading = false;
  int? _rating;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  ConditionType? _selectedConditionType;
  DeliveryType? _selectedDeliveryType;
  ProfilePageTabType _displayType =
      kDebugMode ? ProfilePageTabType.viewing : ProfilePageTabType.orders;
  List<AttachmentEntity>? profilePhoto;
  DataState<UserEntity?>? _user;
  String? _mainPageKey;
  ListingType? _category;
  //---------------------------------------------------------------------------------getters

  UserEntity? get user => _user?.entity;
  ProfilePageTabType get displayType => _displayType;
  bool get isLoading => _isLoading;
  int? get rating => _rating;
  TextEditingController get minPriceController => _minPriceController;
  TextEditingController get maxPriceController => _maxPriceController;
  ConditionType? get selectedConditionType => _selectedConditionType;
  DeliveryType? get selectedDeliveryType => _selectedDeliveryType;
  String? get mainPageKey => _mainPageKey;
  ListingType? get category => _category;

  //---------------------------------------------------------------------------------text controllers
  TextEditingController namecontroller =
      TextEditingController(text: LocalAuth.currentUser?.displayName);
  TextEditingController biocontroller = TextEditingController();
  TextEditingController queryController = TextEditingController();

  void setProfilePhoto() {
    profilePhoto = LocalAuth.currentUser?.profileImage;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setRating(int? newRating) {
    _rating = newRating;
    notifyListeners();
  }

  void setConditionType(ConditionType? type) {
    _selectedConditionType = type;
    notifyListeners();
  }

  void setDeliveryType(DeliveryType? type) {
    _selectedDeliveryType = type;
    notifyListeners();
  }

  void setCategory(ListingType? type) {
    _category = type;
    notifyListeners();
  }

  set displayType(ProfilePageTabType value) {
    _displayType = value;
    notifyListeners();
  }

  //---------------------------------------------------------------------------------buttons
  void filterSheetResetButton() {
    _rating = null;
    _minPriceController.clear();
    _maxPriceController.clear();
    _selectedConditionType = null;
    _selectedDeliveryType = null;
    notifyListeners();
  }

  Future<void> filterSheetApplyButton() async {
    setLoading(true);
    await Future<void>.delayed(
        const Duration(seconds: 1)); // Example async task
    setLoading(false);
  }
  //---------------------------------------------------------------------------------api usecases

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    AppLog.info(
      'Profile Provider: User loaded: ${_user?.entity?.displayName}',
      name: 'ProfileProvider.getUserByUid',
    );
    displayType = ProfilePageTabType.orders;
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
    return await _getOrderByIdUsecase(
        GetOrderParams(user: 'seller_id', uid: uid));
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

  Future<bool> loadPosts() async {
    setLoading(true);
    // setMainPageKey('');
    try {
      final PostByFiltersParams params = _buildPostByFiltersParams();
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        // setPosts(result.entity);
        // setMainPageKey(result.data);
        return true;
      } else {
        // setPosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      // setPosts(<PostEntity>[]);
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  PostByFiltersParams _buildPostByFiltersParams() {
    return PostByFiltersParams(
      lastKey: _mainPageKey,
      query: queryController.text,
      category: _category?.json ?? '',
      filters: _buildFilters(),
    );
  }

  List<FilterParam> _buildFilters() {
    final List<FilterParam> filters = <FilterParam>[];
    // filters.add(FilterParam(attribute: '', operator: 'eq', value: ''));
// filter bottom sheet filters
    if (_selectedConditionType != null) {
      filters.add(FilterParam(
        attribute: 'item_condition',
        operator: 'eq',
        value: _selectedConditionType?.json ?? '',
      ));
    }
    if (_selectedDeliveryType != null) {
      filters.add(FilterParam(
        attribute: 'delivery_type',
        operator: 'eq',
        value: _selectedDeliveryType?.json ?? '',
      ));
    }
    if (_rating != null) {
      filters.add(FilterParam(
        attribute: 'average_rating',
        operator: 'lt',
        value: _rating.toString(),
      ));
    }

    if (minPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'gt',
        value: minPriceController.text.trim(),
      ));
    }
    if (maxPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'lt',
        value: maxPriceController.text.trim(),
      ));
    }
    return filters;
  }
}
