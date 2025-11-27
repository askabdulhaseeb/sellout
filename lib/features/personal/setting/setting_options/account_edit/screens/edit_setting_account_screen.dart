import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../core/widgets/phone_number/views/phone_number_input_field.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../setting_dashboard/view/providers/personal_setting_provider.dart';

class EditAccountSettingScreen extends StatefulWidget {
  const EditAccountSettingScreen({super.key});
  static const String routeName = '/setting-account-edit';

  @override
  State<EditAccountSettingScreen> createState() =>
      _EditAccountSettingScreenState();
}

class _EditAccountSettingScreenState extends State<EditAccountSettingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: LocalAuth.currentUser?.displayName);

  PhoneNumberEntity? _phoneEntity = PhoneNumberEntity(
      countryCode: LocalAuth.currentUser?.countryCode ?? '',
      number: LocalAuth.currentUser?.phoneNumber ?? '00000000');

  DateTime? _birthday = LocalAuth.currentUser?.dob;

  @override
  Widget build(BuildContext context) {
    debugPrint(_birthday.toString());
    final PersonalSettingProvider pro =
        Provider.of<PersonalSettingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleKey: 'edit_account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // <-- Add form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // NAME FIELD
              CustomTextFormField(
                labelText: 'name'.tr(),
                controller: _nameController,
                onChanged: (String value) => pro.setName(value),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'name_required'.tr(); // add this localization key
                  }
                  if (value.trim().length < 2) {
                    return 'name_too_short'.tr(); // optional
                  }
                  return null;
                },
              ),

              // PHONE NUMBER FIELD
              PhoneNumberInputField(
                onChange: (PhoneNumberEntity phone) {
                  _phoneEntity = phone;
                  pro.setPhone(phone);
                },
                initialValue: _phoneEntity,
                labelText: 'phone_number'.tr(),
              ),

              // BIRTHDAY PICKER
              BirthdayPicker(
                label: 'birthday'.tr(),
                initialDate: _birthday,
                onDateSelected: (DateTime date) {
                  setState(() => _birthday = date);
                  pro.setDob(date);
                },
              ),

              const SizedBox(height: 24),

              // SAVE BUTTON
              CustomElevatedButton(
                bgColor: Theme.of(context).colorScheme.secondary,
                isLoading: pro.isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    pro.updateProfileDetail(context);
                  }
                },
                title: 'save_settings'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
    super.key,
  });
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 10),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).primaryColor,
                ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      widget.onDateSelected(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.label, style: textTheme.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _selectedDate == null
                      ? 'Select your birthday'
                      : DateFormat.yMMMMd().format(_selectedDate!),
                  style: textTheme.bodyMedium,
                ),
                const Icon(Icons.calendar_month_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
