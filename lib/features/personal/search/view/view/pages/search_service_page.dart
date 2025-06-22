import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../services/views/widgets/service_card/service_card.dart';
import '../../provider/search_provider.dart';

class SearchServicesSection extends StatelessWidget {
  const SearchServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = context.watch<SearchProvider>();
    final TextEditingController controller = TextEditingController(
      text: provider.serviceQuery,
    );

    return Column(
      children: <Widget>[
        CustomTextFormField(
          controller: controller,
          hint: 'search'.tr(),
          onChanged: provider.searchServices,
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                provider.searchServices(provider.currentQuery,
                    isLoadMore: true);
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
                          ServiceCard(service: provider.serviceResults[index]),
                      childCount: provider.serviceResults.length,
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
