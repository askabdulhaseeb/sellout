import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../enums/gender_type.dart';
import '../../providers/signup_provider.dart';

class SignupDobPage extends StatefulWidget {
  const SignupDobPage({super.key});

  @override
  State<SignupDobPage> createState() => _SignupDobPageState();
}

class _SignupDobPageState extends State<SignupDobPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showCupertinoDatePicker(SignupProvider pro) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        DateTime tempDate = pro.dob ?? DateTime(2000);
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      pro.setDob(tempDate);
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: pro.dob ?? DateTime(2000),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime(DateTime.now().year - 10),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (BuildContext context, SignupProvider pro, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'when_is_your_birthday',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ).tr(),
              const SizedBox(height: 20),

              // DOB Field
              FormField<DateTime>(
                validator: (_) {
                  if (pro.dob == null) return 'please_select_dob'.tr();
                  return null;
                },
                builder: (FormFieldState<DateTime> field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _showCupertinoDatePicker(pro),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pro.dob?.dateWithFullMonth ?? 'select_dob'.tr(),
                          style: TextStyle(
                              color: pro.dob == null
                                  ? Theme.of(context).hintColor
                                  : null),
                        ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Gender Dropdown
              CustomDropdown<Gender>(
                title: 'gender'.tr(),
                items: Gender.values
                    .map((Gender g) => DropdownMenuItem<Gender>(
                        value: g, child: Text(g.code.tr())))
                    .toList(),
                selectedItem: pro.gender,
                onChanged: (Gender? g) => pro.setGender(g),
                validator: (_) {
                  if (pro.gender == null) return 'please_select_gender'.tr();
                  return null;
                },
              ),

              const Spacer(),

              // Next Button
              CustomElevatedButton(
                title: 'next'.tr(),
                isLoading: pro.isLoading,
                isDisable: false,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    pro.onNext(context);
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
