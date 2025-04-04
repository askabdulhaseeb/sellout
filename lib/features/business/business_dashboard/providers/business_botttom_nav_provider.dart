import 'package:flutter/foundation.dart';
import '../../../../core/enums/nav_bar/business_bottom_nav_bar_type.dart';
export '../../../../../core/enums/nav_bar/personal_bottom_nav_bar_type.dart';

class BusinessBottomNavProvider extends ChangeNotifier {
  BusienssBottomNavBarType _currentTab = kDebugMode
      ? BusienssBottomNavBarType.home
      : BusienssBottomNavBarType.home;

  BusienssBottomNavBarType get currentTab => _currentTab;
  int get currentTabIndex => _currentTab.index;

  void setCurrentTab(BusienssBottomNavBarType tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void setCurrentTabIndex(int index) {
    _currentTab = BusienssBottomNavBarType.values.elementAt(index);
    notifyListeners();
  }
}
