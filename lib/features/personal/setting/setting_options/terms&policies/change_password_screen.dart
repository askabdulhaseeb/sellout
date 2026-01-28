import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../core/widgets/inputs/password_textformfield.dart';
import '../security/provider/setting_security_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String routeName = '/change_password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SettingSecurityProvider provider =
        Provider.of<SettingSecurityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('change_password'.tr()), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              PasswordTextFormField(
                controller: _oldPassword,
                labelText: 'old_password'.tr(),
                validator: (String? value) => AppValidator.isEmpty(value),
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                controller: _newPassword,
                labelText: 'new_password'.tr(),
                validator: (String? value) => AppValidator.password(value),
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                controller: _confirmPassword,
                labelText: 'confirm_password'.tr(),
                validator: (String? value) => AppValidator.confirmPassword(
                  _newPassword.text,
                  _confirmPassword.text,
                ),
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                title: 'save_password'.tr(),
                isLoading: provider.isLoading,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    provider.changePassword(
                      context,
                      oldPassword: _oldPassword.text.trim(),
                      newPassword: _newPassword.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
