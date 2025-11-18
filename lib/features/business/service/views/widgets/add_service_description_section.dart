import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/custom_textformfield.dart';
import '../providers/add_service_provider.dart';

class AddServiceDescriptionSection extends StatelessWidget {
  const AddServiceDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
      builder: (BuildContext context, AddServiceProvider pro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
                controller: pro.description,
                labelText: 'description'.tr(),
                maxLines: 5,
                maxLength: 300,
                isExpanded: true,
                validator: (String? value) => AppValidator.isEmpty(value)),
            CustomTextFormField(
              controller: pro.included,
              labelText: 'what_included_the_service'.tr(),
              maxLines: 5,
              maxLength: 300,
              isExpanded: true,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
            CustomTextFormField(
                controller: pro.notIncluded,
                labelText: 'what_not_included_the_service'.tr(),
                maxLines: 5,
                maxLength: 300,
                isExpanded: true,
                validator: (String? value) => AppValidator.isEmpty(value)),
          ],
        );
      },
    );
  }
}
