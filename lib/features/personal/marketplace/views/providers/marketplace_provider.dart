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
import '../../../post/domain/entities/post_entity.dart';
import '../../domain/enum/radius_type.dart';
import '../../domain/params/filter_params.dart';
import '../../domain/params/post_by_filter_params.dart';
import '../../domain/usecase/post_by_filters_usecase.dart';

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
    setLoading(true);
    try {
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

// button
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
    setSize(null);
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

  void setSize(String? size) {
    _selectedSize = size;
  }

  void setColor(String? color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
  }

  void setPosts(List<PostEntity>? value) {
    _posts = value;
    debugPrint('Loaded ${posts?.length} posts');
    notifyListeners();
  }

  void setChoiceChipPosts(List<PostEntity> value) {
    _choicePosts = value;
    debugPrint('Loaded ${posts?.length} posts');
    notifyListeners();
  }

  void setItemCategory(String? value) {
    _listingItemCategory = value;
  }

  void setAge(String? value) {
    _age = value;
  }

  void setReadyToLeave(String? value) {
    _readyToLeave = value;
  }

  void setMake(String? value) {
    _make = value;
  }

  void setYear(String? value) {
    _year = value;
  }

  void setPropertyType(String? value) {
    _propertyType = value;
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

  void setFilteringBool(bool value) {
    _isFilteringPosts = value;
  }

  void setAddedFilterKey(String? key) {
    _addedFilterKey = key;
    notifyListeners();
  }

  void setSelectedCategory(SubCategoryEntity? category) {
    _selectedCategory = category;
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
    notifyListeners();
  }

  void resetFilters() {
    // Marketplace Main Category
    _marketplaceCategory = null;

    // Cloth & Foot
    _cLothFootCategory = ListingType.clothAndFoot.cids.first;
    _selectedSize = null;
    _selectedColor = null;

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

    // Location
    _selectedLocation = const LatLng(0, 0);
    _selectedLocationName = '';
    _selectedRadius = 5;
    _radiusType = RadiusType.local;

    // Post data
    _posts = null;
    _selectedCategory = null;
    _addedFilterKey = null;

    // Delivery & Condition
    _selectedDeliveryType = null;
    _selectedConditionType = null;

    // UI
    _isLoading = false;
    _isFilteringPosts = false;

    // Text controllers
    postFilterController.clear();
    minPriceController.clear();
    maxPriceController.clear();

    notifyListeners();
  }

//variables
  ListingType? _marketplaceCategory;
  String _cLothFootCategory = ListingType.clothAndFoot.cids.first;
  String _propertyCategory = ListingType.property.cids.first;
  String _foodDrinkCategory = ListingType.foodAndDrink.cids.first;
  String? _selectedSize;
  String? _selectedColor;
  bool _isLoading = false;
  List<PostEntity>? _posts;
  List<PostEntity> _choicePosts = [];
  String? _listingItemCategory;
  String? _age;
  String? _readyToLeave;
  String? _make;
  String? _year;
  String? _propertyType;
  LatLng _selectedLocation = const LatLng(0, 0);
  String _selectedLocationName = '';
  double _selectedRadius = 5;
  RadiusType _radiusType = RadiusType.local;
  DeliveryType? _selectedDeliveryType;
  ConditionType? _selectedConditionType;
  bool _isFilteringPosts = false;
  SubCategoryEntity? _selectedCategory;
  String? _addedFilterKey;
  String? _petCategory;
  String? _energyRating;

// Getters
  ListingType? get marketplaceCategory => _marketplaceCategory;
  String? get cLothFootCategory => _cLothFootCategory;
  String? get propertyCategory => _propertyCategory;
  String? get foodDrinkCategory => _foodDrinkCategory;
  String? get selectedSize => _selectedSize;
  String? get selectedColor => _selectedColor;
  bool get isLoading => _isLoading;
  List<PostEntity>? get posts => _posts;
  List<PostEntity>? get choicePosts => _choicePosts;
  String? get listingItemCategory => _listingItemCategory;
  String? get age => _age;
  String? get readyToLeave => _readyToLeave;
  String? get make => _make;
  String? get year => _year;
  String? get propertyType => _propertyType;
  LatLng get selectedLocation => _selectedLocation;
  String get selectedLocationName => _selectedLocationName;
  double get selectedRadius => _selectedRadius;
  RadiusType get radiusType => _radiusType;
  DeliveryType? get selectedDeliveryType => _selectedDeliveryType;
  ConditionType? get selectedConditionType => _selectedConditionType;
  bool get isFilteringPosts => _isFilteringPosts;
  SubCategoryEntity? get selectedCategory => _selectedCategory;
  String? get addedFilterKey => _addedFilterKey;
  String? get petCategory => _petCategory;
  String? get energyRating => _energyRating;
// textfield controllers
  TextEditingController postFilterController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

//params
  PostByFiltersParams _buildPostByFiltersParams() {
    return PostByFiltersParams(
      address: _selectedCategory?.address,
      clientLat: _selectedLocation != const LatLng(0, 0)
          ? _selectedLocation.latitude
          : null,
      clientLng: _selectedLocation != const LatLng(0, 0)
          ? _selectedLocation.longitude
          : null,
      distance: _selectedRadius.toInt(),
      category: _marketplaceCategory?.json ?? '',
      filters: _buildFilters(),
    );
  }

  List<FilterParam> _buildFilters() {
    final List<FilterParam> filters = <FilterParam>[];
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

// Item section filters
    if (listingItemCategory != null && listingItemCategory!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'list_id',
        operator: 'eq',
        value: listingItemCategory ?? '',
      ));
    }
    if (addedFilterKey != null && addedFilterKey!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'created_at',
        operator: 'lt',
        value: addedFilterKey ?? '',
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
// clothes and footwear filters
    if (postFilterController.text.trim().isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'title',
        operator: 'eq',
        value: postFilterController.text.trim(),
      ));
    }
    if (selectedColor != null && selectedColor!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'colour',
        operator: 'eq',
        value: selectedColor!,
      ));
    }

    if (_marketplaceCategory == ListingType.clothAndFoot) {
      filters.add(FilterParam(
        attribute: 'type',
        operator: 'eq',
        value: _cLothFootCategory,
      ));
    }
// property section filters
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
// vehicle section filters
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
// food & drink section
    if (_marketplaceCategory == ListingType.foodAndDrink) {
      filters.add(FilterParam(
        attribute: 'type',
        operator: 'eq',
        value: _foodDrinkCategory,
      ));
    }
    return filters;
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
