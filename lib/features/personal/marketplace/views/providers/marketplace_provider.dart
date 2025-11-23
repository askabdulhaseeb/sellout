import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../listing/listing_form/data/models/sub_category_model.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../domain/enum/radius_type.dart';
import '../../domain/params/filter_params.dart';
import '../../domain/params/post_by_filter_params.dart';
import '../../domain/usecase/post_by_filters_usecase.dart';
import '../enums/added_filter_options.dart';
import '../enums/sort_enums.dart';

class MarketPlaceProvider extends ChangeNotifier {
  MarketPlaceProvider(this._getPostByFiltersUsecase);
  final GetPostByFiltersUsecase _getPostByFiltersUsecase;

//Api calls
  Future<bool> loadPosts() async {
    setLoading(true);
    setMainPageKey('');
    try {
      final PostByFiltersParams params = _buildPostMarketSearchParams();
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setPosts(result.entity);
        setMainPageKey(result.data);
        return true;
      } else {
        setPosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      setPosts(<PostEntity>[]);
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<bool> loadChipsPosts() async {
    setMainPageKey('');
    setChoiceChipPosts(<PostEntity>[]);
    try {
      setLoading(true);
      final PostByFiltersParams params = PostByFiltersParams(
        category: _chipsCategory ?? '',
        filters: <FilterParam>[],
      );
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setChoiceChipPosts(result.entity ?? <PostEntity>[]);
        setMainPageKey(result.data);
        return true;
      } else {
        setChoiceChipPosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<bool> loadFilteredContainerPosts() async {
    setMainPageKey('');
    try {
      setLoading(true);
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(_buildPostByFiltersParams());
      if (result is DataSuccess<List<PostEntity>>) {
        setFilterContainerPosts(result.entity ?? <PostEntity>[]);
        setMainPageKey(result.data);
        return true;
      } else {
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
        setFilterContainerPosts(<PostEntity>[]);
        setLoading(false);
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<void> loadMorePosts() async {
    if (isLoading || mainPageKey == null || mainPageKey!.isEmpty) return;
    try {
      setLoading(true);
      final PostByFiltersParams params = PostByFiltersParams(
        filters: <FilterParam>[],
        lastKey: mainPageKey,
      );

      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);

      if (result is DataSuccess<List<PostEntity>>) {
        final List<PostEntity> newPosts = result.entity ?? <PostEntity>[];

        if (newPosts.isEmpty) {
          _mainPageKey = null; // No more data
        } else {
          choicePosts?.addAll(newPosts);
          setChoiceChipPosts(List<PostEntity>.from(choicePosts ?? <dynamic>[]));
          setMainPageKey(result.data);
        }
      } else {
        debugPrint(
            'Failed to load more: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      debugPrint('Error loading more posts: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> loadPrivatePost(BuildContext context) async {
    try {
      final PostByFiltersParams params =
          PostByFiltersParams(filters: <FilterParam>[
        FilterParam(
            attribute: 'access_code',
            operator: 'eq',
            value: accessCodeController.text)
      ]);
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        Navigator.pushNamed(context, PostDetailScreen.routeName,
            arguments: <String, dynamic>{'pid': result.entity?.first.postID});
        return true;
      } else {
        AppSnackBar.showSnackBar(
            context, 'no_posts_found_with_this_access_code'.tr());
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      debugPrint('Unexpected error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

// button
  void sortCheckButton(SortOption? option) async {
    setSort(option);
    await loadPosts();
  }

  void filterSheetApplyButton() async {
    await loadPosts();
  }

  void updateLocation(
    LatLng? latlngVal,
    LocationEntity? locationVal,
  ) {
    _selectedlatlng = latlngVal ?? LocalAuth.latlng;
    _selectedLocation = locationVal;
    notifyListeners();
    debugPrint(
        'Updated LatLng: $_selectedlatlng, Location: $_selectedLocation in marketplaceProvider');
  }

  void updateLocationSheet(LatLng? latlngVal, LocationEntity? locationVal,
      RadiusType radiusTypeVal, double selectedRadVal) async {
    _radiusType = radiusTypeVal;
    _selectedRadius = selectedRadVal;
    _bottomsheetLatLng = latlngVal ?? LocalAuth.latlng;
    _bottomsheetLocation = locationVal;
    debugPrint(
        'Updated LatLng: $_bottomsheetLatLng, Location: $_bottomsheetLocation in marketplaceProvider for bottomsheet');
    await loadPosts();
  }

  void filterSheetResetButton() {
    _selectedConditionType = null;
    _rating = null;
    _selectedDeliveryType = null;
    minPriceController.clear();
    maxPriceController.clear();
  }

  void resetLocationBottomsheet() async {
    updateLocationSheet(null, null, RadiusType.worldwide, 5);
    notifyListeners();
  }

// set functions
  void setMarketplaceCategory(ListingType category) {
    _marketplaceCategory = category;
    notifyListeners();
  }

  void setClothFootCategory(String category) {
    _cLothFootCategory = category;
    _selectedSize = <String>[];
    _selectedColor = <String>[];
    _selectedSubCategory = null;
    _brand = null;
    notifyListeners();
  }

  void setProperyyCategory(String category) {
    _propertyCategory = category;
    notifyListeners();
  }

  void setSort(SortOption? val) {
    _selectedSortOption = val;
  }

  void setFoodDrinkCategory(String category) {
    _foodDrinkCategory = category;
    _selectedSubCategory = null;

    notifyListeners();
  }

  void setSize(List<String> size) {
    _selectedSize = size;
    notifyListeners();
  }

  void setColor(List<String> color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
  }

  void choiceChipsCategory(String? value) {
    _chipsCategory = value;
    loadChipsPosts();
  }

  void setPosts(
    List<PostEntity>? value,
  ) {
    _posts = value;
    debugPrint('Loaded normal filter and sorted posts: ${posts?.length}');
    if (queryController.text.isNotEmpty && queryController.text != '') {
      setFilteringBool(true);
    }
    if (queryController.text.isEmpty || queryController.text == '') {
      setFilteringBool(false);
    }
    notifyListeners();
  }

  void setChoiceChipPosts(List<PostEntity> value) {
    _choicePosts = value;
    debugPrint('Loaded chips posts ${posts?.length} ');
    notifyListeners();
  }

  void setFilterContainerPosts(List<PostEntity> value) {
    _filteredContainerPosts = value;
    debugPrint('Loaded filter container posts: ${posts?.length} ');
    notifyListeners();
  }

  void setItemCategory(String? value) {
    _listingItemCategory = value;
    notifyListeners();
  }

  void setAge(String? value) {
    _age = value;
    notifyListeners();
  }

  void setReadyToLeave(String? value) {
    _readyToLeave = value;
    notifyListeners();
  }

  void setMake(String? value) {
    _make = value;
    notifyListeners();
  }

  void setYear(String? value) {
    _year = value;
    notifyListeners();
  }

  void setVehicleCategory(String? value) {
    _vehicleCatgory = value;
    notifyListeners();
  }

  void setPropertyType(String? value) {
    _propertyType = value;
    notifyListeners();
  }

  void setRadiusType(RadiusType value) {
    _radiusType = value;
    notifyListeners();
  }

  void setRadius(double value) {
    _selectedRadius = value;
    notifyListeners();
  }

  void setDeliveryType(DeliveryType? value) {
    _selectedDeliveryType = value;
    notifyListeners();
  }

  void setConditionType(ConditionType? value) {
    _selectedConditionType = value;
    notifyListeners();
  }

  void setRating(int? value) {
    _rating = value;
    notifyListeners();
  }

  void setFilteringBool(bool value) {
    _isFilteringPosts = value;
    if (value == false) {
      filterSheetResetButton();
      setSort(SortOption.newlyList);
    }
    notifyListeners();
  }

  void setAddedFilterOption(AddedFilterOption? key) {
    _addedFilterOption = key;
    notifyListeners();
  }

  void setSelectedCategory(SubCategoryEntity? category) {
    _selectedSubCategory = category;
    notifyListeners();
  }

  void setPetCategory(String? value) {
    _petCategory = value;
    notifyListeners();
  }

  void setEnergyRating(String? value) {
    _energyRating = value;
    notifyListeners();
  }

  void setMainPageKey(String? val) {
    _mainPageKey = val;
  }

  void setBrand(String? val) {
    _brand = val;
    notifyListeners();
  }

// reset functions
  void clearMarketplaceCategory() {
    _marketplaceCategory = null;
    _filteredContainerPosts = <PostEntity>[];
    resetFilters();
  }

  void resetFilters() {
    // Cloth & Foot
    setClothFootCategory(ListingType.clothAndFoot.cids.first);

    // Items
    setItemCategory(null);
    setDeliveryType(null);
    // Pets
    setAge(null);
    setReadyToLeave(null);
    setPetCategory(null);

    // Property
    setProperyyCategory(ListingType.property.cids.first);
    setPropertyType(null);
    setEnergyRating(null);

    // Food & Drink
    setFoodDrinkCategory(ListingType.foodAndDrink.cids.first);

    // Vehicles
    setMake(null);
    setYear(null);
    setVehicleCategory(null);
    vehicleModel.clear();

    // Location
    updateLocation(null, null);

    // Posts
    setPosts(null);
    setSelectedCategory(null);
    setAddedFilterOption(null);

    // Delivery & Condition
    setDeliveryType(null);
    setConditionType(null);

    // UI
    setLoading(false);
    setFilteringBool(false);

    // Text controllers
    queryController.clear();
    minPriceController.clear();
    maxPriceController.clear();

    notifyListeners();
  }

//variables
  ListingType? _marketplaceCategory;
  String? _chipsCategory;
  List<PostEntity>? _posts;
  List<PostEntity> _choicePosts = <PostEntity>[];
  List<PostEntity> _filteredContainerPosts = <PostEntity>[];
  bool _isLoading = false;
  String _cLothFootCategory = ListingType.clothAndFoot.cids.first;
  String _propertyCategory = ListingType.property.cids.first;
  String _foodDrinkCategory = ListingType.foodAndDrink.cids.first;
  List<String> _selectedSize = <String>[];
  List<String> _selectedColor = <String>[];
  String? _listingItemCategory;
  String? _age;
  String? _readyToLeave;
  String? _make;
  String? _year;
  String? _vehicleCatgory;
  String? _propertyType;
  DeliveryType? _selectedDeliveryType;
  ConditionType? _selectedConditionType;
  int? _rating;
  bool _isFilteringPosts = false;
  SubCategoryEntity? _selectedSubCategory;
  AddedFilterOption? _addedFilterOption;
  String? _petCategory;
  String? _energyRating;
  SortOption? _selectedSortOption = SortOption.newlyList;
  String? _brand;
  String? _mainPageKey;
  LatLng _selectedlatlng = LocalAuth.latlng;
  LatLng _bottomsheetLatLng = LocalAuth.latlng;
  LocationEntity? _selectedLocation;
  LocationEntity? _bottomsheetLocation;
  double _selectedRadius = 5;
  RadiusType _radiusType = RadiusType.worldwide;
// Getters
  ListingType? get marketplaceCategory => _marketplaceCategory;
  String? get chipsCategory => _chipsCategory;
  bool get isFilteringPosts => _isFilteringPosts;
  List<PostEntity>? get posts => _posts;
  List<PostEntity>? get choicePosts => _choicePosts;
  List<PostEntity> get filteredContainerPosts => _filteredContainerPosts;
  bool get isLoading => _isLoading;

  String? get cLothFootCategory => _cLothFootCategory;
  String? get propertyCategory => _propertyCategory;
  String? get foodDrinkCategory => _foodDrinkCategory;
  List<String> get selectedSize => _selectedSize;
  List<String> get selectedColor => _selectedColor;

  String? get listingItemCategory => _listingItemCategory;
  String? get age => _age;
  String? get readyToLeave => _readyToLeave;
  String? get make => _make;
  String? get year => _year;
  String? get vehicleCatgory => _vehicleCatgory;

  DeliveryType? get selectedDeliveryType => _selectedDeliveryType;
  ConditionType? get selectedConditionType => _selectedConditionType;
  int? get rating => _rating;
  SubCategoryEntity? get selectedSubCategory => _selectedSubCategory;
  AddedFilterOption? get addedFilterOption => _addedFilterOption;
  String? get petCategory => _petCategory;
  String? get energyRating => _energyRating;
  SortOption? get selectedSortOption => _selectedSortOption;
  String? get brand => _brand;
  String? get mainPageKey => _mainPageKey;
  String? get propertyType => _propertyType;
  LatLng get selectedlatlng => _selectedlatlng;
  LatLng get bottomsheetLatLng => _bottomsheetLatLng;
  LocationEntity? get selectedLocation => _selectedLocation;
  LocationEntity? get bottomsheetLocation => _bottomsheetLocation;
  double get selectedRadius => _selectedRadius;
  RadiusType get radiusType => _radiusType;
// textfield controllers
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController accessCodeController =
      TextEditingController(text: kDebugMode ? '7DB79C' : null);
  TextEditingController usernameController = TextEditingController();

//params
  PostByFiltersParams _buildPostMarketSearchParams() {
    return PostByFiltersParams(
      lastKey: _mainPageKey,
      query: queryController.text,
      size: _selectedSize,
      colors: _selectedColor,
      sort: _selectedSortOption,
      address: _selectedSubCategory?.address,
      clientLat: _bottomsheetLatLng != const LatLng(0, 0)
          ? _bottomsheetLatLng.latitude
          : null,
      clientLng: _bottomsheetLatLng != const LatLng(0, 0)
          ? _bottomsheetLatLng.longitude
          : null,
      distance:
          _radiusType == RadiusType.local ? _selectedRadius.toInt() : null,
      category: _marketplaceCategory?.json ?? '',
      filters: _buildFilters(),
    );
  }

  PostByFiltersParams _buildPostByFiltersParams() {
    return PostByFiltersParams(
      lastKey: _mainPageKey,
      query: queryController.text,
      size: _selectedSize,
      colors: _selectedColor,
      sort: _selectedSortOption,
      address: _selectedSubCategory?.address,
      clientLat: _selectedlatlng != const LatLng(0, 0)
          ? _selectedlatlng.latitude
          : null,
      clientLng: _selectedlatlng != const LatLng(0, 0)
          ? _selectedlatlng.longitude
          : null,
      category: _marketplaceCategory?.json ?? '',
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

    /// pets section filters
    if (age != null && age!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'age',
        operator: 'eq',
        value: age ?? '',
      ));
    }
    if (readyToLeave != null && readyToLeave!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'ready_to_leave',
        operator: 'eq',
        value: readyToLeave ?? '',
      ));
    }
    if (_petCategory != null && _petCategory!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'pets_category',
        operator: 'eq',
        value: _petCategory ?? '',
      ));
    }

    /// Item section filters
    if (_listingItemCategory != null && _listingItemCategory!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'list_id',
        operator: 'eq',
        value: _listingItemCategory ?? '',
      ));
    }
    if (_addedFilterOption != null) {
      filters.add(FilterParam(
        attribute: 'created_at',
        operator: 'lt',
        value: _addedFilterOption?.formattedDate ?? '',
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

    /// property section filters
    if (_propertyType != null && _propertyType!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'property_type',
        operator: 'eq',
        value: _propertyType!,
      ));
    }
    if (_energyRating != null && _energyRating!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'energy_rating',
        operator: 'eq',
        value: _energyRating!,
      ));
    }
    if (_marketplaceCategory == ListingType.property) {
      filters.add(FilterParam(
        attribute: 'property_category',
        operator: 'eq',
        value: _propertyCategory,
      ));
    }

    /// vehicle section filters
    if (_make != null && _make!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'make',
        operator: 'eq',
        value: _make!,
      ));
    }
    if (_year != null && _year!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'year',
        operator: 'eq',
        value: _year!,
      ));
    }

    if (_vehicleCatgory != null && _vehicleCatgory!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'vehicles_category',
        operator: 'eq',
        value: _vehicleCatgory!,
      ));
    }

