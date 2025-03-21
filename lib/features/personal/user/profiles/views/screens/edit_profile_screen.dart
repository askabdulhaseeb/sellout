import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  static const String routeName = '/edit_profile';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile'.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              /// Profile Picture
              const Center(
                child: CircleAvatar(
                  radius: 50,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor:
                          Theme.of(context).primaryColor.withAlpha(30)),
                  icon: const Icon(CupertinoIcons.power),
                  label: Text('upload_profile'.tr()),
                  onPressed: () {}),
              /// Name Field
              CustomTextFormField(
                labelText: 'name'.tr(),
                controller: nameController,
              ),
              const SizedBox(height: 16),
              /// Email Field
              CustomTextFormField(
                labelText: 'username'.tr(),
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'bio'.tr(),
                controller: emailController,
              ),
              const SizedBox(height: 20),
              /// Save Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                    onTap: () {}, isLoading: false, title: 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
