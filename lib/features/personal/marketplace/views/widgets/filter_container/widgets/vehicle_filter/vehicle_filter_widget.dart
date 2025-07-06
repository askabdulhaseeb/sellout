import 'package:flutter/material.dart';
import '../market_filter_price_widget.dart';
import 'widget/market_filter_make_model_widget.dart';
import 'widget/market_filter_national_year_widget.dart';
import 'widget/market_filter_vehicle_category_location.dart';

class VehicleFIlterWidget extends StatelessWidget {
  const VehicleFIlterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        // MarketFilterSearchField(),
        MarketFilterVehicleCategoryAndLocationWIdget(),
        MarketFilterNationYearWidget(),
        MarketFilterMakeModelWidget(),
        MarketFilterPriceWIdget(),
      ],
    );
  }
}
