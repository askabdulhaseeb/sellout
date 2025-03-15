import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../providers/explore_provider.dart';

class ClothTabbarWidget extends StatelessWidget {
  const ClothTabbarWidget({
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
        const SizedBox(height: 4),
        CustomTextFormField(
          controller: exploreProvider.searchController,
          hint: 'search'.tr(),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<ConditionType>(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: Text(
                  'category'.tr(),
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                value: exploreProvider.selectedCondition,
                isExpanded: true,
                onChanged: (ConditionType? newValue) {
                  exploreProvider.updateCondition(newValue);
                },
                items: ConditionType.list.map((ConditionType condition) {
                  return DropdownMenuItem<ConditionType>(
                    value: condition,
                    child: Text(condition.name),
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
                      borderRadius: BorderRadius.circular(10)),
                ),
                hint: Text(
                  'brand'.tr(),
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                value: exploreProvider.selectedclothBrand,
                isExpanded: true,
                onChanged: (String? newValue) {
                  exploreProvider.setclothBrand(newValue);
                },
                items: exploreProvider.getclothBrands().map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
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
              child: DropdownButtonFormField<String>(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                hint: Text(
                  'size'.tr(),
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                value: exploreProvider.selectedclothSize, // Selected size
                isExpanded: true,
                onChanged: (String? newValue) {
                  exploreProvider
                      .setclothsize(newValue); // Update selected size
                  exploreProvider.setAvailableclothColors(newValue);
                },
                items:
                    exploreProvider.getclothSize().map((SizeColorEntity size) {
                  return DropdownMenuItem<String>(
                    value: size.value,
                    child: Text(size.value),
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
                      borderRadius: BorderRadius.circular(10)),
                ),
                hint: Text(
                  'color'.tr(),
                  style: textTheme.bodySmall,
                ),
                value: exploreProvider.selectedclothColor,
                isExpanded: true,
                onChanged: (String? newValue) {
                  exploreProvider.setclothColor(newValue);
                },
                items: exploreProvider.availableclothColors
                    .map((ColorEntity colorEntity) {
                  return DropdownMenuItem<String>(
                    value: colorEntity.code,
                    child: Text(colorEntity.code), // Display color code
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomElevatedButton(
            isLoading: false,
            onTap: () {
              exploreProvider.applyClothFilters();
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
    );
  }
}
