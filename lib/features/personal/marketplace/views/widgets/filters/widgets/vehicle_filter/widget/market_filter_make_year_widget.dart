import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

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
              child: CustomListingDropDown(
            hint: 'make',
            categoryKey: 'make',
            selectedValue: marketPro.make,
            onChanged: (String? p0) => marketPro.setMake(p0),
          )),
          // Expanded(
          //     child: CustomListingDropDown(
          //   hint: 'year',
          //   categoryKey: 'year',
          //   selectedValue: marketPro.year,
          //   onChanged: (String? p0) => marketPro.setYear(p0),
          // )),
        ],
      ),
    );
  }
}
