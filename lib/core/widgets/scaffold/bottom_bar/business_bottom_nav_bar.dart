import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/personal/auth/signin/data/sources/local/local_auth.dart'
    show LocalAuth;
import '../../../../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../enums/nav_bar/business_bottom_nav_bar_type.dart';

class BusinessBottomNavBar extends StatefulWidget {
  const BusinessBottomNavBar({super.key});

  @override
  State<BusinessBottomNavBar> createState() => _BusinessBottomNavBarState();
}

class _BusinessBottomNavBarState extends State<BusinessBottomNavBar> {
  UserEntity? user;

  @override
  void initState() {
    super.initState();
    final String? uid = LocalAuth.uid;
    if (uid != null) {
      LocalUser().user(uid).then((UserEntity? value) {
        setState(() {
          user = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalBottomNavProvider>(
      builder: (BuildContext context, PersonalBottomNavProvider navPro, _) {
        return SafeArea(
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: navPro.currentTabIndex,
            unselectedItemColor: Theme.of(context).disabledColor,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (int index) => navPro.setCurrentTabIndex(index),
            items: BusienssBottomNavBarType.list.map((
              BusienssBottomNavBarType type,
            ) {
              return BottomNavigationBarItem(
                icon: Icon(type.icon),
                activeIcon: Icon(type.activeIcon),
                label: type.code.tr(),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
