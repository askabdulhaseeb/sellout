import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/explore/service_categories_section/services_page_explore_categories_section.dart';
import '../../widgets/explore/services_page_explore_search_results_section.dart';
import '../../widgets/explore/services_page_explore_searching_section.dart';
import '../../widgets/service_filter_dropdown.dart';
import '../../widgets/service_sort_dropdown.dart';

class ServicePageExploreSection extends StatefulWidget {
  const ServicePageExploreSection({super.key});

  @override
  State<ServicePageExploreSection> createState() =>
      _ServicePageExploreSectionState();
}

class _ServicePageExploreSectionState extends State<ServicePageExploreSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const ServicesPageExploreSearchingSection(),
              if (pro.search.text.isNotEmpty)
                const Row(
                  children: <Widget>[
                    Expanded(child: SortButtonWithBottomSheet()),
                    SizedBox(width: 8),
                    Expanded(child: FillterButtonWithBottomSheet()),
                  ],
                ),
              if (pro.search.text.isEmpty)
                const ServicesPageExploreCategoriesSection(),
              if (pro.search.text.isNotEmpty) const ServiceSearchResults(),
            ],
          ),
        );
      },
    );
  }
}
