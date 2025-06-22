import 'package:flutter/material.dart';
import '../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../market_filter_price_widget.dart';
import 'widget/market_filter_property_toggle_widget.dart';

class PropertyFilterSection extends StatelessWidget {
  const PropertyFilterSection({
    required this.screenWidth,
    super.key,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarketFilterPropertyToggleWidget(
          screenWidth: screenWidth,
        ),
        CustomListingDropDown(
          hint: 'property_type',
          categoryKey: 'property_type',
          selectedValue: '',
          onChanged: (String? p0) => null,
        ),
        const MarketFilterPriceWIdget()
      ],
    );
  }
}
