import 'package:flutter/material.dart';

import '../../../../../core/sources/api_call.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../domain/usecase/get_special_offer_usecase.dart';
import '../enums/services_page_type.dart';

class ServicesPageProvider extends ChangeNotifier {
  ServicesPageProvider(
    this.getSpecialOfferUsecase,
  );
  final GetSpecialOfferUsecase getSpecialOfferUsecase;
  //
  Future<List<ServiceEntity>> getSpecialOffer() async {
    if (_specialOffer.isNotEmpty) return specialOffer;
    final DataState<List<ServiceEntity>> result =
        await getSpecialOfferUsecase(true);
    if (result is DataSuccess) {
      _specialOffer = result.entity ?? <ServiceEntity>[];
      notifyListeners();
    } else {
      print('Error: ${result.exception?.message}');
    }
    return _specialOffer;
  }

  //
  TextEditingController search = TextEditingController();
  List<ServiceEntity> _specialOffer = <ServiceEntity>[];
  List<ServiceEntity> get specialOffer => _specialOffer;

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
}
