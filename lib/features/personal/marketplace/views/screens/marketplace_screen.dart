import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/explore_categories_section.dart';
import '../widgets/explore_header.dart';
import '../widgets/filters/filter_container.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});
  static const String routeName = '/marketplace';

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro = context.watch<MarketPlaceProvider>();

    return PersonalScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
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

class MarketPlacePostsGrid extends StatelessWidget {
  const MarketPlacePostsGrid({required this.posts, super.key});
  final List<PostEntity> posts;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const SizedBox();
    }
    return GridView.builder(
      itemCount: posts.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (BuildContext context, int index) {
        return PostGridViewTile(post: posts[index]);
      },
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
          ExploreCategoriesSection(),
        ],
      );
    }
  }
}
