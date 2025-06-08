import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../features/personal/chats/chat_dashboard/views/widgets/unseen_message_badge.dart';
import '../../../../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../features/personal/user/profiles/data/sources/local/local_user.dart';

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
              icon: Stack(
                children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(type.icon,),
                  ),
       if (type == PersonalBottomNavBarType.list[4])   const Positioned(top: 0,right: 0,child:  TotalUnreadMessagesBadgeWidget())
                ],
              ),
              activeIcon: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(type.activeIcon),
                  ),
                   if (type == PersonalBottomNavBarType.list[4])    const Positioned(top: 0,right: 0,child:  TotalUnreadMessagesBadgeWidget())
              
                ],
              ),
              label: type.code.tr(),
            );
          }).toList(),
        );
      },
    );
  }
}
