import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import 'explore_categories_section.dart';
import 'marketplace_header.dart';
import 'filter_container/filter_container.dart';
import '../widgets/marketplace_header_buttons.dart';
import 'marketpace_grid_section.dart';

class MarketPlaceTopSection extends StatelessWidget {
  const MarketPlaceTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        if (marketPro.marketplaceCategory != null) {
          return const FilterContainer();
        } else {
          return Column(
            children: <Widget>[
              const MarketPlaceHeader(),
              const MarketPlaceHeaderButtons(),
              const MarketPlaceCategoriesSection(),
              if (marketPro.isFilteringPosts) const MarketPlacePostsGrid(),
            ],
          );
        }
      },
    );
  }
}
