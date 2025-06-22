import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../domain/params/filter_params.dart';
import '../../domain/params/post_by_filter_params.dart';
import '../../domain/usecase/post_by_filters_usecase.dart';

class MarketPlaceProvider extends ChangeNotifier {
  MarketPlaceProvider(this._getPostByFiltersUsecase);
  final GetPostByFiltersUsecase _getPostByFiltersUsecase;

//Api calls
  Future<void> loadPosts() async {
    setLoading(true);

    try {
      final PostByFiltersParams params = _buildPostByFiltersParams();

      final DataState<List<PostEntity>> result =
          await _getPostByFiltersUsecase(params);

      if (result is DataSuccess<List<PostEntity>>) {
        setPosts(result.entity);
      } else if (result is DataFailer<List<PostEntity>>) {
        setPosts(<PostEntity>[]);
        debugPrint(
            'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}');
      }
    } catch (e) {
      setPosts(<PostEntity>[]);
      debugPrint('Unexpected error: $e');
    }

    setLoading(false);
  }

// set functions
  void setMarketplaceCategory(ListingType category) {
    _marketplaceCategory = category;
    notifyListeners();
  }

  void setClothFootCategory(String? category) {
    _cLothFootCategory = category;
    setSize(null);
    notifyListeners();
  }

  void setProperyyCategory(String? category) {
    _propertyCategory = category;
    notifyListeners();
  }

