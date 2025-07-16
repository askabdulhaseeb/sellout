import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../provider/search_provider.dart';
import '../../widget/user_tile.dart';

class SearchUsersSection extends StatefulWidget {
  const SearchUsersSection({super.key});

  @override
  State<SearchUsersSection> createState() => _SearchUsersSectionState();
}

class _SearchUsersSectionState extends State<SearchUsersSection> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = context.watch<SearchProvider>();

    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            CustomTextFormField(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              prefixIcon: const Icon(Icons.search),
              controller: controller,
              hint: 'search'.tr(),
              autoFocus: true,
              onChanged: provider.searchUsers,
            ),
          ],
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                provider.searchUsers(controller.text.trim(), isLoadMore: true);
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
