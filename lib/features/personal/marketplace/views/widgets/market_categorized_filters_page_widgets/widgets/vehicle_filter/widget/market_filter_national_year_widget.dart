import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              child: CustomListingDropDown<MarketPlaceProvider>(
                  hint: 'category',
                  categoryKey: 'vehicles',
                  selectedValue: marketPro.vehicleCatgory,
                  onChanged: marketPro.setVehicleCategory)),
        ],
      ),
    );
  }
}
