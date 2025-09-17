import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../providers/marketplace_provider.dart';
import '../../market_filter_address_dropdown.dart';

class MarketFilterPropertyTypeAndAddedWidget extends StatelessWidget {
  const MarketFilterPropertyTypeAndAddedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🟩 Get propertyType options from Local Hive Source
    final List<DropdownOptionEntity> propertyTypeOptions =
        LocalCategoriesSource.propertyType ?? <DropdownOptionEntity>[];

    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionEntity>(
                options: propertyTypeOptions,
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'property_type'.tr(),
                selectedValue: marketPro.propertyType,
                onChanged: (String? p0) => marketPro.setPropertyType(p0),
              ),
            ),
            const SizedBox(width: 4),
            const Expanded(child: AddedFilterDropdown()),
          ],
        );
      },
    );
  }
}
