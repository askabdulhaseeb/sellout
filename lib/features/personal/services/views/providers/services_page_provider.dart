import 'package:flutter/material.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../business/business_page/domain/usecase/get_business_bookings_list_usecase.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../bookings/data/sources/local_booking.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../domain/usecase/get_special_offer_usecase.dart';
import '../enums/service_appointment_section_type.dart';
import '../enums/services_page_type.dart';

class ServicesPageProvider extends ChangeNotifier {
  ServicesPageProvider(
    this._getSpecialOfferUsecase,
    this._getBookingsListUsecase,
    this._getBusinessByIdUsecase,
  );
  final GetSpecialOfferUsecase _getSpecialOfferUsecase;
  final GetBookingsListUsecase _getBookingsListUsecase;
  final GetBusinessByIdUsecase _getBusinessByIdUsecase;
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

  Future<List<BookingEntity>> getBookings({bool isForces = false}) async {
    if (isForces == false && _bookings.isNotEmpty) return _bookings;
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
  TextEditingController search = TextEditingController();
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
}
