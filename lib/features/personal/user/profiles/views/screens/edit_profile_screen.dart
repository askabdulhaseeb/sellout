import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  static const String routeName = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro =
        Provider.of<ProfileProvider>(context, listen: false);
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
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CustomNetworkImage(
                          fit: BoxFit.cover,
                          imageURL: pro.user?.profilePhotoURL)),
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
                onPressed: () {
                  pro.updateProfilePicture(context);
                },
              ),
              CustomTextFormField(
                labelText: 'name'.tr(),
                controller: pro.namecontroller,
              ),
              const SizedBox(height: 16),

              /// Email Field
              CustomTextFormField(
                readOnly: true,
                labelText: 'username'.tr(),
                controller: TextEditingController(),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'bio'.tr(),
                controller: pro.biocontroller,
              ),
              const SizedBox(height: 20),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                    onTap: () {
                      final result = pro.updateProfileDetail(context);
                      if (result is DataSuccess) {
                        Navigator.pop(context);
                      }
                    },
                    isLoading: false,
                    title: 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
