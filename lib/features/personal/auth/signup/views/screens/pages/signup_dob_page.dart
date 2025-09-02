import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../enums/gender_type.dart';
import '../../providers/signup_provider.dart';

class SignupDobPage extends StatelessWidget {
  const SignupDobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (BuildContext context, SignupProvider pro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'when_is_your_birthday',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).tr(),
            const Text('birthday_policy').tr(),
            const SizedBox(height: 20),
            // Date Picker Field
            InkWell(
              onTap: pro.isLoading
                  ? null
                  : () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(DateTime.now().year - 10),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: AppTheme.dark.copyWith(
                              colorScheme:
                                  Theme.of(context).colorScheme.copyWith(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                            ),
                            child: child ?? const SizedBox(),
                          );
                        },
                      );
                      if (date != null) {
                        pro.setDob(date);
                      }
                    },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: pro.dob == null
                          ? Text(
                              'select_dob'.tr(),
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            )
                          : Text(pro.dob!.dateWithFullMonth),
                    ),
                    const Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gender Dropdown
            CustomDropdown<Gender>(
              title: 'gender'.tr(),
              items: Gender.values
                  .map((Gender option) => DropdownMenuItem<Gender>(
                      value: option, child: Text(option.code.tr())))
                  .toList(),
              selectedItem: pro.gender,
              onChanged: (Gender? value) {
                if (value == null) return;
                pro.setGender(value);
              },
              validator: (_) {
                if (pro.gender == null) {
                  return 'please_select_gender'.tr();
                }
                return null;
              },
            ),

            const Spacer(),

            // Next Button
            CustomElevatedButton(
              title: 'next'.tr(),
              isLoading: pro.isLoading,
              isDisable: false,
              onTap: () async {
                if (pro.dob == null || pro.gender == null) {
                  final String errorMessage = pro.dob == null
                      ? 'please_select_dob'.tr()
                      : 'please_select_gender'.tr();
                  AppSnackBar.showSnackBar(context, errorMessage);
                  return;
                }
                pro.onNext(context);
              },
            ),

            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
