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
import '../../../../marketplace/views/enums/sort_enums.dart';
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
  DataState<UserEntity?>? _user;
  ProfilePageTabType _displayType =
      kDebugMode ? ProfilePageTabType.viewing : ProfilePageTabType.orders;
  List<AttachmentEntity>? profilePhoto;
  bool _isLoading = false;
// Store Variables
  SortOption? _storeSort;
  final TextEditingController _storeMinPriceController =
      TextEditingController();
  final TextEditingController _storeMaxPriceController =
      TextEditingController();
  ConditionType? _storeSelectedConditionType;
  DeliveryType? _storeSelectedDeliveryType;
  String? _storeMainPageKey;
  ListingType? _storeCategory;
  List<PostEntity>? _storePosts;

// Viewing Variables
  SortOption? _viewingSort;
  final TextEditingController _viewingMinPriceController =
      TextEditingController();
  final TextEditingController _viewingMaxPriceController =
      TextEditingController();
  ConditionType? _viewingSelectedConditionType;
  DeliveryType? _viewingSelectedDeliveryType;
  String? _viewingMainPageKey;
  ListingType? _viewingCategory;
  List<PostEntity>? _viewingPosts;

  //---------------------------------------------------------------------------------getters

  UserEntity? get user => _user?.entity;
  ProfilePageTabType get displayType => _displayType;
  bool get isLoading => _isLoading;
// Store Getters
  SortOption? get storeSort => _storeSort;
  TextEditingController get storeMinPriceController => _storeMinPriceController;
  TextEditingController get storeMaxPriceController => _storeMaxPriceController;
  ConditionType? get storeSelectedConditionType => _storeSelectedConditionType;
  DeliveryType? get storeSelectedDeliveryType => _storeSelectedDeliveryType;
  String? get storeMainPageKey => _storeMainPageKey;
  ListingType? get storeCategory => _storeCategory;
  List<PostEntity>? get storePosts => _storePosts;

