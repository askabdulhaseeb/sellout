import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../functions/app_log.dart';
import '../../profile_photo.dart';

class PersonalBottomNavBar extends StatefulWidget {
  const PersonalBottomNavBar({super.key});

  @override
  State<PersonalBottomNavBar> createState() => _PersonalBottomNavBarState();
}

class _PersonalBottomNavBarState extends State<PersonalBottomNavBar> {
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
        return BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: navPro.currentTabIndex,
          unselectedItemColor: Theme.of(context).disabledColor,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (int index) => navPro.setCurrentTabIndex(index),
          items: PersonalBottomNavBarType.list
              .map((PersonalBottomNavBarType type) {
            return BottomNavigationBarItem(
              icon: type.code != 'profile'
                  ? Icon(type.icon)
                  : user == null
                      ? Icon(type.icon)
                      : GestureDetector(
                          onLongPress: () {
                            AppLog.info(
                              'Profile photo long pressed',
                              name: 'PersonalBottomNavBar',
                            );
                          },
                          child: ProfilePhoto(
                            url: user?.profilePhotoURL,
                            isCircle: true,
                            size: 14,
                          ),
                        ),
              activeIcon: type.code != 'profile'
                  ? Icon(type.activeIcon)
                  : user == null
                      ? Icon(type.activeIcon)
                      : GestureDetector(
                          onLongPress: () {
                            AppLog.info(
                              'Profile photo long pressed',
                              name: 'PersonalBottomNavBar',
                            );
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: ProfilePhoto(
                              url: user?.profilePhotoURL,
                              isCircle: true,
                              size: 14,
                            ),
                          ),
                        ),
              label: type.code.tr(),
            );
          }).toList(),
        );
      },
    );
  }
}
