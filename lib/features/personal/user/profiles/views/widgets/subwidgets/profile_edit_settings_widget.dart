import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../setting/setting_dashboard/view/screens/personal_setting_screen.dart';
import '../../screens/edit_profile_screen.dart';

class ProfileEditAndSettingsWidget extends StatefulWidget {
  const ProfileEditAndSettingsWidget({super.key});

  @override
  State<ProfileEditAndSettingsWidget> createState() =>
      _ProfileEditAndSettingsWidgetState();
}

class _ProfileEditAndSettingsWidgetState
    extends State<ProfileEditAndSettingsWidget> {
  OverlayEntry? _overlayEntry;

  void _showMenu(BuildContext context) {
    final RenderBox button =
        context.findRenderObject() as RenderBox; // icon button position
    final Offset position = button.localToGlobal(Offset.zero);
    final Size size = button.size;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: position.dx + size.width - 160,
                top: position.dy + size.height + 5,
                child: Material(
                  elevation: 12,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _removeOverlay();
                            AppNavigator.pushNamed(EditProfileScreen.routeName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Row(
                              children: <Widget>[
                                const CustomSvgIcon(
                                  size: 18,
                                  assetPath: AppStrings
                                      .selloutProfileHeaderMoreEditProfileIcon,
                                ),
                                const SizedBox(width: 6),
                                Text('edit_profile'.tr()),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          indent: 6,
                          endIndent: 6,
                        ),
                        InkWell(
                          onTap: () {
                            _removeOverlay();
                            Navigator.of(context)
                                .pushNamed(PersonalSettingScreen.routeName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Row(
                              children: <Widget>[
                                const CustomSvgIcon(
                                  size: 18,
                                  assetPath: AppStrings
                                      .selloutProfileHeaderMoreSettingsIcon,
                                ),
                                const SizedBox(width: 6),
                                Text('settings'.tr()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomSvgIcon(
          size: 18,
          assetPath: AppStrings.selloutProfileBankIcon,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            if (_overlayEntry == null) {
              _showMenu(context);
            } else {
              _removeOverlay();
            }
          },
          child: const CustomSvgIcon(
            size: 16,
            assetPath: AppStrings.selloutProfileHeaderMoreIcon,
          ),
        ),
      ],
    );
  }
}
