import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../enums/category_types.dart';
import '../enums/sort_enums.dart';
import '../providers/explore_provider.dart';
import '../screens/filter_categories/explore_cloth_foot_screen.dart';
import '../screens/filter_categories/explore_food_drink_screen.dart';
import '../screens/filter_categories/explore_pets_screen.dart';
import '../screens/filter_categories/explore_property_screen.dart';
import '../screens/filter_categories/explore_vehicles_screen.dart';
import 'bottomsheets/filter_bottomsheet.dart';
import 'bottomsheets/location_bottomsheet.dart';
import 'bottomsheets/sort_bottomsheet.dart';
import '../screens/filter_categories/explore_popular_screen.dart';

class ExploreCategoriesSection extends StatelessWidget {
  const ExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreProvider pro =
        Provider.of<ExploreProvider>(context, listen: false);
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color outlineColor = Theme.of(context).colorScheme.outline;
    final TextStyle? textStyle = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildContainer(
                context,
                '${'location'.tr()} - ${Provider.of<ExploreProvider>(context).selectedRadius} Km',
                CupertinoIcons.location_solid,
                primaryColor,
                outlineColor,
                textStyle,
                () => showBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const LocationRadiusBottomSheet();
                    })),
            _buildContainer(
                context,
                'sort'.tr(),
                CupertinoIcons.sort_down,
                primaryColor,
                outlineColor,
                textStyle,
                () => showBottomSheet(
                    context: context,
                    builder: (BuildContext context) => SortBottomSheet(
                          onSortSelected: (SortOption option) {
                            pro.setSortOption(option);
                          },
                        ))),
            _buildContainer(
                context,
                'filter'.tr(),
                Icons.tune,
                primaryColor,
                outlineColor,
                textStyle,
                () => showBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        const FilterBottomSheet())),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'discover_categories'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final CategoryType category = categories[index];
            return InkWell(
              onTap: () {
                if (category.name == 'popular') {
                  pro.filterPopularResults();
                  Navigator.pushNamed(context, ExplorePopularScreen.routeName);
                }
                if (category.name == 'cloth_foot') {
                  pro.filterFootResults();
                  pro.filterCLothResults();
                  Navigator.pushNamed(
                      context, ExploreCLothFOotScreen.routeName);
                }
                if (category.name == 'pets') {
                  pro.filterpetResults();
                  Navigator.pushNamed(context, ExplorePetsScreen.routeName);
                }
                if (category.name == 'vehicles') {
                  pro.filtervehicleResults();
                  Navigator.pushNamed(context, ExploreVehiclesScreen.routeName);
                }
                if (category.name == 'food_drink') {
                  Navigator.pushNamed(
                      context, ExploreFoodDrinkScreen.routeName);
                }
                if (category.name == 'property') {
                  pro.filterSaleResults();
                  pro.filterRentResults();
                  Navigator.pushNamed(context, ExplorePropertyScreen.routeName);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomNetworkImage(
                          fit: BoxFit.cover, imageURL: category.imageUrl),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          category.name.tr(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Divider()
      ],
    );
  }

  Widget _buildContainer(
      BuildContext context,
      String label,
      IconData icon,
      Color iconColor,
      Color borderColor,
      TextStyle? textStyle,
      VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 5),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
