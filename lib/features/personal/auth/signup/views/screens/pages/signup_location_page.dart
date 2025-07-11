import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/functions/permission_fun.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/signup_provider.dart';

class SignupLocationPage extends StatelessWidget {
  const SignupLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (BuildContext context, SignupProvider pro, _) {
        return FutureBuilder<bool>(
          future: PermissionFun.hasPermissions(<Permission>[
            Permission.location,
            Permission.locationWhenInUse,
          ]),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final bool hasPermission = snapshot.data == true;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'enable_location'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('location_privacy'.tr()),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Column(
                      children: <Widget>[
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(Icons.location_on_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!hasPermission)
                          SizedBox(
                            width: double.infinity,
                            child: CustomElevatedButton(
                              title: 'press_to_enable_location'.tr(),
                              isLoading: pro.isLoading,
                              bgColor: Colors.transparent,
                              border: Border.all(
                                  color: Theme.of(context).disabledColor),
                              onTap: () => pro.enableLocation(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                CustomElevatedButton(
                  title: 'next'.tr(),
                  isLoading: pro.isLoading,
                  onTap: () => pro.onNext(context),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        );
      },
    );
  }
}
