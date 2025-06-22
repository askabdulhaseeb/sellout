import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class SizeDropdown extends StatelessWidget {
  const SizeDropdown({
    required this.formPro,
    required this.selectedSize,
    required this.onSizeChanged,
    super.key,
  });

  final AddListingFormProvider formPro;
  final String? selectedSize;
  final ValueChanged<String?> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero, // ensure no padding around
      child: CustomListingDropDown(
        hint: 'size'.tr(),
        categoryKey: formPro.selectedClothSubCategory == 'clothes'
            ? 'clothes_sizes'
            : 'foot_sizes',
        onChanged: onSizeChanged,
        selectedValue: selectedSize,
      ),
    );
  }
}
