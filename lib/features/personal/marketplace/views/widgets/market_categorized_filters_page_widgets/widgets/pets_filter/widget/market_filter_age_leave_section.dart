import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterAgeLeaveWidget extends StatelessWidget {
  const MarketFilterAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Pull options directly from your local source
    final List<DropdownOptionEntity> ageOptions =
        LocalCategoriesSource.age ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> readyToLeaveOptions =
        LocalCategoriesSource.readyToLeave ?? <DropdownOptionEntity>[];

    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          children: <Widget>[
            /// Age dropdown
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionEntity>(
                options: ageOptions,
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'age'.tr(),
                selectedValue: marketPro.age,
                onChanged: (String? p0) => marketPro.setAge(p0),
              ),
            ),
            const SizedBox(width: 4),

            /// Ready to leave dropdown
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionEntity>(
                options: readyToLeaveOptions,
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'ready_to_leave'.tr(),
                selectedValue: marketPro.readyToLeave,
                onChanged: (String? p0) => marketPro.setReadyToLeave(p0),
              ),
            ),
          ],
        );
      },
    );
  }
}
