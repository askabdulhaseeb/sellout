import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EditAccountSettingScreen extends StatefulWidget {
  const EditAccountSettingScreen({super.key});
  static const String routeName = '/setting-account-edit';

  @override
  State<EditAccountSettingScreen> createState() =>
      _EditAccountSettingScreenState();
}

class _EditAccountSettingScreenState extends State<EditAccountSettingScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  DateTime selectedDate = DateTime(1991, 6, 12);

  @override
  void initState() {
    super.initState();
    _birthdayController.text =
        DateFormat('MMM dd yyyy').format(selectedDate); // Example: May 20 2025
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthdayController.text = DateFormat('MMM dd yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('edit_account'.tr(), style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLabel('name'.tr(), textTheme),
            _buildTextField(hint: 'Zubair Hussain', textTheme: textTheme),
            _buildLabel('email'.tr(), textTheme),
            _buildTextField(hint: 'zubair@gmail.com', textTheme: textTheme),
            _buildLabel('phone_number'.tr(), textTheme),
            _buildTextField(hint: '+447 (124) 45623', textTheme: textTheme),
            const SizedBox(height: 4),
            Text(
              'phone_note'.tr(),
              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
            _buildLabel('gender'.tr(), textTheme),
            _buildDropdown(['Male', 'Female'], 'Male', textTheme),
            _buildLabel('birthday'.tr(), textTheme),
            _buildDateField(textTheme),
            _buildLabel('language'.tr(), textTheme),
            _buildDropdown(
                ['English (Default)', 'Urdu'], 'English (Default)', textTheme),
            _buildLabel('country'.tr(), textTheme),
            _buildDropdown(
                ['United Kingdom', 'Pakistan'], 'United Kingdom', textTheme),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/change_password'); // or use: ChangePasswordScreen.routeName
              },
              icon: const Icon(Icons.lock_outline),
              label: Text('change_password'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
                child: Text('save_settings'.tr(),
                    style: textTheme.labelLarge?.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(text, style: textTheme.labelLarge),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextTheme textTheme,
  }) {
    return TextFormField(
      initialValue: hint,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: textTheme.bodyMedium,
    );
  }

  Widget _buildDropdown(
      List<String> items, String selected, TextTheme textTheme) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: textTheme.bodyMedium),
              ))
          .toList(),
      onChanged: (_) {},
    );
  }

  Widget _buildDateField(TextTheme textTheme) {
    return TextFormField(
      controller: _birthdayController,
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: textTheme.bodyMedium,
      onTap: () => _pickDate(context),
    );
  }
}
