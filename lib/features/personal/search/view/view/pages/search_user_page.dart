import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../provider/search_provider.dart';
import '../../widget/user_tile.dart';

class SearchUsersSection extends StatelessWidget {
  const SearchUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = context.watch<SearchProvider>();
    final TextEditingController _controller =
        TextEditingController(text: provider.userQuery);

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
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) =>
                              UserTile(user: provider.userResults[index]),
                          childCount: provider.userResults.length,
                        ),
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
        ));
  }
}
