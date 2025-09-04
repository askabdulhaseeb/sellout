import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../business/business_page/domain/usecase/get_my_bookings_usecase.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../bookings/data/sources/local_booking.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../marketplace/domain/enum/radius_type.dart';
import '../../../marketplace/domain/params/filter_params.dart';
import '../../domain/params/service_sort_options.dart';
import '../../domain/params/services_by_filters_params.dart';
import '../../domain/usecase/get_services_by_query_usecase.dart';
import '../../domain/usecase/get_special_offer_usecase.dart';
import '../enums/service_appointment_section_type.dart';
import '../enums/services_page_type.dart';

class ServicesPageProvider extends ChangeNotifier {
  ServicesPageProvider(
    this._getSpecialOfferUsecase,
    this._getBookingsListUsecase,
    this._getBusinessByIdUsecase,
    this._getServiceByCategory,
  );
  final GetSpecialOfferUsecase _getSpecialOfferUsecase;
  final GetMyBookingsListUsecase _getBookingsListUsecase;
  final GetBusinessByIdUsecase _getBusinessByIdUsecase;
  final GetServicesByQueryUsecase _getServiceByCategory;
  //
  ServiceCategoryType? _selectedCategory;
  ServiceCategoryType? get selectedCategory => _selectedCategory;
  void setSelectedCategory(ServiceCategoryType category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Set loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //
  List<ServiceEntity> _categorizedServices = <ServiceEntity>[];
  List<ServiceEntity> get categorizedServices => _categorizedServices;
  void clearCategorizedServices() {
    _categorizedServices = <ServiceEntity>[];
  }

  //
  bool? _selectedIsMobileService;
  bool? get selectedIsMobileService => _selectedIsMobileService;
  void setSelectedIsMobileService(bool? value) {
    _selectedIsMobileService = value;
    notifyListeners();
  }

  //
  int? _rating;
  int? get rating => _rating;
  void setRating(int? value) {
    _rating = value;
    notifyListeners();
  }

  //
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  // Initial fetch
  Future<void> fetchServicesByCategory(ServiceCategoryType category) async {
    if (_isLoading) return;
    clearCategorizedServices();
    _setLoading(true);
    final ServiceByFiltersParams params = ServiceByFiltersParams(
        category: category.json, filters: <FilterParam>[]);
    final DataState<List<ServiceEntity>> result =
        await _getServiceByCategory.call(params);
    if (result is DataSuccess) {}
    _setLoading(false);
  }

  //
  final List<ServiceEntity> _serviceResults = <ServiceEntity>[];
  // String? _serviceNextKey;
  ServiceSortOption? _selectedSortOption = ServiceSortOption.bestMatch;
  ServiceSortOption? get selectedSortOption => _selectedSortOption;

  void setSortOption(ServiceSortOption option) {
    _selectedSortOption = option;
    searchServices();
    notifyListeners();
  }

  List<ServiceEntity> get serviceResults => _serviceResults;
  TextEditingController search = TextEditingController();
  Future<void> querySearching() async {
    // Only search if the query is not empty or just whitespace
    if (search.text.trim().isNotEmpty) {
      _isLoading = true;
      notifyListeners();
      await searchServices();
    } else {
      // If empty, clear the previous results
      searchedServices.clear();
      resetFilters();
      setSortOption(ServiceSortOption.bestMatch);
      notifyListeners();
    }
  }

  Future<void> searchServices() async {
    searchedServices.clear();
    final DataState<List<ServiceEntity>> result =
        await _getServiceByCategory.call(
      ServiceByFiltersParams(
        filters: getFilterParams(),
        query: search.text,
        sort: _selectedSortOption,
        clientLat: _selectedlatlng != const LatLng(0, 0)
            ? _selectedlatlng.latitude
            : null,
        clientLng: _selectedlatlng != const LatLng(0, 0)
            ? _selectedlatlng.longitude
            : null,
        distance:
            _radiusType == RadiusType.local ? _selectedRadius.toInt() : null,
      ),
    );
    if (result is DataSuccess) {
      searchedServices.clear();
      searchedServices.addAll(result.entity ?? <ServiceEntity>[]);
    }

    _isLoading = false;
    notifyListeners();
  }

  //
  Future<List<ServiceEntity>> getSpecialOffer() async {
    try {
      if (_specialOffer.isNotEmpty) return specialOffer;
      final DataState<List<ServiceEntity>> result =
          await _getSpecialOfferUsecase(true);
      if (result is DataSuccess) {
        _specialOffer = result.entity ?? <ServiceEntity>[];
        notifyListeners();
      } else {
        print('Error: ${result.exception?.message}');
      }
    } catch (e) {
      AppLog.error(
        '$e',
        name: 'ServicesPageProvider.getSpecialOffer - catch',
        error: e,
      );
    }
    return _specialOffer;
  }

  Future<List<BookingEntity>> getBookings() async {
    try {
      //
      final DataState<List<BookingEntity>> result =
          await _getBookingsListUsecase(
              GetBookingsParams(userID: LocalAuth.uid));
      if (result is DataSuccess) {
        _bookings = result.entity ?? <BookingEntity>[];
        notifyListeners();
        return result.entity ?? <BookingEntity>[];
      } else {
        AppLog.error(
          result.exception?.message ?? 'something went wrong',
          name: 'ServicesPageProvider.getBookings - else',
          error: result.exception,
        );
        return LocalBooking().userBooking(LocalAuth.uid ?? '');
      }
    } catch (e) {
      AppLog.error(
        '$e',
        name: 'ServicesPageProvider.getBookings - catch',
        error: e,
      );
    }
    return LocalBooking().userBooking(LocalAuth.uid ?? '');
  }

  Future<DataState<BusinessEntity?>> getbusinessbyid(String uid) async {
    return await _getBusinessByIdUsecase(uid);
  }

  //
  final List<ServiceEntity> searchedServices = <ServiceEntity>[];
  List<ServiceEntity> _specialOffer = <ServiceEntity>[];
  List<ServiceEntity> get specialOffer => _specialOffer;

  List<BookingEntity> _bookings = <BookingEntity>[];
  List<BookingEntity> get bookings => _bookings.where((BookingEntity element) {
        if (serviceAppointmentSectionType ==
            ServiceAppointmentSectionType.upcoming) {
          return element.status.json == 'pending';
        } else {
          return element.status.json == 'finished';
        }
      }).toList();

  LocationEntity? _location;
  LocationEntity? get location => _location;

  void setLocation(LocationEntity location) {
    _location = location;
    notifyListeners();
  }

  // Service page type
  ServicesPageType _servicesPageType = ServicesPageType.explore;
  ServicesPageType get servicesPageType => _servicesPageType;

  void setServicesPageType(ServicesPageType servicesPageType) {
    _servicesPageType = servicesPageType;
    notifyListeners();
  }

  ServiceAppointmentSectionType _serviceAppointmentSectionType =
      ServiceAppointmentSectionType.upcoming;
  ServiceAppointmentSectionType get serviceAppointmentSectionType =>
      _serviceAppointmentSectionType;

  void setServiceAppointmentSectionType(ServiceAppointmentSectionType value) {
    _serviceAppointmentSectionType = value;
    notifyListeners();
  }

  List<FilterParam> getFilterParams() {
    final List<FilterParam> params = <FilterParam>[];
    if (_selectedIsMobileService != null) {
      params.add(
        FilterParam(
          attribute: 'mobile_service',
          operator: 'eq',
          value: _selectedIsMobileService.toString(),
        ),
      );
    }
    if (_rating != null) {
      params.add(
        FilterParam(
          attribute: 'average_rating',
          operator: 'lt',
          value: _rating.toString(),
        ),
      );
    }
    if (minPriceController.text.trim().isNotEmpty) {
      params.add(FilterParam(
        attribute: 'price',
        operator: 'gt',
        value: minPriceController.text.trim(),
      ));
    }
    if (maxPriceController.text.trim().isNotEmpty) {
      params.add(FilterParam(
        attribute: 'price',
        operator: 'lt',
        value: maxPriceController.text.trim(),
      ));
    }
    return params;
  }

  void resetFilters() {
    _selectedIsMobileService = null;
    minPriceController.clear();
    maxPriceController.clear();
    _rating = null;
    searchServices();
  }

  void locationSheetApplyButton(BuildContext context) async {
    await searchServices();
  }

  void updateLocation(
    LatLng? latlngVal,
    LocationEntity? locationVal,
  ) {
    _selectedlatlng = latlngVal ?? LocalAuth.latlng;
    _selectedLocation = locationVal;
    debugPrint(
        'Updated LatLng: $_selectedlatlng, Location: $_selectedLocation in marketplaceProvider');
    notifyListeners();
  }

  void updateLocationSheet(LatLng? latlngVal, LocationEntity? locationVal,
      RadiusType radiusTypeVal, double selectedRadVal) {
    _radiusType = radiusTypeVal;
    _selectedRadius = selectedRadVal;
    _selectedlatlng = latlngVal ?? LocalAuth.latlng;
    _selectedLocation = locationVal;
    debugPrint(
        'Updated LatLng: $_selectedlatlng, Location: $_selectedLocation in marketplaceProvider');
    notifyListeners();
  }

  void resetLocationBottomsheet() async {
    updateLocationSheet(null, null, RadiusType.worldwide, 5);
    notifyListeners();
  }

  //
  LatLng _selectedlatlng = LocalAuth.latlng;
  LocationEntity? _selectedLocation;
  double _selectedRadius = 5;
  RadiusType _radiusType = RadiusType.worldwide;
  //
  LatLng get selectedlatlng => _selectedlatlng;
  LocationEntity? get selectedLocation => _selectedLocation;
  double get selectedRadius => _selectedRadius;
  RadiusType get radiusType => _radiusType;
}
