import 'package:flutter/material.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../../../core/domain/usecase/get_business_by_id_usecase.dart';
import '../../domain/entities/services_list_responce_entity.dart';
import '../../domain/params/get_business_serives_param.dart';
import '../../domain/usecase/get_services_list_by_business_id_usecase.dart';
import '../enum/business_page_tab_type.dart';

class BusinessPageProvider extends ChangeNotifier {
  BusinessPageProvider(this._byID, this._servicesListUsecase);
  final GetBusinessByIdUsecase _byID;
  final GetServicesListByBusinessIdUsecase _servicesListUsecase;

  BusinessEntity? _business;
  BusinessEntity? get business => _business;

  GetBusinessSerivesParam? _servicesListParam;
  GetBusinessSerivesParam? get servicesListParam => _servicesListParam;
  set servicesListParam(GetBusinessSerivesParam? value) {
    _servicesListParam = value;
    notifyListeners();
  }

  set business(BusinessEntity? value) {
    _business = value;
    _servicesListParam = null;
    notifyListeners();
  }

  BusinessPageTabType _selectedTab = BusinessPageTabType.calender;
  BusinessPageTabType get selectedTab => _selectedTab;
  set selectedTab(BusinessPageTabType value) {
    _selectedTab = value;
    notifyListeners();
  }

  Future<BusinessEntity?> getBusinessByID(String businessID) async {
    if (businessID.isEmpty) return null;
    if (businessID == _business?.businessID) return business;
    // Locad business from remote storage
    final DataState<BusinessEntity?> result = await _byID(businessID);
    if (result.entity == null) {
      return null;
    }
    business = result.entity;
    return business;
  }

  Future<DataState<ServicesListResponceEntity>> getServicesListByBusinessID(
      String businessID) async {
    if (businessID.isEmpty) {
      return DataFailer<ServicesListResponceEntity>(
          CustomException('Business ID is empty'));
    }
    final DataState<ServicesListResponceEntity> result =
        await _servicesListUsecase(
      _servicesListParam ?? GetBusinessSerivesParam(businessID: businessID),
    );
    if (result is DataSuccess) {
      _servicesListParam = GetBusinessSerivesParam(
        businessID: businessID,
        nextKey: result.entity?.nextKey,
        sort: _servicesListParam?.sort ?? 'lowToHigh',
      );
      return result;
    } else {
      return DataFailer<ServicesListResponceEntity>(
          CustomException('Failed to get services list'));
    }
  }
}
