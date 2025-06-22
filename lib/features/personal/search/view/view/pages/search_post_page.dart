import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../provider/search_provider.dart';

class SearchPostsSection extends StatelessWidget {
  const SearchPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = context.watch<SearchProvider>();
    final TextEditingController controller = TextEditingController(
      text: provider.postQuery,
    );

    return Column(
      children: <Widget>[
        CustomTextFormField(
          controller: controller,
          hint: 'search'.tr(),
          onChanged: provider.searchPosts,
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                provider.searchPosts(provider.postQuery, isLoadMore: true);
              }
              return false;
            },
            child: CustomScrollView(
              controller: provider.currentScrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          PostGridViewTile(post: provider.postResults[index]),
                      childCount: provider.postResults.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                      childAspectRatio: 0.75,
                    ),
                  ),
                ),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
