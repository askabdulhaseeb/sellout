import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/in_dev_mode.dart';
import '../marketplace_filter_searchfield.dart';
import 'widgets/market_filter_cloth_foot_category_location_widget.dart';
import 'widgets/market_filter_cloth_foot_toggle_widget.dart';
import 'widgets/market_filter_size_color_widget.dart';

class MarketClothFootFilterSection extends StatelessWidget {
  const MarketClothFootFilterSection({
    required this.screenWidth,
    super.key,
  });
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MarketFilterClothFootToggleWidget(screenWidth: screenWidth),
        const MarketFilterSearchField(),
        const MarketFilterClothFootCategoryAndLocationWIdget(),
        const InDevMode(child: MarketFilterSizeColorWidget()),
      ],
    );
  }
}
