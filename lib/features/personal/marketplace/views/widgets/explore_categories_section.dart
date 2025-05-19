import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/category_types.dart';
import '../providers/marketplace_provider.dart';
import '../screens/filter_categories/explore_cloth_foot_screen.dart';
import '../screens/filter_categories/explore_food_drink_screen.dart';
import '../screens/filter_categories/explore_pets_screen.dart';
import '../screens/filter_categories/explore_property_screen.dart';
import '../screens/filter_categories/explore_vehicles_screen.dart';
import '../screens/filter_categories/explore_popular_screen.dart';

class ExploreCategoriesSection extends StatelessWidget {
  const ExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider pro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                      child: Image.asset(category.imageUrl, fit: BoxFit.cover),
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
}
