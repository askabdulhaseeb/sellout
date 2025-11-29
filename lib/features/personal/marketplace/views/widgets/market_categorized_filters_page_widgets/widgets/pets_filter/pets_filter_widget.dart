import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_age_leave_section.dart';
import 'widget/market_filter_pets_category_location_widget.dart';

class PetsFilterWIdget extends StatelessWidget {
  const PetsFilterWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: AppSpacing.vSm,
      children: <Widget>[
        MarketFilterSearchField(),
        MarketFilterPetsCategoryAndLocationWidget(),
        MarketFilterAgeLeaveWidget(),
        MarketFilterPriceWIdget(),
      ],
    );
  }
}
