import 'package:flutter/material.dart';

class EditAccountSettingScreen extends StatelessWidget {
  const EditAccountSettingScreen({super.key});
  static const String routeName = '/setting-account-edit';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account', style: textTheme.titleMedium),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLabel('Name:', textTheme),
            _buildTextField(hint: 'Zubair Hussain', textTheme: textTheme),
            _buildLabel('Email address:', textTheme),
            _buildTextField(hint: 'zubair@gmail.com', textTheme: textTheme),
            _buildLabel('Phone Number:', textTheme),
            _buildTextField(
              hint: '+447 (124) 45623',
              textTheme: textTheme,
            ),
            const SizedBox(height: 4),
            Text(
              'Your phone number will only be used to help you log in. It won’t be made public, or used for marketing purposes.',
              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 16),
            _buildLabel('Gender', textTheme),
            _buildDropdown(<String>['Male', 'Female'], 'Male', textTheme),
            _buildLabel('Birthday', textTheme),
            _buildDateField('12/06/1991', textTheme),
            _buildLabel('Language', textTheme),
            _buildDropdown(<String>['English (Default)', 'Urdu'],
                'English (Default)', textTheme),
            _buildLabel('Country', textTheme),
            _buildDropdown(<String>['United Kingdom', 'Pakistan'],
                'United Kingdom', textTheme),
            _buildLabel('Password', textTheme),
            _buildTextField(
                hint: '************', obscureText: true, textTheme: textTheme),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
                child: Text('Save Settings',
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
    bool obscureText = false,
    required TextTheme textTheme,
  }) {
    return TextFormField(
      obscureText: obscureText,
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
          .map((String item) => DropdownMenuItem(
              value: item, child: Text(item, style: textTheme.bodyMedium)))
          .toList(),
      onChanged: (_) {},
    );
  }

  Widget _buildDateField(String date, TextTheme textTheme) {
    return TextFormField(
      readOnly: true,
      initialValue: date,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: textTheme.bodyMedium,
      onTap: () {
        // Add date picker if needed
      },
    );
  }
}
