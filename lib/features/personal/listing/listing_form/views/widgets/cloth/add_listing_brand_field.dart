import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingBrandField extends StatelessWidget {
  const AddListingBrandField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionDataEntity> clothesBrands =
        LocalCategoriesSource.clothesBrands ?? <DropdownOptionDataEntity>[];
    final List<DropdownOptionDataEntity> footwearBrands =
        LocalCategoriesSource.footwearBrands ?? <DropdownOptionDataEntity>[];
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
              Widget? child) =>
          CustomListingDropDown<AddListingFormProvider,
              DropdownOptionDataEntity>(
        title: 'brand'.tr(),
        validator: (bool? p0) => null,
        valueGetter: (DropdownOptionDataEntity opt) => opt.value,
        labelGetter: (DropdownOptionDataEntity opt) => opt.label,
        hint: 'brand'.tr(),
        options: formPro.selectedClothSubCategory == 'clothes'
            ? clothesBrands
            : footwearBrands,
        selectedValue: formPro.brand,
        onChanged: (String? p0) => formPro.setBrand(p0),
      ),
    );
  }
}
