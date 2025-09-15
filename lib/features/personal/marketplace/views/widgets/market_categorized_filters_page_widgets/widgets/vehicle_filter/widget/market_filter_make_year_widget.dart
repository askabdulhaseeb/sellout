import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';
import 'year_picker_dropdown.dart';

class MarketFilterMakeYearWidget extends StatelessWidget {
  const MarketFilterMakeYearWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Row(
        spacing: 4,
        children: <Widget>[
          Expanded(
              child: CustomListingDropDown<MarketPlaceProvider>(
            validator: (bool? p0) => null,
            hint: 'make'.tr(),
            categoryKey: 'make',
            selectedValue: marketPro.make,
            onChanged: (String? p0) => marketPro.setMake(p0),
          )),
          Expanded(
            child: CustomYearDropdown(
              validator: (bool? p0) => null,
              hintText: 'year'.tr(),
              selectedYear: marketPro.year,
              onChanged: (String? value) => marketPro.setYear(value),
            ),
          ),
        ],
      ),
    );
  }
}
