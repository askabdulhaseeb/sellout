import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/business/services/service_model_type.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/inputs/custom_dropdown.dart';
import '../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../personal/services/data/sources/local/local_service_categories.dart';
import '../../../../personal/services/domain/entity/service_category_entity.dart';
import '../../../../personal/services/domain/entity/service_type_entity.dart';
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
            CustomDropdown<ServiceCategoryEntity?>(
              title: 'service_category'.tr(),
              items: LocalServiceCategory()
                  .getAllCategories()
                  .map((ServiceCategoryEntity category) {
                    return DropdownMenuItem<ServiceCategoryEntity?>(
                      value: category,
                      child: Text(
                        '${category.label.tr()} (${category.category})',
                        style: TextTheme.of(context).bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  })
                  .toList()
                  .cast<DropdownMenuItem<ServiceCategoryEntity?>>(),
              selectedItem: pro.selectedCategory,
              onChanged: (ServiceCategoryEntity? value) =>
                  pro.setSelectedCategory(value),
              validator: (bool? isValid) =>
                  (pro.selectedCategory == null) ? 'select_type'.tr() : null,
            ),
            const SizedBox(height: 8),
            CustomDropdown<ServiceTypeEntity?>(
              title: 'service_type'.tr(),
              items:
                  (pro.selectedCategory?.serviceTypes ?? <ServiceTypeEntity>[])
                      .map((ServiceTypeEntity type) {
                        return DropdownMenuItem<ServiceTypeEntity>(
                          value: type,
                          child: Text(
                            type.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextTheme.of(context).bodyLarge,
                          ),
                        );
                      })
                      .toList(),
              selectedItem: pro.selectedType,
              onChanged: (ServiceTypeEntity? value) =>
                  pro.setSelectedType(value),
              validator: (bool? isValid) =>
                  (pro.selectedType == null) ? 'select_type'.tr() : null,
            ),
            const SizedBox(height: 8),
            CustomDropdown<ServiceModelType?>(
              title: 'service_model'.tr(),
              items: ServiceModelType.models().map((ServiceModelType type) {
                return DropdownMenuItem<ServiceModelType>(
                  value: type,
                  child: Text(
                    type.code.tr(),
                    style: TextTheme.of(context).bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              selectedItem: pro.selectedModelType,
              onChanged: (ServiceModelType? value) =>
                  pro.setSelectedModelType(value),
              validator: (bool? isValid) =>
                  (pro.selectedModelType == null) ? 'select_type'.tr() : null,
            ),
          ],
        );
      },
    );
  }
}
