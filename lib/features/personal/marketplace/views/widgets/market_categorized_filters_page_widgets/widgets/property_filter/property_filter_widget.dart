import 'package:flutter/material.dart';
import '../market_filter_price_widget.dart';
import 'widget/market_filter_property_categrory_location_widget.dart';
import 'widget/market_filter_property_toggle_widget.dart';
import 'widget/market_filter_property_type_and_added_widget.dart';

class PropertyFilterSection extends StatelessWidget {
  const PropertyFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MarketFilterPropertyToggleWidget(),
        const MarketFilterpropertyCategoryAndLocationWIdget(),
        const MarketFilterPropertyTypeandAddedWidget(),
        const MarketFilterPriceWIdget()
      ],
    );
  }
}
