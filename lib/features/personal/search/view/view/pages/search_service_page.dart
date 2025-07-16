import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../provider/search_provider.dart';
import '../../widget/services_grid_tile.dart';

class SearchServicesSection extends StatefulWidget {
  const SearchServicesSection({super.key});

  @override
  State<SearchServicesSection> createState() => _SearchServicesSectionState();
}

class _SearchServicesSectionState extends State<SearchServicesSection> {
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
          children: [
            CustomTextFormField(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              controller: controller,
              hint: 'search'.tr(),
              onChanged: provider.searchServices,
            ),
          ],
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                provider.searchServices(controller.text.trim(),
                    isLoadMore: true);
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
                          SearchServiceGridTile(
                              service: provider.serviceResults[index]),
                      childCount: provider.serviceResults.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                      childAspectRatio: 0.8,
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
