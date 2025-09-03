import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/enums/business/services/service_model_type.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../providers/add_service_provider.dart';

class AddServiceDropdownSection extends StatelessWidget {
  const AddServiceDropdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
      builder: (BuildContext context, AddServiceProvider pro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: pro.title,
              labelText: 'service_name'.tr(),
              hint: 'service_name'.tr(),
              maxLength: 50,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
            CustomDropdown<ServiceCategoryType?>(
                title: 'service_category'.tr(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                items: ServiceCategoryType.categories().map(
                  (ServiceCategoryType category) {
                    return DropdownMenuItem<ServiceCategoryType>(
                      value: category,
                      child: Text(
                        '${category.code.tr()} (${category.category})',
                        style: TextTheme.of(context).bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ).toList(),
                selectedItem: pro.selectedCategory,
                onChanged: (ServiceCategoryType? value) =>
                    pro.setSelectedCategory(value),
                validator: (bool? isValid) =>
                    (pro.selectedCategory == null) ? 'select_type'.tr() : null),
            const SizedBox(height: 8),
            CustomDropdown<ServiceType?>(
                title: 'service_type'.tr(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                items:
                    (pro.selectedCategory?.serviceTypes ?? <ServiceType>[]).map(
                  (ServiceType type) {
                    return DropdownMenuItem<ServiceType>(
                      value: type,
                      child: Text(
                        type.code.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextTheme.of(context).bodyLarge,
                      ),
                    );
                  },
                ).toList(),
                selectedItem: pro.selectedType,
                onChanged: (ServiceType? value) => pro.setSelectedType(value),
                validator: (bool? isValid) =>
                    (pro.selectedType == null) ? 'select_type'.tr() : null),
            const SizedBox(height: 8),
            CustomDropdown<ServiceModelType?>(
                title: 'service_model'.tr(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                items: ServiceModelType.models().map(
                  (ServiceModelType type) {
                    return DropdownMenuItem<ServiceModelType>(
                      value: type,
                      child: Text(
                        type.code.tr(),
                        style: TextTheme.of(context).bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ).toList(),
                selectedItem: pro.selectedModelType,
                onChanged: (ServiceModelType? value) =>
                    pro.setSelectedModelType(value),
                validator: (bool? isValid) => (pro.selectedModelType == null)
                    ? 'select_type'.tr()
                    : null),
          ],
        );
      },
    );
  }
}
