import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../listing/listing_form/data/models/sub_category_model.dart';
import '../../../listing/listing_form/data/sources/remote/dropdown_listing_api.dart';
import '../../../post/domain/entities/post_entity.dart';
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
    try {
      final PostByFiltersParams params = _buildPostByFiltersParams();
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setPosts(result.entity);
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

  Future<bool> loadChipsPosts(String category) async {
    try {
      setLoading(true);
      setChoiceChipPosts(<PostEntity>[]);
      final PostByFiltersParams params = PostByFiltersParams(
        category: category,
        filters: <FilterParam>[],
      );
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);
      if (result is DataSuccess<List<PostEntity>>) {
        setChoiceChipPosts(result.entity ?? <PostEntity>[]);

        return true;
      } else {
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
    try {
      setLoading(true);
      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(_buildPostByFiltersParams());
      if (result is DataSuccess<List<PostEntity>>) {
        setFilterContainerPosts(result.entity ?? <PostEntity>[]);
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

// button
  void filterSortedPosts(SortOption? option) async {
    final bool success = await loadPosts();
    if (success) {
      _selectedSortOption = option;
      setFilteringBool(true);
    }
  }

  void filterSheetApplyButton() async {
    final bool success = await loadPosts();
    if (success) {
      setFilteringBool(true);
    }
  }

  void filterSheetResetButton() async {
    final bool success = await loadPosts();
    if (success) {
      _selectedConditionType = null;
      _selectedDeliveryType = null;
      minPriceController.clear();
      maxPriceController.clear();
      setFilteringBool(false);
    }
  }

  void resetLocationBottomsheet() async {
    final bool success = await loadPosts();
    if (success) {
      _radiusType = RadiusType.worldwide;
      _selectedRadius = 10;
      _selectedLocation = const LatLng(0, 0);
    }
  }

  void locationSheetApplyButton() async {
    final bool success = await loadPosts();
    if (success) {
      setFilteringBool(true);
    }
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
    notifyListeners();
  }

  void setProperyyCategory(String category) {
    _propertyCategory = category;
    notifyListeners();
  }

  void setFoodDrinkCategory(String category) {
    _foodDrinkCategory = category;
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

  void setPosts(
    List<PostEntity>? value,
  ) {
    _posts = value;
    debugPrint('Loaded normal filter and soretd posts: ${posts?.length}');
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

  void setSelectedDeliveryType(DeliveryType? value) {
    _selectedDeliveryType = value;
    notifyListeners();
  }

  void setSelectedConditionType(ConditionType? value) {
    _selectedConditionType = value;
    notifyListeners();
  }

  void setRating(int? value) {
    _rating = value;
    notifyListeners();
  }

  void setFilteringBool(bool value) {
    _isFilteringPosts = value;
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

// reset functions
  void clearMarketplaceCategory() {
    _marketplaceCategory = null;
    _filteredContainerPosts = <PostEntity>[];
    resetFilters();
  }

  void resetFilters() {
    // // Marketplace Main Category
    // _marketplaceCategory = null;
    _selectedSubCategory = null;
    // Cloth & Foot
    _cLothFootCategory = ListingType.clothAndFoot.cids.first;
    _selectedSize = <String>[];
    _selectedColor = <String>[];
    // Items
    _listingItemCategory = null;
    // Pets
    _age = null;
    _readyToLeave = null;
    _petCategory = null;
    // Property
    _propertyCategory = ListingType.property.cids.first;
    _propertyType = null;
    _energyRating = null;
    // Food & Drink
    _foodDrinkCategory = ListingType.foodAndDrink.cids.first;
    // Vehicles
    _make = null;
    _year = null;
    _vehicleCatgory = null;
    vehicleModel.clear();
    // Location
    _selectedLocation = const LatLng(0, 0);
    _selectedLocationName = '';
    _selectedRadius = 5;
    _radiusType = RadiusType.worldwide;
    // Post data
    _posts = null;
    _selectedSubCategory = null;
    _addedFilterOption = null;
    // Delivery & Condition
    _selectedDeliveryType = null;
    _selectedConditionType = null;
    // UI
    _isLoading = false;
    _isFilteringPosts = false;
    // Text controllers
    queryController.clear();
    minPriceController.clear();
    maxPriceController.clear();

    notifyListeners();
  }

//variables
  ListingType? _marketplaceCategory;
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
  LatLng _selectedLocation = const LatLng(0, 0);
  String _selectedLocationName = '';
  double _selectedRadius = 5;
  RadiusType _radiusType = RadiusType.worldwide;
  DeliveryType? _selectedDeliveryType;
  ConditionType? _selectedConditionType;
  int? _rating;
  bool _isFilteringPosts = false;
  SubCategoryEntity? _selectedSubCategory;
  AddedFilterOption? _addedFilterOption;
  String? _petCategory;
  String? _energyRating;
  SortOption? _selectedSortOption = SortOption.dateAscending;

// Getters
  ListingType? get marketplaceCategory => _marketplaceCategory;
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

  String? get propertyType => _propertyType;
  LatLng get selectedLocation => _selectedLocation;
  String get selectedLocationName => _selectedLocationName;
  double get selectedRadius => _selectedRadius;
  RadiusType get radiusType => _radiusType;
  DeliveryType? get selectedDeliveryType => _selectedDeliveryType;
  ConditionType? get selectedConditionType => _selectedConditionType;
  int? get rating => _rating;
  SubCategoryEntity? get selectedSubCategory => _selectedSubCategory;
  AddedFilterOption? get addedFilterOption => _addedFilterOption;
  String? get petCategory => _petCategory;
  String? get energyRating => _energyRating;
  SortOption? get selectedSortOption => _selectedSortOption;

// textfield controllers
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();

//params
  PostByFiltersParams _buildPostByFiltersParams() {
    return PostByFiltersParams(
      query: queryController.text,
      size: _selectedSize,
      colors: _selectedColor,
      sort: _selectedSortOption,
      address: _selectedSubCategory?.address,
      clientLat: _selectedLocation != const LatLng(0, 0)
          ? _selectedLocation.latitude
          : null,
      clientLng: _selectedLocation != const LatLng(0, 0)
          ? _selectedLocation.longitude
          : null,
      distance:
          _radiusType == RadiusType.local ? _selectedRadius.toInt() : null,
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
    return filters;
  }

  /// Listing api
  Future<void> fetchDropdownListings() async {
    try {
      setLoading(true);
      String endpoint = '/category/${_marketplaceCategory?.json}?list-id=';
      await DropDownListingAPI()
          .fetchAndStore(endpoint)
          .timeout(const Duration(seconds: 10));
      loadFilteredContainerPosts();
      setLoading(false);
    } catch (e) {
      debugPrint('Error fetching dropdown listings: $e');
      // Optionally handle error
    } finally {
      setLoading(false);
    }
  }

  /// location api
  Future<LatLng> getLocationCoordinates(String address) async {
    final bool hasConnection = await _checkInternetConnection();
    if (!hasConnection) throw 'NO_INTERNET';
    final List<Location> locations = await locationFromAddress(address)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw 'TIMEOUT';
    });

    if (locations.isEmpty) throw 'NO_RESULTS';
    return LatLng(locations.first.latitude, locations.first.longitude);
  }
  // Default radius type: worldwide or local

  void updateLocation(LatLng location, String name) {
    _selectedLocation = location;
    _selectedLocationName = name;
    notifyListeners();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } on SocketException {
      return false;
    }
  }
}
