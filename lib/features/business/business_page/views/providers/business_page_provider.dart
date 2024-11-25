import 'package:flutter/material.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../../../core/domain/usecase/get_business_by_id_usecase.dart';
import '../enum/business_page_tab_type.dart';

class BusinessPageProvider extends ChangeNotifier {
  BusinessPageProvider(this.byID);
  final GetBusinessByIdUsecase byID;

  BusinessEntity? _business;
  BusinessEntity? get business => _business;
  set business(BusinessEntity? value) {
    _business = value;
    notifyListeners();
  }

  BusinessPageTabType _selectedTab = BusinessPageTabType.calender;
  BusinessPageTabType get selectedTab => _selectedTab;
  set selectedTab(BusinessPageTabType value) {
    _selectedTab = value;
    notifyListeners();
  }

  Future<BusinessEntity?> getBusinessByID(String businessID) async {
    final DataState<BusinessEntity?> result = await byID(businessID);
    if (result.entity == null) {
      return null;
    }
    business = result.entity;
    return business;
  }
}
