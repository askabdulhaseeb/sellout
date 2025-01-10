import 'package:flutter/material.dart';

import '../../widgets/explore/services_page_explore_categories_section.dart';
import '../../widgets/explore/services_page_explore_searching_section.dart';
import '../../widgets/explore/services_page_explore_special_offer_section.dart';

class ServicePageExploreSection extends StatelessWidget {
  const ServicePageExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        ServicesPageExploreSearchingSection(),
        ServicesPageExploreCategoriesSection(),
        ServicesPageExploreSpecialOfferSection(),
      ],
    );
  }
}
