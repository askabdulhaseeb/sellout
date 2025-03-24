import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/price_range_widget.dart';

class ExploreVehiclesScreen extends StatefulWidget {
  const ExploreVehiclesScreen({
    super.key,
  });
  static const String routeName = '/explore-vehicles';

  @override
  State<ExploreVehiclesScreen> createState() => _ExploreVehiclesScreenState();
}

class _ExploreVehiclesScreenState extends State<ExploreVehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ExploreProvider exploreProvider =
        Provider.of<ExploreProvider>(context);
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          leadingWidth: 140,
          leading: TextButton.icon(
            style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant),
            icon:
                Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
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
                    Text('vehicles'.tr(), style: textTheme.titleMedium),
                    Text('${'find_perfect'.tr()} ${'vehicles'.tr()}',
                        style: textTheme.bodySmall),
                    // CustomTextFormField(
                    //   controller: exploreProvider.searchController,
                    //   hint: 'search'.tr(),
                    // ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        // Expanded(
                        //     child: CustomTextFormField(
                        //   hint: 'postcode'.tr(),
                        //   controller: exploreProvider.postodeController,
                        // )),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            hint: Text(
                              'model'.tr(),
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: exploreProvider.selectedmodelvehicle,
                            isExpanded: true,
                            onChanged: (String? newValue) =>
                                exploreProvider.setvehiclemodel(newValue),
                            items: exploreProvider
                                .getVehiclemodel()
                                .map<DropdownMenuItem<String>>(
                                    (String? delivery) => DropdownMenuItem(
                                          value: delivery,
                                          child: Text(delivery!),
                                        ))
                                .toList(),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            hint: Text(
                              'category'.tr(),
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: exploreProvider.selectedVehicleCategory,
                            isExpanded: true,
                            onChanged: (String? newValue) =>
                                exploreProvider.setvehiclecategory(newValue),
                            items: exploreProvider
                                .getVehicleCategory()
                                .map<DropdownMenuItem<String>>(
                                    (String delivery) => DropdownMenuItem(
                                          value: delivery,
                                          child: Text(delivery),
                                        ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            hint: Text(
                              'year'.tr(),
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: exploreProvider.selectedyearvehicle,
                            isExpanded: true,
                            onChanged: (int? newValue) =>
                                exploreProvider.setvehicleyear(newValue),
                            items: exploreProvider
                                .getVehicleyear()
                                .map((int? delivery) {
                              return DropdownMenuItem<int>(
                                value: delivery,
                                child: Text((delivery).toString()),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            hint: Text(
                              'make'.tr(),
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: exploreProvider.selectedmakevehcle,
                            isExpanded: true,
                            onChanged: (String? newValue) =>
                                exploreProvider.setvehiclemake(newValue),
                            items: exploreProvider
                                .getVehiclemake()
                                .map<DropdownMenuItem<String>>(
                                    (String? delivery) => DropdownMenuItem(
                                          value: delivery,
                                          child: Text(delivery!),
                                        ))
                                .toList(),
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
                          exploreProvider.applyvehicleFIlter();
                          debugPrint(
                              'filtered list:${exploreProvider.vehicleCategoryFilteredList}');
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
                  final List<PostEntity> vehiclePosts =
                      provider.vehicleCategoryFilteredList.toSet().toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: vehiclePosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PostEntity post = vehiclePosts[index];

                      return PostGridViewTile(post: post);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