  void setFoodDrinkCategory(String? category) {
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

// reset functions
  void clearMarketplaceCategory() {
    _marketplaceCategory = null;
    notifyListeners();
  }

  void resetFilters() {
    // Cloth & Foot
    _cLothFootCategory = ListingType.clothAndFoot.cids.first;
    _selectedSize = null;
    _selectedColor = null;
    // Items
    _listingItemCategory = null;
    // Pets
    _age = null;
    _readyToLeave = null;
    // Property
    _propertyCategory = ListingType.property.cids.first;
    _propertyType = null;
    // Food & Drink
    _foodDrinkCategory = ListingType.foodAndDrink.cids.first;
    // Vehicles
    _make = null;
    _year = null;
    // General
    minPriceController.clear();
    maxPriceController.clear();
    postFilterController.clear();
    _posts = null;
    _isLoading = false;
    notifyListeners();
  }

//variables
  ListingType? _marketplaceCategory;
  String? _cLothFootCategory = ListingType.clothAndFoot.cids.first;
  String? _propertyCategory = ListingType.property.cids.first;
  String? _foodDrinkCategory = ListingType.foodAndDrink.cids.first;

  String? _selectedSize;
  String? _selectedColor;
  bool _isLoading = false;
  List<PostEntity>? _posts;
  String? _listingItemCategory;
  String? _age;
  String? _readyToLeave;
  String? _make;
  String? _year;
  String? _propertyType;

// Getters
  ListingType? get marketplaceCategory => _marketplaceCategory;
  String? get cLothFootCategory => _cLothFootCategory;
  String? get propertyCategory => _propertyCategory;
  String? get foodDrinkCategory => _foodDrinkCategory;
  String? get selectedSize => _selectedSize;
  String? get selectedColor => _selectedColor;
  bool get isLoading => _isLoading;
  List<PostEntity>? get posts => _posts;
  String? get listingItemCategory => _listingItemCategory;
  String? get age => _age;
  String? get readyToLeave => _readyToLeave;
  String? get make => _make;
  String? get year => _year;
  String? get propertyType => _propertyType;

// textfield controllers
  TextEditingController postFilterController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

//params

  PostByFiltersParams _buildPostByFiltersParams() {
    return PostByFiltersParams(
      category: _marketplaceCategory?.json ?? '',
      filters: _buildFilters(),
    );
  }

  List<FilterParam> _buildFilters() {
    final List<FilterParam> filters = <FilterParam>[];
// pets section filters
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
// Item section filters
    if (listingItemCategory != null && listingItemCategory!.isNotEmpty) {
      filters.add(FilterParam(
        attribute: 'list_id',
        operator: 'eq',
        value: listingItemCategory ?? '',
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
        value: _cLothFootCategory!,
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
    if (_marketplaceCategory == ListingType.property) {
      filters.add(FilterParam(
        attribute: 'type',
        operator: 'eq',
        value: _cLothFootCategory!,
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
        value: _cLothFootCategory!,
      ));
    }
    return filters;
  }
}
/////////////////////////////////////////////////////////////////////////////
//   String _selectedPersonalCategory = 'all';
//   String _selectedBusinessCategory = 'all';
//   String? _selectedfootbrand;
//   String? _selectedfootSize;
//   String? _selectedFootColor;
//   String? _selectedclothbrand;
//   String? _selectedclothSize;
//   String? _selectedclothColor;
//   String? _selectedmodelvehicle;
//   String? _selectedmakevehcle;
//   String? _selectedagepet;
//   String? _selectedreadytoleavepet;
//   String? _selectedcategorypet;

//   int? _selectedyearvehicle;
//   List<ColorEntity> _availablefootColors = <ColorEntity>[];
//   List<ColorEntity> _availableclothColors = <ColorEntity>[];
//   String? _selectedVehicleCategory;
// //
//   ConditionType? _selectedCondition;
//   DeliveryType? _selectedDeliveryType;
//   int? _selectedRating;
//   bool _showAll = false;
//   final List<PostEntity> _posts = <PostEntity>[];
//   SortOption _selectedSortOption = SortOption.dateAscending;
//   TextEditingController searchController = TextEditingController();
//   TextEditingController postodeController = TextEditingController();
//   CategoryTypes? selectedCategory;
//   DeliveryType? selectedDelivery;
//   String? _selectedsalePropertytype;
//   String? _selectedrentPropertytype;

//   String? selectedDateFilter;
//   double? minPrice;
//   double? maxPrice;
//   List<PostEntity> popularCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> footCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> clothCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> saleCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> rentCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> petsCategoryFIlteredList = <PostEntity>[];
//   List<PostEntity> vehicleCategoryFilteredList = <PostEntity>[];
//   List<PostEntity> petCategoryFilteredList = <PostEntity>[];

//   List<String> dateFilterOptions = <String>['7', '30', '128', '365'];
//   List<double> priceOptions = <double>[
//     10,
//     100,
//     1000,
//     10000,
//     100000,
//     1000000,
//     10000000
//   ];
//   double _selectedRadius = 10.0; // Default local radius
//   int _selectedfootclothTab = 0;
//   int _selectedpropertyTab = 0;
//   String _radiusType = 'local'; // Default radius type (local or worldwide)
//   LatLng _selectedLocation =
//       const LatLng(37.7749, -122.4194); // Default Location

//   GoogleMapController? _mapController;

// // Getters
//   String get selectedPersonalCategory => _selectedPersonalCategory;
//   String get selectedBusinessCategory => _selectedBusinessCategory;
//   String? get selectedfootBrand => _selectedfootbrand;
//   String? get selectedfootSize => _selectedfootSize;
//   String? get selectedFootColor => _selectedFootColor;
//   String? get selectedclothBrand => _selectedclothbrand;
//   String? get selectedclothSize => _selectedclothSize;
//   String? get selectedclothColor => _selectedclothColor;
//   int? get selectedyearvehicle => _selectedyearvehicle;
//   String? get selectedmakevehcle => _selectedmakevehcle;
//   String? get selectedmodelvehicle => _selectedmodelvehicle;
//   String? get selectedagepet => _selectedagepet;
//   String? get selectedreadytoleavepet => _selectedreadytoleavepet;
//   String? get selectedcategorypet => _selectedcategorypet;
//   double get selectedRadius => _selectedRadius;

//   List<ColorEntity> get availablefootColors => _availablefootColors;
//   List<ColorEntity> get availableclothColors => _availableclothColors;
//   String? get selectedsalePropertytype => _selectedsalePropertytype;
//   String? get selectedrentPropertytype => _selectedrentPropertytype;
//   int get selectedfootclothTab => _selectedfootclothTab;
//   int get selectedpropertyTab => _selectedpropertyTab;
//   ConditionType? get selectedCondition => _selectedCondition;
//   DeliveryType? get selectedDeliveryType => _selectedDeliveryType;
//   String? get selectedVehicleCategory => _selectedVehicleCategory;
//   int? get selectedRating => _selectedRating;
//   bool get showAll => _showAll;
//   List<PostEntity> get posts => _posts;
//   SortOption get selectedSortOption => _selectedSortOption;
//   String get radiusType => _radiusType;
//   LatLng get selectedLocation => _selectedLocation;
//   GoogleMapController? get mapController => _mapController;
// //
//   set selectRadius(double value) {
//     if (value != _selectedRadius) {
//       _selectedRadius = value;
//       notifyListeners();
//     }
//   }

//   set radiusType(String value) {
//     if (value != _radiusType) {
//       _radiusType = value;

//       if (_radiusType == 'worldwide') {
//         _selectedRadius = 10000;
//       } else {
//         _selectedRadius = 10.0;
//       }

//       // Notify listeners after updating the radiusType
//       notifyListeners();
//     }
//   }

//   set selectedLocation(LatLng location) {
//     if (location != _selectedLocation) {
//       _selectedLocation = location;
//       notifyListeners(); // Notify listeners after updating the location
//     }
//   }

//   set mapController(GoogleMapController? controller) {
//     if (controller != _mapController) {
//       _mapController = controller;
//       notifyListeners(); // Notify listeners after updating the map controller
//     }
//   }

//   // Methods to update state
//   void onMapCreated(GoogleMapController controller) {
//     mapController = controller; // Calls the setter with a non-null controller
//   }

//   void onLocationChanged(LatLng location) {
//     selectedLocation = location;
//   }

//   // Future<DataState<List<PostEntity>>> getFeed() async {
//   //   final DataState<List<PostEntity>> result = await _getFeedUsecase(null);
//   //   _posts.addAll(result.entity ?? <PostEntity>[]);
//   //   notifyListeners();
//   //   return result;
//   // }

//   void updatefootclothSelectedTab(int index) {
//     _selectedfootclothTab = index;
//     notifyListeners();
//   }

//   void updatepropertySelectedTab(int index) {
//     _selectedpropertyTab = index;
//     notifyListeners();
//   }

//   double calculateAverageRating(List<double> reviews) {
//     if (reviews.isEmpty) return 0.0;
//     double sum = reviews.reduce((double a, double b) => a + b).toDouble();
//     return sum / reviews.length;
//   }

//   void updateCondition(ConditionType? newCondition) {
//     _selectedCondition = newCondition;
//   }

//   //
//   void setRating(int rating) {
//     _selectedRating = rating;
//   }

//   void setConditionType(ConditionType condition) {
//     _selectedCondition = condition;
//   }

//   void updateDeliveryType(DeliveryType newDeliveryType) {
//     _selectedDeliveryType = newDeliveryType;
//   }

//   void toggleShowAll() {
//     _showAll = !_showAll;
//     notifyListeners();
//   }

//   void updateSelectedPersonalCategory(String category) {
//     _selectedPersonalCategory = category;
//     notifyListeners();
//   }

//   void updateSelectedBusinessCategory(String category) {
//     _selectedBusinessCategory = category;
//     notifyListeners();
//   }

// //get categories------------------------------------------------------------------------------//
//   List<PostEntity> getPersonalPosts() {
//     return SortOption.sortPosts(
//       _posts.where((PostEntity post) {
//         bool categoryMatch = _selectedBusinessCategory == 'all' ||
//             post.listID.toUpperCase() ==
//                 _selectedPersonalCategory.toUpperCase();
//         double avgRating = calculateAverageRating(post.listOfReviews!);
//         post.listID.toUpperCase() == _selectedPersonalCategory.toUpperCase();
//         bool ratingMatch =
//             _selectedRating == null || avgRating.round() == _selectedRating;

//         return categoryMatch &&
//             _matchesPrice(post, minPrice, maxPrice) &&
//             ratingMatch &&
//             _matchescondition(post, selectedCondition) &&
//             _matchesDelivery(
//                 post, selectedDelivery) && // Include delivery match
//             post.businessID == null;
//       }).toList(),
//       _selectedSortOption,
//     );
//   }

//   List<PostEntity> getBusinessPosts() {
//     return SortOption.sortPosts(
//       _posts.where((PostEntity post) {
//         double avgRating = calculateAverageRating(post.listOfReviews!);
//         bool categoryMatch = _selectedBusinessCategory == 'all' ||
//             post.listID.toUpperCase() ==
//                 _selectedBusinessCategory.toUpperCase();
//         bool ratingMatch =
//             _selectedRating == null || avgRating.round() == _selectedRating;
//         _selectedCondition == null || post.condition == _selectedCondition;
//         post.deliveryType == _selectedDeliveryType; // Filter by delivery type

//         return categoryMatch &&
//             _matchesPrice(post, minPrice, maxPrice) &&
//             ratingMatch &&
//             _matchescondition(post, selectedCondition) &&
//             _matchesDelivery(
//                 post, selectedDelivery) && // Include delivery match
//             post.businessID != null;
//       }).toList(),
//       _selectedSortOption,
//     );
//   }

//   List<String> getPersonalCategories() {
//     final Set<String> uniqueCategories = <String>{'all'};
//     for (PostEntity post in _posts) {
//       if (post.businessID == null) {
//         uniqueCategories.add(post.listID);
//       }
//     }
//     return uniqueCategories.toList();
//   }

//   List<String> getBusinessCategories() {
//     final Set<String> uniqueCategories = <String>{'all'};
//     for (PostEntity post in _posts) {
//       if (post.businessID != null) {
//         uniqueCategories.add(post.listID);
//       }
//     }
//     return uniqueCategories.toList();
//   }

//   List<SizeColorEntity> getFootSize() {
//     final Map<String, SizeColorEntity> uniqueSizes =
//         <String, SizeColorEntity>{};

//     for (PostEntity post in _posts) {
//       if (post.categoryType == 'footwear') {
//         for (SizeColorEntity sizeColor in post.sizeColors) {
//           uniqueSizes[sizeColor.value] = sizeColor;
//         }
//       }
//     }

//     debugPrint('Unique Sizes: ${uniqueSizes.keys.join(", ")}');
//     return uniqueSizes.values.toList();
//   }

//   List<SizeColorEntity> getclothSize() {
//     final Map<String, SizeColorEntity> uniqueSizes =
//         <String, SizeColorEntity>{};

//     for (PostEntity post in _posts) {
//       if (post.categoryType == 'clothes') {
//         for (SizeColorEntity sizeColor in post.sizeColors) {
//           uniqueSizes[sizeColor.value] = sizeColor;
//         }
//       }
//     }

//     debugPrint('Unique Sizes: ${uniqueSizes.keys.join(", ")}');
//     return uniqueSizes.values.toList();
//   }

//   List<String> getfootBrands() {
//     final Set<String> brands = <String>{};
//     for (PostEntity post in _posts) {
//       if (post.brand != null &&
//           post.brand!.isNotEmpty &&
//           post.categoryType == 'footwear') {
//         debugPrint('Brand found: ${post.brand}');
//         brands.add(post.brand!);
//       }
//     }
//     return brands.toList();
//   }

//   List<String> getclothBrands() {
//     final Set<String> brands = <String>{};
//     for (PostEntity post in _posts) {
//       if (post.brand != null &&
//           post.brand!.isNotEmpty &&
//           post.categoryType == 'clothes') {
//         debugPrint('Brand found: ${post.brand}');
//         brands.add(post.brand!);
//       }
//     }

//     return brands.toList();
//   }

//   List<String> getsalepropertyTypes() {
//     final Set<String> propertytype = <String>{};
//     for (PostEntity post in _posts) {
//       debugPrint('sale property type: ${post.propertytype}${_posts.length}');
//       if (post.propertytype != null &&
//           post.propertytype!.isNotEmpty &&
//           post.propertyCategory == 'sale') {
//         debugPrint('sale property type found: ${post.propertytype}');
//         propertytype.add(post.propertytype!);
//       }
//     }

//     return propertytype.toList();
//   }

//   List<String> getrentpropertyTypes() {
//     final Set<String> propertytype = <String>{};
//     for (PostEntity post in _posts) {
//       debugPrint('rent property type: ${post.propertytype}${_posts.length}');
//       if (post.propertytype != null &&
//           post.propertytype!.isNotEmpty &&
//           post.propertyCategory == 'rent') {
//         debugPrint('rent property type found: ${post.propertytype}');
//         propertytype.add(post.propertytype!);
//       }
//     }

//     return propertytype.toList();
//   }

//   List<String> getVehicleCategory() {
//     final Set<String> vehiclecategory = <String>{};
//     for (PostEntity post in _posts) {
//       if (post.vehiclesCategory != null && post.vehiclesCategory!.isNotEmpty) {
//         vehiclecategory.add(post.vehiclesCategory!);
//       }
//     }
//     return vehiclecategory.toList();
//   }

//   List<int?> getVehicleyear() {
//     final Set<int?> vehicleyear = <int?>{};
//     for (PostEntity post in _posts) {
//       if (post.year != null && post.listID == 'vehicles') {
//         vehicleyear.add(post.year);
//       }
//     }
//     return vehicleyear.toList();
//   }

//   List<String?> getVehiclemake() {
//     final Set<String?> vehiclemake = <String?>{};
//     for (PostEntity post in _posts) {
//       if (post.make != null && post.listID == 'vehicles') {
//         vehiclemake.add(post.make);
//       }
//     }
//     return vehiclemake.toList();
//   }

//   List<String?> getVehiclemodel() {
//     final Set<String?> vehiclemodel = <String?>{};
//     for (PostEntity post in _posts) {
//       if (post.model != null && post.listID == 'vehicles') {
//         vehiclemodel.add(post.model);
//       }
//     }
//     return vehiclemodel.toList();
//   }

//   List<String?> getpetsage() {
//     final Set<String?> petage = <String?>{};
//     for (PostEntity post in _posts) {
//       if (post.age != null && post.listID == 'pets') {
//         petage.add(post.age);
//       }
//     }
//     return petage.toList();
//   }

//   List<String?> getpetreadytoleave() {
//     final Set<String?> petreadyToLeave = <String?>{};
//     for (PostEntity post in _posts) {
//       if (post.readyToLeave != null && post.listID == 'pets') {
//         petreadyToLeave.add(post.readyToLeave);
//       }
//     }
//     return petreadyToLeave.toList();
//   }

//   List<String?> getpetscategory() {
//     final Set<String?> getpetscategory = <String?>{};
//     for (PostEntity post in _posts) {
//       if (post.petsCategory != null && post.listID == 'pets') {
//         getpetscategory.add(post.petsCategory);
//       }
//     }
//     return getpetscategory.toList();
//   }

//   void setSortOption(SortOption option) {
//     _selectedSortOption = option;
//     notifyListeners();
//   }

//   void setCategory(CategoryTypes? category) {
//     selectedCategory = category;
//   }

//   void setDeliveryType(DeliveryType? delivery) {
//     selectedDelivery = delivery;
//   }

//   void setDateFilter(String? dateFilter) {
//     selectedDateFilter = dateFilter;
//   }

//   void setMinPrice(double? price) {
//     minPrice = price;
//   }

//   void setMaxPrice(double? price) {
//     maxPrice = price;
//   }

//   void setfootBrand(String? brand) {
//     _selectedfootbrand = brand;
//   }

//   void setclothBrand(String? brand) {
//     _selectedclothbrand = brand;
//   }

//   void setfootsize(String? footsize) {
//     _selectedfootSize = footsize;
//   }

//   void setFootColor(String? color) {
//     _selectedFootColor = color;
//     notifyListeners();
//   }

//   void setclothsize(String? clothsize) {
//     _selectedclothSize = clothsize;
//   }

//   void setclothColor(String? color) {
//     _selectedclothColor = color;
//     notifyListeners();
//   }

//   void setsalepropertytype(String? saleproperty) {
//     _selectedsalePropertytype = saleproperty;
//     notifyListeners();
//   }

//   void setrentpropertytype(String? rentproperty) {
//     _selectedrentPropertytype = rentproperty;
//     notifyListeners();
//   }

//   void setAvailableFootColors(String? selectedSize) {
//     if (selectedSize == null) return;

//     final SizeColorEntity selectedSizeEntity = getFootSize().firstWhere(
//       (SizeColorEntity sizeEntity) => sizeEntity.value == selectedSize,
//       orElse: () =>
//           const SizeColorEntity(value: '', colors: <ColorEntity>[], id: ''),
//     );

//     // Update the available colors based on the selected size
//     _availablefootColors = selectedSizeEntity.colors;
//     notifyListeners();
//   }

//   void setAvailableclothColors(String? selectedSize) {
//     if (selectedSize == null) return;

//     final SizeColorEntity selectedSizeEntity = getFootSize().firstWhere(
//       (SizeColorEntity sizeEntity) => sizeEntity.value == selectedSize,
//       orElse: () =>
//           const SizeColorEntity(value: '', colors: <ColorEntity>[], id: ''),
//     );
//     // Update the available colors based on the selected size
//     _availableclothColors = selectedSizeEntity.colors;
//     notifyListeners();
//   }

//   void setvehiclecategory(String? category) {
//     _selectedVehicleCategory = category;
//   }

//   void setvehicleyear(int? year) {
//     _selectedyearvehicle = year;
//   }

//   void setvehiclemake(String? make) {
//     _selectedmakevehcle = make;
//   }

//   void setvehiclemodel(String? model) {
//     _selectedmodelvehicle = model;
//   }

//   void setpetage(String? model) {
//     _selectedagepet = model;
//   }

//   void setpetreadytoleave(String? model) {
//     _selectedreadytoleavepet = model;
//   }

//   void setpetcategory(String? model) {
//     _selectedcategorypet = model;
//   }

// // match filters----------------------------------------------------------------//
//   bool _matchesCategory(PostEntity post, CategoryTypes? selectedCategory) {
//     return selectedCategory == null || post.listID == selectedCategory.key;
//   }

//   bool _matchesDelivery(PostEntity post, DeliveryType? selectedDelivery) {
//     return selectedDelivery == null || post.deliveryType == selectedDelivery;
//   }

//   bool _matchesSearch(PostEntity post, String? searchText) {
//     if (searchText == null || searchText.isEmpty) {
//       return true; // No search text means show all posts
//     }
//     return post.title.toLowerCase().contains(searchText.toLowerCase());
//   }

//   // bool _matchespostcode(PostEntity post, String? postcode) {
//   //   if (postcode == null || postcode.isEmpty) {
//   //     return true; // No search text means show all posts
//   //   }
//   //   return post.title.toLowerCase().contains(postcode.toLowerCase());
//   // }

//   bool _matchesPrice(PostEntity post, double? minPrice, double? maxPrice) {
//     return (minPrice == null || post.price >= minPrice) &&
//         (maxPrice == null || post.price <= maxPrice);
//   }

//   bool _matchescondition(PostEntity post, ConditionType? selectedCondition) {
//     return selectedCondition == null || post.condition == selectedCondition;
//   }

//   bool _matchesDate(PostEntity post, String? selectedDateFilter) {
//     return selectedDateFilter == null || _checkDateFilter(post.createdAt);
//   }

//   bool _matchesfootBrand(PostEntity post, String? selectedfootBrand) {
//     return selectedfootBrand == null || post.brand == selectedfootBrand;
//   }

//   bool _matchesfootSize(PostEntity post, String? selectedfootsize) {
//     return selectedfootsize == null ||
//         post.sizeColors
//             .any((SizeColorEntity size) => size.value == selectedfootSize);
//   }

//   bool _matchesfootColor(PostEntity post, String? selectedFootColor) {
//     return selectedFootColor == null ||
//         post.sizeColors.any((SizeColorEntity size) => size.colors
//             .any((ColorEntity color) => color.code == selectedFootColor));
//   }

//   bool _matchesclothBrand(PostEntity post, String? selectedfootBrand) {
//     return selectedfootBrand == null || post.brand == selectedfootBrand;
//   }

//   bool _matchesclothSize(PostEntity post, String? selectedfootsize) {
//     return selectedfootsize == null ||
//         post.sizeColors
//             .any((SizeColorEntity size) => size.value == selectedfootSize);
//   }

//   bool _matchesclothColor(PostEntity post, String? selectedFootColor) {
//     return selectedFootColor == null ||
//         post.sizeColors.any((SizeColorEntity size) => size.colors
//             .any((ColorEntity color) => color.code == selectedFootColor));
//   }

//   bool _matchesaletype(PostEntity post, String? selectedsalePropertytype) {
//     return selectedsalePropertytype == null ||
//         post.propertytype == selectedsalePropertytype;
//   }

//   bool _matchesrenttype(PostEntity post, String? selectedrentPropertytype) {
//     return selectedsalePropertytype == null ||
//         post.propertytype == selectedrentPropertytype;
//   }

//   bool _matchesvehiclecategory(
//       PostEntity post, String? selectedVehicleCategory) {
//     return selectedVehicleCategory == null ||
//         post.vehiclesCategory == selectedVehicleCategory;
//   }

//   bool _matchesvehiclemake(PostEntity post, String? selectedmakevehcle) {
//     return selectedmakevehcle == null || post.make == selectedmakevehcle;
//   }

//   bool _matchesvehiclemodal(PostEntity post, String? selectedmodelvehicle) {
//     return selectedmodelvehicle == null || post.model == selectedmodelvehicle;
//   }

//   bool _matchesvehicleyear(PostEntity post, int? selectedyearvehicle) {
//     return selectedyearvehicle == null || post.year == selectedyearvehicle;
//   }

//   bool _matchespetage(PostEntity post, String? selectedagepet) {
//     debugPrint(post.age);
//     return selectedagepet == null || post.age == selectedagepet;
//   }

//   bool _matchespetreadytoleave(
//       PostEntity post, String? selectedreadytoleavepet) {
//     debugPrint(post.readyToLeave);
//     return selectedreadytoleavepet == null ||
//         post.readyToLeave == selectedreadytoleavepet;
//   }

//   bool _matchesCategorypet(PostEntity post, String? selectedcategorypet) {
//     return selectedcategorypet == null ||
//         post.petsCategory == selectedcategorypet;
//   }

// //filter the list---------------------------------------------------------------------------------------//
//   void filterPopularResults() {
//     popularCategoryFilteredList = posts.where((PostEntity post) {
//       return _matchesCategory(post, selectedCategory) &&
//           _matchesDelivery(post, selectedDelivery) &&
//           _matchesSearch(post, searchController.text) &&
//           _matchesPrice(post, minPrice, maxPrice) &&
//           _matchesDate(post, selectedDateFilter);
//     }).toList();
//     debugPrint('Filtered Posts Count: ${popularCategoryFilteredList.length}');
//     notifyListeners();
//   }

//   void filterFootResults() {
//     footCategoryFilteredList = posts.where((PostEntity post) {
//       return _matchesSearch(post, searchController.text) &&
//           _matchesfootBrand(post, selectedfootBrand) &&
//           _matchesfootColor(post, selectedFootColor) &&
//           _matchesfootSize(post, selectedfootSize) &&
//           _matchescondition(post, selectedCondition) &&
//           post.categoryType == 'footwear';
//     }).toList();
//     notifyListeners();
//   }

//   void filterCLothResults() {
//     clothCategoryFilteredList = posts.where((PostEntity post) {
//       return _matchesSearch(post, searchController.text) &&
//           _matchesclothBrand(post, selectedfootBrand) &&
//           _matchesclothColor(post, selectedFootColor) &&
//           _matchesclothSize(post, selectedfootSize) &&
//           _matchescondition(post, selectedCondition) &&
//           post.categoryType == 'clothes';
//     }).toList();
//     notifyListeners();
//   }

//   void filterSaleResults() {
//     saleCategoryFilteredList = posts.where((PostEntity post) {
//       return _matchesaletype(post, selectedsalePropertytype) &&
//           _matchesDate(post, selectedDateFilter) &&
//           _matchesPrice(post, minPrice, maxPrice) &&
//           post.propertyCategory == 'sale';
//     }).toList();
//   }

//   void filterRentResults() {
//     rentCategoryFilteredList = posts.where((PostEntity post) {
//       return _matchesrenttype(post, selectedrentPropertytype) &&
//           _matchesDate(post, selectedDateFilter) &&
//           _matchesPrice(post, minPrice, maxPrice) &&
//           post.propertyCategory == 'rent';
//     }).toList();
//   }

//   void filtervehicleResults() {
//     vehicleCategoryFilteredList = posts.where((PostEntity post) {
//       debugPrint(post.categoryType);

//       return _matchesvehiclemake(post, selectedmakevehcle) &&
//           _matchesvehiclecategory(post, selectedVehicleCategory) &&
//           _matchesvehiclemodal(post, selectedmodelvehicle) &&
//           _matchesvehicleyear(post, selectedyearvehicle) &&
//           _matchesPrice(post, minPrice, maxPrice) &&
//           post.listID == 'vehicles';
//     }).toList();
//     debugPrint('Filtered Posts Count: ${popularCategoryFilteredList.length}');
//     notifyListeners();
//   }

//   void filterpetResults() {
//     petCategoryFilteredList = posts.where((PostEntity post) {
//       return post.listID == 'pets' && // Ensure only pet posts are included
//           _matchespetage(post, selectedagepet) &&
//           _matchespetreadytoleave(post, selectedreadytoleavepet) &&
//           _matchesCategorypet(post, selectedcategorypet) &&
//           _matchesSearch(post, searchController.text) &&
//           _matchesPrice(post, minPrice, maxPrice);
//     }).toList();
//     debugPrint('Filtered Posts Count: ${petsCategoryFIlteredList.length}');
//     notifyListeners();
//   }

// //apply filter------------------------------------------------------------------------------------------//
//   void applyFootFilters() {
//     filterFootResults();
//   }

//   void applyClothFilters() {
//     filterCLothResults();
//   }

//   void applyPopularFilters() {
//     debugPrint('Applying filters...');
//     filterPopularResults();
//   }

//   void applysalePropertyFIlter() {
//     debugPrint('Applying filters...');
//     filterSaleResults();
//   }

//   void applyrentPropertyFIlter() {
//     debugPrint('Applying filters...');
//     filterRentResults();
//   }

//   void applyvehicleFIlter() {
//     debugPrint('Applying filters...');
//     filtervehicleResults();
//   }

//   void applypersonalbusinessFilter() {
//     getBusinessPosts();
//     getPersonalCategories();
//     notifyListeners();
//   }

//   void applypetFilter() {
//     debugPrint('Applying filters...');
//     filterpetResults();
//   }

// //
//   bool _checkDateFilter(DateTime createdAt) {
//     final DateTime now = DateTime.now();
//     final DateTime filteredDate;
//     switch (selectedDateFilter) {
//       case '7':
//         filteredDate = now.subtract(const Duration(days: 7));
//         break;
//       case '30':
//         filteredDate = now.subtract(const Duration(days: 30));
//         break;
//       case '128':
//         filteredDate = now.subtract(const Duration(days: 128));
//       case '365':
//         filteredDate = now.subtract(const Duration(days: 365));
//         break;
//       default:
//         return true;
//     }
//     return createdAt.isAfter(filteredDate);
//   }

// //
//   void resetFilters() {
//     searchController.clear();
//     minPrice = null;
//     maxPrice = null;
//     selectedCategory = null;
//     selectedDelivery = null;
//     selectedDateFilter = null;
//     _selectedfootbrand = null;
//     _selectedclothbrand = null;
//     _selectedfootSize = null;
//     _selectedclothSize = null;
//     _selectedFootColor = null;
//     _selectedclothColor = null;
//     _selectedsalePropertytype = null;
//     _selectedVehicleCategory = null;
//     _selectedmakevehcle = null;
//     _selectedyearvehicle = null;
//     _selectedmodelvehicle = null;
//     _selectedagepet = null;
//     _selectedcategorypet = null;
//     _selectedreadytoleavepet = null;
//     _availablefootColors.clear();
//     _availableclothColors.clear();
//     _selectedCondition = null;
//     filterPopularResults();
//     filterFootResults();
//     filterCLothResults();
//     filterSaleResults();
//     filterRentResults();
//     filtervehicleResults();
//     filterpetResults();
//     getBusinessCategories();
//     getPersonalCategories();
//   }
//}
