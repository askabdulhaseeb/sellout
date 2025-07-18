import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/market_categorized_filters_page_widgets/filter_container.dart';
import '../../widgets/market_categorized_filters_page_widgets/filter_container_gridview.dart';
import '../../widgets/market_categorized_filters_page_widgets/widgets/market_filter_container_back_button.dart';

class MarketCategorizedFilterationPage extends StatelessWidget {
  const MarketCategorizedFilterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const GoBAckButtonWidget(),
            MarketFilterContainer(screenWidth: screenWidth),
            const MarketPlaceFilterContainerPostsGrid()
          ],
        );
      },
    );
  }
}
