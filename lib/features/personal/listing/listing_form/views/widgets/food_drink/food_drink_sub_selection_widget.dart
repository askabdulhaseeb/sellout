import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingFoodDrinkSubcatSelectionSection extends StatelessWidget {
  const AddListingFoodDrinkSubcatSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> subCategories =
        ListingType.foodAndDrink.cids.getRange(0, 2).toList();
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider addPro, _) {
      return CustomToggleSwitch<String>(
        verticalPadding: 8,
        containerHeight: 40,
        isShaded: false,
        labels: subCategories,
        labelStrs: subCategories.map((String e) => e.tr()).toList(),
        labelText: 'please_select'.tr(),
        initialValue: addPro.selectedFoodDrinkSubCategory,
        onToggle: (String p0) => addPro.setSelectedFoodDrinkSubCategory(p0),
      );
    });
  }
}
