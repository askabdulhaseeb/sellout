import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../provider/search_provider.dart';

class SearchPostsSection extends StatefulWidget {
  const SearchPostsSection({super.key});

  @override
  State<SearchPostsSection> createState() => _SearchPostsSectionState();
}

class _SearchPostsSectionState extends State<SearchPostsSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final SearchProvider provider = context.read<SearchProvider>();
    _controller = TextEditingController(text: provider.postQuery);
  }

  @override
  void didUpdateWidget(covariant SearchPostsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final SearchProvider provider = context.read<SearchProvider>();
    // Update controller text when switching type
    final String query = provider.currentQuery;
    if (_controller.text != query) {
      _controller.text = query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = context.watch<SearchProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            autoFocus: true,
            controller: _controller,
            hint: 'search'.tr(),
            onChanged: (String value) {
              provider.search(_controller.text);
            },
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!provider.isLoading &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100) {
                  provider.search(provider.currentQuery, isLoadMore: true);
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
                              childAspectRatio: 0.75),
                    ),
                  ),
                  if (provider.isLoading)
                    const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
