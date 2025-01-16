import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/signup_provider.dart';

class SignupOtpVerificationPage extends StatelessWidget {
  const SignupOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
        builder: (BuildContext context, SignupProvider pro, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'enter_6_digit_code',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ).tr(),
          Text('${'your_code_was_send_to'.tr()} +1234567890'),
          CustomTextFormField(
            controller: pro.otp,
            autoFocus: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: kDebugMode ? (String p0) => pro.onNext() : null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${'resend_code'.tr()}: ${pro.resendCodeTime}s'),
              TextButton(
                onPressed: pro.resendCodeTime != 0
                    ? null
                    : () async => pro.resendCode(context),
                child: Text('resend_code'.tr()),
              )
            ],
          ),
        ],
      );
    });
  }
}
