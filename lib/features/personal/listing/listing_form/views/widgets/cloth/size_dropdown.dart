import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class SizeDropdown extends StatelessWidget {
  const SizeDropdown({
    required this.formPro,
    required this.selectedSize,
    required this.onSizeChanged,
    this.overlayAbove = false,
    super.key,
  });

  final AddListingFormProvider formPro;
  final String? selectedSize; // selected value (string)
  final ValueChanged<String?> onSizeChanged;
  final bool overlayAbove;

  @override
  Widget build(BuildContext context) {
    // get options based on category
    final List<DropdownOptionEntity> clothesSizes =
        LocalCategoriesSource.clothesSizes ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> footSizes =
        LocalCategoriesSource.footSizes ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> sizeOptions =
        formPro.selectedClothSubType == 'clothes' ? clothesSizes : footSizes;

    // use the helper to find the selected item
    final DropdownOptionEntity? selectedEntity =
        formPro.findByValue(sizeOptions, selectedSize ?? '');

    return Padding(
      padding: EdgeInsets.zero,
      child: CustomDropdown<DropdownOptionEntity>(
        title: '',
        hint: 'size'.tr(),
        overlayAbove: overlayAbove,
        items: sizeOptions
            .map(
              (DropdownOptionEntity e) =>
                  DropdownMenuItem<DropdownOptionEntity>(
                value: e,
                child: Text(e.label),
              ),
            )
            .toList(),
        // ✅ pre-select the entity
        selectedItem: selectedEntity,
        validator: (bool? value) => AppValidator.requireSelection(value),
        onChanged: (DropdownOptionEntity? value) {
          onSizeChanged(value?.value.value);
        },
      ),
    );
  }
}
