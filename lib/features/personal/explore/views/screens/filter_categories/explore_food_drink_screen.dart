import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/price_range_widget.dart';

class ExploreFoodDrinkScreen extends StatelessWidget {
  const ExploreFoodDrinkScreen({
    super.key,
  });
  static const String routeName = '/explore-food-drink';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ExploreProvider exploreProvider =
        Provider.of<ExploreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 140,
        leading: TextButton.icon(
          style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant),
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
          label: Text('go_back'.tr()),
        ),
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                children: <Widget>[
                  Text('food_drink'.tr(), style: textTheme.titleMedium),
                  Text(
                      '${'find_perfect'.tr()} ${'food_drink'.tr()}${' items'.tr()}',
                      style: textTheme.bodySmall),
                  const SizedBox(height: 10),
                  const SizedBox(height: 4),
                  CustomTextFormField(
                    controller: exploreProvider.searchController,
                    hint: 'search'.tr(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<DeliveryType>(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          hint: Text(
                            'delivery_collection'.tr(),
                            style: textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: exploreProvider.selectedDelivery,
                          isExpanded: true,
                          onChanged: (DeliveryType? newValue) =>
                              exploreProvider.setDeliveryType(newValue),
                          items:
                              DeliveryType.values.map((DeliveryType delivery) {
                            return DropdownMenuItem<DeliveryType>(
                              value: delivery,
                              child: Text(delivery.name.tr()),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          hint: Text(
                            overflow: TextOverflow.ellipsis,
                            'added_to_site'.tr(),
                            style: textTheme.bodySmall,
                          ),
                          value: exploreProvider.selectedDateFilter,
                          isExpanded: true,
                          onChanged: (String? newValue) =>
                              exploreProvider.setDateFilter(newValue),
                          items: exploreProvider.dateFilterOptions
                              .map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text('$option ${'days_ago'.tr()} '),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const PriceRangeWidget(),
                  const SizedBox(height: 10),
                  CustomElevatedButton(
                      isLoading: false,
                      onTap: () {
                        exploreProvider.applyPopularFilters();
                        debugPrint(
                            'filtered list:${exploreProvider.popularCategoryFilteredList}');
                      },
                      title: 'search'.tr()),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          onPressed: () => exploreProvider.resetFilters(),
                          child: Text(
                            'reset'.tr(),
                            style: TextStyle(
                              decorationColor: colorScheme.outlineVariant,
                              decoration: TextDecoration.underline,
                              color: colorScheme.outlineVariant,
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
