import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/explore_categories_section.dart';
import '../widgets/explore_header.dart';
import '../widgets/filters/filter_container.dart';
import '../widgets/marketpace_grid_section.dart';
import '../widgets/marketplace_header_buttons.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});
  static const String routeName = '/marketplace';

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  @override
  void initState() {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    marketPro.loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro = context.watch<MarketPlaceProvider>();

    return PersonalScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 6,
          children: <Widget>[
            MarketPlaceTopSection(marketPro: marketPro),
            MarketPlacePostsGrid(posts: marketPro.posts ?? <PostEntity>[]),
          ],
        ),
      ),
    );
  }
}

class MarketPlaceTopSection extends StatelessWidget {
  const MarketPlaceTopSection({required this.marketPro, super.key});
  final MarketPlaceProvider marketPro;

  @override
  Widget build(BuildContext context) {
    if (marketPro.marketplaceCategory != null) {
      return const FilterContainer();
    } else {
      return const Column(
        children: <Widget>[
          ExploreHeader(),
          MarketPlaceHeaderButtons(),
          ExploreCategoriesSection(),
        ],
      );
    }
  }
}
