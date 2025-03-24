import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/signup_provider.dart';

class SignupPhotoVerificationPage extends StatelessWidget {
  const SignupPhotoVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
        builder: (BuildContext context, SignupProvider pro, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'photo_verification',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ).tr(),
          const Text('photo_verification_subtitle').tr(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(color: Colors.grey),
            ),
          ),
          const Text('photo_verification_policy').tr(),
          const Spacer(),
          CustomElevatedButton(
            title: 'next'.tr(),
            isLoading: pro.isLoading,
            onTap: () => pro.onNext(context),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
