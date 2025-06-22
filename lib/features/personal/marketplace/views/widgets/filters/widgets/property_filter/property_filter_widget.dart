import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../providers/marketplace_provider.dart';
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
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Column(
      children: [
        MarketFilterPropertyToggleWidget(
          screenWidth: screenWidth,
        ),
        CustomListingDropDown(
          hint: 'property_type',
          categoryKey: 'property_type',
          selectedValue: marketPro.propertyType,
          onChanged: (String? p0) => marketPro.setPropertyType(p0),
        ),
        const MarketFilterPriceWIdget()
      ],
    );
  }
}
