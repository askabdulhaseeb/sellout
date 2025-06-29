import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../providers/services_page_provider.dart';
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

class ServicesPageExploreCategoriesSection extends StatelessWidget {
  const ServicesPageExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ServiceCategoryType> categories = ServiceCategoryType.values;
    final ServiceCategoryType? selectedCategory =
        context.watch<ServicesPageProvider>().selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'categories'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final ServiceCategoryType category = categories[index];
              final bool isSelected = category == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<ServicesPageProvider>()
                        .setSelectedCategory(category);
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CustomNetworkImage(
                              imageURL: category.imageURL,
                              placeholder: category.name,
                              fit: BoxFit.cover,
                              size: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            category.code,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
