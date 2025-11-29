import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_make_year_widget.dart';
import 'widget/market_filter_location_widget.dart';
import 'widget/market_filter_vehicle_category_model.dart';

class VehicleFIlterWidget extends StatelessWidget {
  const VehicleFIlterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: AppSpacing.vSm,
      children: <Widget>[
        MarketFilterSearchField(),
        MarketFilterLocationWidget(),
        MarketFilterVehicleCategoryAndModalWidget(),
        MarketFilterMakeYearWidget(),
        MarketFilterPriceWIdget(),
      ],
    );
  }
}