// Viewing Getters
  SortOption? get viewingSort => _viewingSort;
  TextEditingController get viewingMinPriceController =>
      _viewingMinPriceController;
  TextEditingController get viewingMaxPriceController =>
      _viewingMaxPriceController;
  ConditionType? get viewingSelectedConditionType =>
      _viewingSelectedConditionType;
  DeliveryType? get viewingSelectedDeliveryType => _viewingSelectedDeliveryType;
  String? get viewingMainPageKey => _viewingMainPageKey;
  ListingType? get viewingCategory => _viewingCategory;
  List<PostEntity>? get viewingPosts => _viewingPosts;

  //---------------------------------------------------------------------------------text controllers
  TextEditingController namecontroller =
      TextEditingController(text: LocalAuth.currentUser?.displayName);
  TextEditingController biocontroller = TextEditingController();
  TextEditingController storeQueryController = TextEditingController();
  TextEditingController viewingQueryController = TextEditingController();

  void setProfilePhoto() {
    profilePhoto = LocalAuth.currentUser?.profileImage;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setStoreSort(SortOption? val) {
    _storeSort = val;
    notifyListeners();
  }

  void setViewingSort(SortOption? val) {
    _viewingSort = val;
    notifyListeners();
  }

  void setStoreConditionType(ConditionType? type) {
    _storeSelectedConditionType = type;
    notifyListeners();
  }

  void setViewingConditionType(ConditionType? type) {
    _viewingSelectedConditionType = type;
    notifyListeners();
  }

  void setStoreDeliveryType(DeliveryType? type) {
    _storeSelectedDeliveryType = type;
    notifyListeners();
  }

  void setViewingDeliveryType(DeliveryType? type) {
    _viewingSelectedDeliveryType = type;
    notifyListeners();
  }

  void setStoreCategory(ListingType? type) {
    _storeCategory = type;
    loadStorePosts();
  }

  void setViewingCategory(ListingType? type) {
    _viewingCategory = type;
    loadViewingPosts();
  }

  void setStorePosts(
    List<PostEntity> value,
  ) {
    _storePosts = value;
    if (storeQueryController.text.isNotEmpty &&
        storeQueryController.text != '') {}
    if (storeQueryController.text.isEmpty || storeQueryController.text == '') {}
    notifyListeners();
  }

  void setViewingPosts(
    List<PostEntity> value,
  ) {
    _storePosts = value;
    if (storeQueryController.text.isNotEmpty &&
        storeQueryController.text != '') {}
    if (storeQueryController.text.isEmpty || storeQueryController.text == '') {}
    notifyListeners();
  }

  void setStoreMainPageKey(String? val) {
    _storeMainPageKey = val;
  }

  void setViewingMainPageKey(String? val) {
    _viewingMainPageKey = val;
  }

  set displayType(ProfilePageTabType value) {
    _displayType = value;
    notifyListeners();
  }

  //---------------------------------------------------------------------------------buttons
  void storefilterSheetResetButton() async {
    _storeMinPriceController.clear();
    _storeMaxPriceController.clear();
    _storeSelectedConditionType = null;
    _storeSelectedDeliveryType = null;
    _storeSort = null;
    await loadStorePosts();
  }

  void viewingfilterSheetResetButton() async {
    _viewingMinPriceController.clear();
    _viewingMaxPriceController.clear();
    _viewingSelectedConditionType = null;
    _viewingSelectedDeliveryType = null;
    _viewingSort = null;
    await loadStorePosts();
  }

  void resetStoreCategoryButton() {
    _storeCategory = null;
    loadStorePosts();
  }

  void resetViewingCategoryButton() {
    _viewingCategory = null;
    loadStorePosts();
  }

  Future<void> storefilterSheetApplyButton() async {
    await loadStorePosts();
  }

  Future<void> viewingfilterSheetApplyButton() async {
    await loadStorePosts();
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
        GetOrderParams(user: GetOrderUserType.sellerId, value: uid));
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

  Future<bool> loadStorePosts() async {
    setLoading(true);
    setStoreMainPageKey('');
    try {
      final PostByFiltersParams params = _buildStorePostByFiltersParams();
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setStorePosts(result.entity ?? <PostEntity>[]);
        setStoreMainPageKey(result.data);
        return true;
      } else {
        setStorePosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      setStorePosts(<PostEntity>[]);
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<bool> loadViewingPosts() async {
    setLoading(true);
    setViewingMainPageKey('');
    try {
      final PostByFiltersParams params = _buildViewingPostByFiltersParams();
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setViewingPosts(result.entity ?? <PostEntity>[]);
        setViewingMainPageKey(result.data);
        return true;
      } else {
        setViewingPosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      setViewingPosts(<PostEntity>[]);
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  PostByFiltersParams _buildStorePostByFiltersParams() {
    return PostByFiltersParams(
      lastKey: _storeMainPageKey,
      query: storeQueryController.text,
      sort: _storeSort,
      filters: _buildStoreFilters(),
    );
  }

  List<FilterParam> _buildStoreFilters() {
    final List<FilterParam> filters = <FilterParam>[];
    // filters.add(FilterParam(attribute: '', operator: 'eq', value: ''));
// filter bottom sheet filters

    filters.add(FilterParam(
      attribute: 'created_by',
      operator: 'eq',
      value: LocalAuth.uid ?? '',
    ));

    filters.add(FilterParam(
      attribute: 'list_id',
      operator: _storeCategory != null ? 'eq' : 'inc',
      valueList: ListingType.storeList.map((ListingType e) => e.json).toList(),
      value: _storeCategory?.json ?? '',
    ));

    if (_storeSelectedConditionType != null) {
      filters.add(FilterParam(
        attribute: 'item_condition',
        operator: 'eq',
        value: _storeSelectedConditionType?.json ?? '',
      ));
    }
    if (_storeSelectedDeliveryType != null) {
      filters.add(FilterParam(
        attribute: 'delivery_type',
        operator: 'eq',
        value: _storeSelectedDeliveryType?.json ?? '',
      ));
    }

    if (_storeMinPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'gt',
        value: _storeMinPriceController.text.trim(),
      ));
    }
    if (_storeMaxPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'lt',
        value: _storeMaxPriceController.text.trim(),
      ));
    }
    return filters;
  }

  PostByFiltersParams _buildViewingPostByFiltersParams() {
    return PostByFiltersParams(
      lastKey: _storeMainPageKey,
      query: storeQueryController.text,
      sort: _viewingSort,
      filters: _buildViewingFilters(),
    );
  }

  List<FilterParam> _buildViewingFilters() {
    final List<FilterParam> filters = <FilterParam>[];
    // filters.add(FilterParam(attribute: '', operator: 'eq', value: ''));
// filter bottom sheet filters

    filters.add(FilterParam(
      attribute: 'created_by',
      operator: 'eq',
      value: LocalAuth.uid ?? '',
    ));

    filters.add(FilterParam(
      attribute: 'list_id',
      operator: _viewingCategory != null ? 'eq' : 'inc',
      valueList:
          ListingType.viewingList.map((ListingType e) => e.json).toList(),
      value: _viewingCategory?.json ?? '',
    ));

    if (_viewingSelectedConditionType != null) {
      filters.add(FilterParam(
        attribute: 'item_condition',
        operator: 'eq',
        value: _viewingSelectedConditionType?.json ?? '',
      ));
    }
    if (_viewingSelectedDeliveryType != null) {
      filters.add(FilterParam(
        attribute: 'delivery_type',
        operator: 'eq',
        value: _viewingSelectedDeliveryType?.json ?? '',
      ));
    }

    if (viewingMinPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'gt',
        value: viewingMinPriceController.text.trim(),
      ));
    }
    if (_viewingMaxPriceController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'price',
        operator: 'lt',
        value: _viewingMaxPriceController.text.trim(),
      ));
    }
    return filters;
  }
}
