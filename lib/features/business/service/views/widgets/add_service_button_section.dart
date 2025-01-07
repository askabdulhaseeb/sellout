import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_elevated_button.dart';
import '../providers/add_service_provider.dart';

class AddServiceButtonSection extends StatelessWidget {
  const AddServiceButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
      builder: (BuildContext context, AddServiceProvider pro, _) {
        return CustomElevatedButton(
          title: 'add'.tr(),
          isLoading: pro.isLoading,
          onTap: () async => pro.addService(context),
        );
      },
    );
  }
}
