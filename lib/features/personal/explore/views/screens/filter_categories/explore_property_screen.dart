import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/price_range_widget.dart';

class ExplorePropertyScreen extends StatefulWidget {
  const ExplorePropertyScreen({
    super.key,
  });
  static const String routeName = '/explore-property';

  @override
  State<ExplorePropertyScreen> createState() => _ExplorePropertyScreenState();
}

class _ExplorePropertyScreenState extends State<ExplorePropertyScreen> {
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
                  Text('property'.tr(), style: textTheme.titleMedium),
                  Text(
                      '${'find_perfect'.tr()} ${'property'.tr()}${' items'.tr()}',
                      style: textTheme.bodySmall),
                  const SizedBox(height: 10),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: colorScheme.outlineVariant)),
                          padding: const EdgeInsets.all(2),
                          child: TabBar(
                            padding: const EdgeInsets.all(0),
                            labelPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: colorScheme.primary)),
                            tabs: <Widget>[
                              Tab(text: 'Sale'.tr()),
                              Tab(text: 'rent'.tr()),
                            ],
                            onTap: (int index) {
                              exploreProvider.updatepropertySelectedTab(index);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 275,
                          child: TabBarView(children: <Widget>[
                            SalePropertyWidget(
                                exploreProvider: exploreProvider,
                                textTheme: textTheme,
                                colorScheme: colorScheme),
                            RentPropertyTabbar(
                                exploreProvider: exploreProvider,
                                textTheme: textTheme,
                                colorScheme: colorScheme),
                          ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<ExploreProvider>(
              builder: (BuildContext context, ExploreProvider provider,
                  Widget? child) {
                final List<PostEntity> salePosts =
                    provider.saleCategoryFilteredList.toSet().toList();
                final List<PostEntity> rentPosts =
                    provider.rentCategoryFilteredList.toSet().toList();

                return provider.selectedpropertyTab == 0
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: salePosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PostEntity post = salePosts[index];
                          return PostGridViewTile(post: post);
                        },
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: rentPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PostEntity post = rentPosts[index];
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

class SalePropertyWidget extends StatelessWidget {
  const SalePropertyWidget({
    required this.exploreProvider,
    required this.textTheme,
    required this.colorScheme,
    super.key,
  });

  final ExploreProvider exploreProvider;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<String?>(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                hint: Text(
                  'property_type'.tr(),
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                value: exploreProvider.selectedsalePropertytype,
                isExpanded: true,
                onChanged: (String? newValue) =>
                    exploreProvider.setsalepropertytype(newValue),
                items:
                    exploreProvider.getsalepropertyTypes().map((String type) {
                  return DropdownMenuItem<String?>(
                    value: type,
                    child: Text(type),
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
                items: exploreProvider.dateFilterOptions.map((String option) {
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
              exploreProvider.applysalePropertyFIlter();
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
        ),
      ],
    );
  }
}

class RentPropertyTabbar extends StatelessWidget {
  const RentPropertyTabbar({
    super.key,
    required this.exploreProvider,
    required this.textTheme,
    required this.colorScheme,
  });

  final ExploreProvider exploreProvider;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<String?>(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                hint: Text(
                  'property_type'.tr(),
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                value: exploreProvider.selectedsalePropertytype,
                isExpanded: true,
                onChanged: (String? newValue) =>
                    exploreProvider.setrentpropertytype(newValue),
                items:
                    exploreProvider.getrentpropertyTypes().map((String type) {
                  return DropdownMenuItem<String?>(
                    value: type,
                    child: Text(type),
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
                items: exploreProvider.dateFilterOptions.map((String option) {
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
              exploreProvider.applyrentPropertyFIlter();
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
        ),
      ],
    );
  }
}
