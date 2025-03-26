import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/tabbarviews/cloth_tabbar.dart';
import '../../widgets/tabbarviews/foot_tabbar.dart';

class ExploreCLothFOotScreen extends StatefulWidget {
  const ExploreCLothFOotScreen({
    super.key,
  });
  static const String routeName = '/explore-cloth-foot';

  @override
  State<ExploreCLothFOotScreen> createState() => _ExploreCLothFOotScreenState();
}

class _ExploreCLothFOotScreenState extends State<ExploreCLothFOotScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ExploreProvider exploreProvider =
        Provider.of<ExploreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 140,
        leading: TextButton.icon(
          style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant),
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
          label: Text('go_back'.tr()),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                children: <Widget>[
                  Text('cloth_foot'.tr(), style: textTheme.titleMedium),
                  Text(
                      '${'find_perfect'.tr()} ${'cloth_foot'.tr()}${'items'.tr()}',
                      style: textTheme.bodySmall),
                  const SizedBox(height: 10),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: colorScheme.outlineVariant)),
                          padding: const EdgeInsets.all(2),
                          child: TabBar(
                            padding: const EdgeInsets.all(0),
                            labelPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: colorScheme.primary)),
                            tabs: <Widget>[
                              Tab(text: 'clothing'.tr()),
                              Tab(text: 'footware'.tr()),
                            ],
                            onTap: (int index) {
                              exploreProvider.updatefootclothSelectedTab(index);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 320,
                          child: TabBarView(children: <Widget>[
                            ClothTabbarWidget(
                                exploreProvider: exploreProvider,
                                textTheme: textTheme,
                                colorScheme: colorScheme),
                            FootwearTabbarWidget(
                                exploreProvider: exploreProvider,
                                textTheme: textTheme,
                                colorScheme: colorScheme)
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<ExploreProvider>(
              builder: (BuildContext context, ExploreProvider provider,
                  Widget? child) {
                final List<PostEntity> footPosts =
                    provider.footCategoryFilteredList.toSet().toList();
                final List<PostEntity> clothPosts =
                    provider.clothCategoryFilteredList.toSet().toList();

                return provider.selectedfootclothTab == 0
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: clothPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PostEntity post = clothPosts[index];
                          return PostGridViewTile(post: post);
                        },
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: footPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PostEntity post = footPosts[index];
                          return PostGridViewTile(post: post);
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
