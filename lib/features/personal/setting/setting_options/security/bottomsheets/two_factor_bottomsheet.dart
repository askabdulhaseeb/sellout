import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../user/profiles/views/params/update_user_params.dart';
import '../../../../../../core/widgets/custom_switch_list_tile.dart'; // Adjust path as needed

class TwoFactorAuthBottomSheet extends StatefulWidget {
  const TwoFactorAuthBottomSheet({super.key});

  @override
  State<TwoFactorAuthBottomSheet> createState() =>
      _TwoFactorAuthBottomSheetState();
}

class _TwoFactorAuthBottomSheetState extends State<TwoFactorAuthBottomSheet> {
  final UpdateProfileDetailUsecase usecase =
      UpdateProfileDetailUsecase(locator());
  late bool isTwoFactorEnabled;
  late String uid;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isTwoFactorEnabled = LocalAuth.currentUser?.twoStepAuthEnabled ?? false;
    uid = LocalAuth.uid ?? '';
  }

  Future<void> _updateLocalUser(bool newValue) async {
    final CurrentUserEntity? currentUser = LocalAuth.currentUser;
    if (currentUser == null) return;

    final CurrentUserEntity updatedUser =
        currentUser.copyWith(twoStepAuthEnabled: newValue);
    await LocalAuth().signin(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ],
          ),
          Text(
            'two_step_verification'.tr(),
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'verify_with_4_digit_code'.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
              letterSpacing: 0.25,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Use custom switch tile
          CustomSwitchListTile(
            loading: loading,
            title: 'enable_2fa'.tr(),
            value: isTwoFactorEnabled,
            onChanged: (bool value) async {
              if (uid.isEmpty) {
                debugPrint('UID is empty');
                return;
              }
              setState(() {
                loading = true;
              });
              final DataState<String> result = await usecase.call(
                UpdateUserParams(
                  twoFactorAuth: value,
                ),
              );
              debugPrint('2FA update result: $result');
              if (result is DataSuccess) {
                await _updateLocalUser(value);
                setState(() {
                  isTwoFactorEnabled = value;
                  loading = false;
                });
              } else {
                setState(() {
                  loading = false;
                });
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('something_wrong'.tr()),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
