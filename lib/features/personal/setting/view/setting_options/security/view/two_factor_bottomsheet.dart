import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../../user/profiles/views/params/update_user_params.dart';

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

  @override
  void initState() {
    super.initState();
    isTwoFactorEnabled = LocalAuth.currentUser?.twoStepAuthEnabled ?? false;
    uid = LocalAuth.uid ?? '';
  }

  Future<void> _updateLocalUser(bool newValue) async {
    final currentUser = LocalAuth.currentUser;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(twoStepAuthEnabled: newValue);
    await LocalAuth().signin(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'two_step_verification'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'verify_with_4_digit_code'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  letterSpacing: 0.25,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Enable 2FA'),
              Switch(
                value: isTwoFactorEnabled,
                onChanged: (bool value) async {
                  if (uid.isEmpty) {
                    debugPrint('UID is empty');
                    return;
                  }

                  final DataState<String> result = await usecase.call(
                    UpdateUserParams(
                      uid: uid,
                      twoFactorAuth: value,
                    ),
                  );

                  debugPrint('2FA update result: $result');

                  if (result is DataSuccess) {
                    await _updateLocalUser(value);

                    setState(() {
                      isTwoFactorEnabled = value;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update 2FA status'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