    if (vehicleModel.text.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'model',
        operator: 'eq',
        value: vehicleModel.text,
      ));
    }

    /// food & drink section
    if (_marketplaceCategory == ListingType.foodAndDrink) {
      filters.add(FilterParam(
        attribute: 'type',
        operator: 'eq',
        value: _foodDrinkCategory,
      ));
    }

    /// cloth foot section
    if (_brand != null && _brand != '') {
      filters.add(FilterParam(
        attribute: 'brand',
        operator: 'eq',
        value: _brand!,
      ));
    }
    if (_marketplaceCategory == ListingType.clothAndFoot) {
      filters.add(FilterParam(
        attribute: 'type',
        operator: 'eq',
        value: _cLothFootCategory,
      ));
    }

    ///

    return filters;
  }

  /// Listing api
  Future<void> fetchDropdownListings() async {
    try {
      setLoading(true);
      // String endpoint = '/category/${_marketplaceCategory?.json}?list-id=';
      // await DropDownListingAPI()
      //     .fetchAndStore(endpoint)
      //     .timeout(const Duration(seconds: 10));
      loadFilteredContainerPosts();
      setLoading(false);
    } catch (e) {
      debugPrint('Error fetching dropdown listings: $e');
      // Optionally handle error
    } finally {
      setLoading(false);
    }
  }
}
