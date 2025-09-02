import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../setting/setting_dashboard/view/screens/personal_setting_screen.dart';
import '../../screens/edit_profile_screen.dart';

class ProfileEditAndSettingsWidget extends StatelessWidget {
  const ProfileEditAndSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomSvgIcon(
            size: 20, assetPath: AppStrings.selloutProfileBankIcon),
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
                AppNavigator.pushNamed(EditProfileScreen.routeName);
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
                    const CustomSvgIcon(
                        size: 20,
                        assetPath:
                            AppStrings.selloutProfileHeaderMoreEditProfileIcon),
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
                    const CustomSvgIcon(
                      size: 20,
                      assetPath:
                          AppStrings.selloutProfileHeaderMoreSettingsIcon,
                    ),
                    Text('settings'.tr()),
                  ],
                ),
              ),
            ],
            icon: const CustomSvgIcon(
                size: 20, assetPath: AppStrings.selloutProfileHeaderMoreIcon),
          ),
        )
      ],
    );
  }
}
