import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterNationYearWidget extends StatelessWidget {
  const MarketFilterNationYearWidget({
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
            child: InDevMode(
                child: CustomListingDropDown<MarketPlaceProvider>(
              hint: 'national',
              categoryKey: '',
              selectedValue: marketPro.make,
              onChanged: (String? p0) => marketPro.setMake(p0),
            )),
          ),
          Expanded(
            child: InDevMode(
                child: CustomListingDropDown<MarketPlaceProvider>(
              hint: 'year',
              categoryKey: '',
              selectedValue: marketPro.year,
              onChanged: (String? p0) => marketPro.setYear(p0),
            )),
          ),
        ],
      ),
    );
  }
}
