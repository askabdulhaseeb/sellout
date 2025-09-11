import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingBrandField extends StatelessWidget {
  const AddListingBrandField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
              Widget? child) =>
          Expanded(
        child: CustomListingDropDown<AddListingFormProvider>(
          title: 'brand'.tr(),
          validator: (bool? p0) => null,
          hint: 'brand'.tr(),
          categoryKey: formPro.selectedClothSubCategory == 'clothes'
              ? 'clothes_brands'
              : 'footwear_brands',
          selectedValue: formPro.brand,
          onChanged: (String? p0) => formPro.setBrand(p0),
        ),
      ),
    );
  }
}
