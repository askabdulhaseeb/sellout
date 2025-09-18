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
        // Decide which list to use
        final List<DropdownOptionDataEntity> brandOptions =
            formPro.selectedClothSubCategory == 'clothes'
                ? clothesBrands
                : footwearBrands;
        return CustomDropdown<DropdownOptionDataEntity>(
          items: brandOptions
              .map((DropdownOptionDataEntity e) =>
                  DropdownMenuItem<DropdownOptionDataEntity>(
                      child: Text(e.label)))
              .toList(),
          title: 'brand'.tr(),
          hint: 'brand'.tr(),
          selectedItem: null,
          validator: (bool? value) =>
              value == true ? null : AppValidator.requireSelection(value),
          onChanged: (DropdownOptionDataEntity? value) =>
              formPro.setBrand(value?.value),
        );
      },
    );
  }
}
