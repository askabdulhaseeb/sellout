import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';
import '../../market_filter_address_dropdown.dart';

class MarketFilterPropertyTypeandAddedWidget extends StatelessWidget {
  const MarketFilterPropertyTypeandAddedWidget({
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
              hint: 'property_type',
              categoryKey: 'property_type',
              selectedValue: marketPro.propertyType,
              onChanged: (String? p0) => marketPro.setPropertyType(p0),
            ),
          ),
          const Expanded(child: AddedFilterDropdown())
        ],
      ),
    );
  }
}
