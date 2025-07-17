import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/choicechip_section/choicechip_section.dart';
import '../../widgets/marketpace_grid_section.dart';
import '../../widgets/marketplace_categories_section.dart';
import '../../widgets/marketplace_header.dart';
import '../../widgets/marketplace_header_buttons.dart';

class MarketPlaceMainPage extends StatelessWidget {
  const MarketPlaceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const MarketPlaceHeader(),
              const MarketPlaceHeaderButtons(),
              if (!pro.isFilteringPosts) const MarketPlaceCategoriesSection(),
              if (!pro.isFilteringPosts) const MarketChoiceChipSection(),
              if (pro.isFilteringPosts) const MarketPlacePostsGrid(),
            ],
          ),
        );
      },
    );
  }
}
