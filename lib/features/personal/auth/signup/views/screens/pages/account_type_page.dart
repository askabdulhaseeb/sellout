import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/signup_provider.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});
  static const String routeName = '/signup-profile-type';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SignupProvider>(
        builder: (BuildContext context, SignupProvider pro, _) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Lets_get_started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ).tr(),
              const Text(
                textAlign: TextAlign.center,
                'Personal_account_policy',
                style: TextStyle(color: Colors.grey),
              ).tr(),
              const Text(
                textAlign: TextAlign.center,
                'business_account_policy',
                style: TextStyle(color: Colors.grey),
              ).tr(),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  pro.setAccountType(true);
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: pro.accountType == true
                          ? ColorScheme.of(context).primary
                          : ColorScheme.of(context).outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'personal'.tr(),
                    style: TextStyle(
                      color: pro.accountType == true
                          ? Colors.black
                          : ColorScheme.of(context).outline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              // Professional Button
              InkWell(
                onTap: () {
                  pro.setAccountType(false); // Select Professional
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: pro.accountType == false
                          ? ColorScheme.of(context).primary
                          : ColorScheme.of(context).outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'business'.tr(),
                    style: TextStyle(
                      color: pro.accountType == false
                          ? Colors.black
                          : ColorScheme.of(context).outline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              CustomElevatedButton(
                title: 'next'.tr(),
                isLoading: pro.isLoading,
                onTap: () {
                  pro.onNext(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
