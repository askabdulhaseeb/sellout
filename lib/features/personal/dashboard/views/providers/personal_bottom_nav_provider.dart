import 'package:flutter/material.dart';

import '../../../../../core/enums/nav_bar/personal_bottom_nav_bar_type.dart';
export '../../../../../core/enums/nav_bar/personal_bottom_nav_bar_type.dart';

class PersonalBottomNavProvider extends ChangeNotifier {
  PersonalBottomNavBarType _currentTab = PersonalBottomNavBarType.home;

  PersonalBottomNavBarType get currentTab => _currentTab;
  int get currentTabIndex => _currentTab.index;

  void setCurrentTab(PersonalBottomNavBarType tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void setCurrentTabIndex(int index) {
    _currentTab = PersonalBottomNavBarType.values.elementAt(index);
    notifyListeners();
  }
}
