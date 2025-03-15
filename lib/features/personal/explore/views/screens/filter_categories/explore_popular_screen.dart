import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../enums/category_types.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/price_range_widget.dart';

class ExplorePopularScreen extends StatefulWidget {
  const ExplorePopularScreen({
    super.key,
  });
  static const String routeName = '/explore-popular';

  @override
  State<ExplorePopularScreen> createState() => _ExplorePopularScreenState();
}

class _ExplorePopularScreenState extends State<ExplorePopularScreen> {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  Text('popular'.tr(), style: textTheme.titleMedium),
                  Text(
                      '${'find_perfect'.tr()} ${'popular'.tr()}${' items'.tr()}',
                      style: textTheme.bodySmall),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: exploreProvider.searchController,
                    hint: 'search'.tr(),
                    // onChanged: (String value) =>
                    //     exploreProvider.filterBySearchQuery(value),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<CategoryTypes>(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          hint: Text(
                            overflow: TextOverflow.ellipsis,
                            'category'.tr(),
                            style: textTheme.bodySmall,
                          ),
                          value: exploreProvider.selectedCategory,
                          isExpanded: true,
                          onChanged: (CategoryTypes? newValue) =>
                              exploreProvider.setCategory(newValue),
                          items: CategoryTypes.values
                              .map((CategoryTypes category) {
                            return DropdownMenuItem<CategoryTypes>(
                              value: category,
                              child: Text(category.name.tr()),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
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
            const SizedBox(
              height: 10,
            ),
            Consumer<ExploreProvider>(
              builder: (BuildContext context, ExploreProvider provider,
                  Widget? child) {
                final List<PostEntity> popularPosts =
                    provider.popularCategoryFilteredList.toSet().toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: popularPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PostEntity post = popularPosts[index];
                    
                    return PostGridViewTile(post: post);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
