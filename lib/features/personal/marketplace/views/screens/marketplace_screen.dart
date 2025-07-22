import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/choicechip_section/choicechip_section.dart';
import '../widgets/marketpace_grid_section.dart';
import '../widgets/marketplace_categories_section.dart';
import '../widgets/marketplace_header.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});
  static const String routeName = '/marketplace';

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final MarketPlaceProvider provider = context.read<MarketPlaceProvider>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 12000) {
        provider.loadMorePosts();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketPlaceProvider>().choiceChipsCategory('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: Consumer<MarketPlaceProvider>(
        builder: (BuildContext context, MarketPlaceProvider pro, _) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              const SliverToBoxAdapter(child: MarketPlaceHeader()),
              if (!pro.isFilteringPosts)
                const SliverToBoxAdapter(child: MarketPlaceCategoriesSection()),
              if (pro.isFilteringPosts) const MarketPlacePostsGrid(),
              if (!pro.isFilteringPosts)
                const SliverToBoxAdapter(child: MarketChoiceChipSection()),
              if (pro.isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
