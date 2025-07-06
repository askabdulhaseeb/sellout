import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/explore/service_categories_section/services_page_explore_categories_section.dart';
import '../../widgets/explore/services_page_explore_search_results_section.dart';
import '../../widgets/explore/services_page_explore_searching_section.dart';

class ServicePageExploreSection extends StatefulWidget {
  const ServicePageExploreSection({super.key});

  @override
  State<ServicePageExploreSection> createState() =>
      _ServicePageExploreSectionState();
}

class _ServicePageExploreSectionState extends State<ServicePageExploreSection> {
  @override
  void initState() {
    super.initState();
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);
    pro.getSpecialOffer();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ServicesPageExploreSearchingSection(),
          ServicesPageExploreCategoriesSection(),
          // ServicesPageExploreSpecialOfferSection(),
          ServiceSearchResults(),
        ],
      ),
    );
  }
}
