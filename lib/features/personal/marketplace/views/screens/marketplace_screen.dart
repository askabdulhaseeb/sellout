import 'package:flutter/material.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../widgets/explore_categories_section.dart';
import '../widgets/explore_header.dart';
import '../widgets/marketpace_promoted_section.dart';
import '../widgets/marketplace_filter_buttons.dart';
import '../widgets/marketplace_posts.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});
  static const String routeName = '/marketplace';

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            //search line
            ExploreHeader(),
            //filter,sort and location buttons
            MarketPlaceFilterButtons(),
            //categories for next seraching by listing
            ExploreCategoriesSection(),
            //promoted posts in marketplace
            InDevMode(child: MarketplacePromotedSection()),
            //
            ExploreProductsGridview(
              showPersonal: false,
            ),
            //
            Divider(),
            ExploreProductsGridview(
              showPersonal: true,
            ),
          ],
        ),
      ),
    );
  }
}
