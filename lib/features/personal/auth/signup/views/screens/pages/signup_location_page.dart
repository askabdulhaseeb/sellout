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
          builder: (
            BuildContext context,
            AsyncSnapshot<bool> snapshot,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'enable_location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).tr(),
                const Text('location_privacy').tr(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 32),
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(Icons.location_on_outlined),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: snapshot.data == true
                              ? const SizedBox(height: 52)
                              : CustomElevatedButton(
                                  title: 'press_to_enable_location'.tr(),
                                  isLoading: false,
                                  border: Border.all(
                                      color: Theme.of(context).disabledColor),
                                  bgColor: Colors.transparent,
                                  onTap: () async {
                                    pro.enableLocation(context);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                CustomElevatedButton(
                  title: 'next'.tr(),
                  isLoading: false,
                  onTap: () => pro.onNext(),
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
