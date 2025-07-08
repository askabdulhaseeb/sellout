import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../business/business_page/domain/entities/services_list_responce_entity.dart';
import '../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../business/business_page/domain/usecase/get_my_bookings_usecase.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../bookings/data/sources/local_booking.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../marketplace/views/enums/sort_enums.dart';
import '../../../search/domain/entities/search_entity.dart';
import '../../../search/domain/params/search_enum.dart';
import '../../../search/domain/usecase/search_usecase.dart';
import '../../domain/params/get_categorized_services_params.dart';
import '../../domain/usecase/get_service_by_categories_usecase.dart';
import '../../domain/usecase/get_special_offer_usecase.dart';
import '../enums/service_appointment_section_type.dart';
import '../enums/services_page_type.dart';

class ServicesPageProvider extends ChangeNotifier {
  ServicesPageProvider(
      this._getSpecialOfferUsecase,
      this._getBookingsListUsecase,
      this._getBusinessByIdUsecase,
      this._getServiceByCategory,
      this._searchUsecase);
  final SearchUsecase _searchUsecase;
  final GetSpecialOfferUsecase _getSpecialOfferUsecase;
  final GetMyBookingsListUsecase _getBookingsListUsecase;
  final GetBusinessByIdUsecase _getBusinessByIdUsecase;
  final GetServiceCategoryUsecase _getServiceByCategory;
  //
  final Map<String, bool> _expandedDescriptions = <String, bool>{};
  bool isDescriptionExpanded(String serviceId) {
    return _expandedDescriptions[serviceId] ?? false;
  }

  void toggleDescription(String serviceId) {
    _expandedDescriptions[serviceId] = !isDescriptionExpanded(serviceId);
    notifyListeners();
  }

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
  bool get hasMore => _hasMore;
  bool _hasMore = true;
  String? _nextKey;
  // Initial fetch
  Future<void> fetchServicesByCategory(ServiceCategoryType category) async {
    if (_isLoading) return;
    clearCategorizedServices();
    _setLoading(true);
    final GetServiceCategoryParams params =
        GetServiceCategoryParams(type: category);
    final DataState<ServicesListResponceEntity> result =
        await _getServiceByCategory.call(params);
    if (result is DataSuccess) {
      final ServicesListResponceEntity? servicesEntity = result.entity;
      _categorizedServices.clear();
      _categorizedServices
          .addAll(servicesEntity?.services ?? <ServiceEntity>[]);
      _nextKey = servicesEntity?.nextKey;
      _hasMore = _nextKey != null;
    }

    _setLoading(false);
  }

  //
  final List<ServiceEntity> _serviceResults = <ServiceEntity>[];
  // String? _serviceNextKey;
  final TextEditingController search = TextEditingController();

  List<ServiceEntity> get serviceResults => _serviceResults;
  Future<void> searchServices(String query) async {
    if (query.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    final DataState<SearchEntity> result = await _searchUsecase.call(
      SearchParams(
          entityType: SearchEntityType.services,
          query: query,
          pageSize: 5,
          sortBy: SortOption.dateAscending,
          lastEvaluatedKey: '',
          lat: _selectedLocation.latitude,
          lon: _selectedLocation.longitude),
    );

    if (result is DataSuccess<SearchEntity>) {
      searchedServices.clear();
      searchedServices.addAll(result.entity?.services ?? <ServiceEntity>[]);
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

  ///
  ///
  ///
  ///
  LatLng _selectedLocation = const LatLng(0, 0);
  String _selectedLocationName = '';
  LatLng get selectedLocation => _selectedLocation;
  String get selectedLocationName => _selectedLocationName;
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
