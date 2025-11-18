import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../providers/marketplace_provider.dart';
import 'year_picker_dropdown.dart';

class MarketFilterMakeYearWidget extends StatelessWidget {
  const MarketFilterMakeYearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🟩 get make options from Local Hive Source
    final List<DropdownOptionEntity> makeOptions =
        LocalCategoriesSource.make ?? <DropdownOptionEntity>[];

    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionEntity>(
                options: makeOptions,
                valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                labelGetter: (DropdownOptionEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'make'.tr(),
                selectedValue: marketPro.make,
                onChanged: (String? p0) => marketPro.setMake(p0),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: CustomYearDropdown(
                validator: (bool? p0) => null,
                hintText: 'year'.tr(),
                selectedYear: marketPro.year,
                onChanged: (String? value) => marketPro.setYear(value),
              ),
            ),
          ],
        );
      },
    );
  }
}
