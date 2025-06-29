import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../setting/setting_dashboard/views/screens/personal_setting_screen.dart';
import '../../screens/edit_profile_screen.dart';

class ProfileEditAndSettingsWidget extends StatelessWidget {
  const ProfileEditAndSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const InDevMode(
            child: Icon(
          Icons.home_outlined,
        )),
        GestureDetector(
          onTap: () {},
          child: PopupMenuButton<int>(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            offset: const Offset(-30, 30),
            elevation: 15,
            color: Theme.of(context).scaffoldBackgroundColor,
            onSelected: (int value) {
              if (value == 1) {
                Navigator.pushNamed(context, EditProfileScreen.routeName);
              } else if (value == 2) {
                Navigator.of(context)
                    .pushNamed(PersonalSettingScreen.routeName);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.edit,
                      size: 14,
                    ),
                    Text('edit_profile'.tr()),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.settings,
                      size: 14,
                    ),
                    Text('settings'.tr()),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        )
      ],
    );
  }
}
