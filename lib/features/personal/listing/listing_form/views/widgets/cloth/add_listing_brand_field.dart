import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingBrandField extends StatelessWidget {
  const AddListingBrandField({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionDataEntity> clothesBrands =
        LocalCategoriesSource.clothesBrands ?? <DropdownOptionDataEntity>[];
    final List<DropdownOptionDataEntity> footwearBrands =
        LocalCategoriesSource.footwearBrands ?? <DropdownOptionDataEntity>[];
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        final List<DropdownOptionDataEntity> brandOptions =
            formPro.selectedClothSubCategory == 'clothes'
                ? clothesBrands
                : footwearBrands;

        final DropdownOptionDataEntity? selectedBrand =
            DropdownOptionDataEntity.findByValue(
          brandOptions,
          formPro.brand ?? '',
        );
        return CustomDropdown<DropdownOptionDataEntity>(
            items: brandOptions
                .map((DropdownOptionDataEntity e) =>
                    DropdownMenuItem<DropdownOptionDataEntity>(
                      value: e,
                      child: Text(
                        e.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ))
                .toList(),
            title: 'brand'.tr(),
            hint: 'brand'.tr(),
            selectedItem: selectedBrand,
            validator: (bool? value) {
              if (value == null) return AppValidator.requireSelection(false);
              return null;
            },
            onChanged: (DropdownOptionDataEntity? value) =>
                formPro.setBrand(value?.value));
      },
    );
  }
}
