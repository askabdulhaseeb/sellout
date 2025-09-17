import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class SizeDropdown extends StatelessWidget {
  const SizeDropdown({
    required this.formPro,
    required this.selectedSize,
    required this.onSizeChanged,
    this.overlayAbove = false,
    super.key,
  });

  final AddListingFormProvider formPro;
  final String? selectedSize;
  final ValueChanged<String?> onSizeChanged;
  final bool overlayAbove;

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> clothesSizes =
        LocalCategoriesSource.clothesSizes ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> footSizes =
        LocalCategoriesSource.footSizes ?? <DropdownOptionEntity>[];
    return Padding(
      padding: EdgeInsets.zero,
      child:
          CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
        validator: (bool? p0) => null,
        hint: 'size'.tr(),
        overlayAbove: overlayAbove,
        options: formPro.selectedClothSubCategory == 'clothes'
            ? clothesSizes
            : footSizes,
        valueGetter: (DropdownOptionEntity opt) => opt.value.value,
        labelGetter: (DropdownOptionEntity opt) => opt.label,
        selectedValue: formPro.selectedVehicleCategory,
        onChanged: (String? p0) => formPro.setVehicleCategory(p0),
      ),
    );
  }
}
