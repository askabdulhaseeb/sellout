import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../providers/add_service_provider.dart';

class AddServiceButtonSection extends StatelessWidget {
  const AddServiceButtonSection({required this.formKey, super.key});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
      builder: (BuildContext context, AddServiceProvider pro, _) {
        return CustomElevatedButton(
          title: pro.currentService?.serviceID == null
              ? 'add'.tr()
              : 'update'.tr(),
          isLoading: pro.isLoading,
          onTap: () async {
            if (formKey.currentState?.validate() ?? false) {
              if (pro.attachments.isEmpty &&
                  (pro.currentService?.attachments.isEmpty ?? true)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Add_photo_video'.tr())),
                );
                return;
              }

              if (pro.selectedEmployeeUIDs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('assign_employees'.tr())),
                );
                return;
              }

              // If both validations pass
              if (pro.currentService?.serviceID == null) {
                await pro.addService(context);
              } else {
                await pro.updateService(context);
              }
            }
          },
        );
      },
    );
  }
}
