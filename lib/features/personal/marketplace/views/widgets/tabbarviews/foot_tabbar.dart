import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../providers/marketplace_provider.dart';

class FootwearTabbarWidget extends StatelessWidget {
  const FootwearTabbarWidget({
    required this.pro,
    required this.textTheme,
    required this.colorScheme,
    super.key,
  });

  final MarketPlaceProvider pro;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 4),
        CustomTextFormField(
          controller: pro.searchController,
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
                value: pro.selectedCondition,
                isExpanded: true,
                onChanged: (ConditionType? newValue) {
                  pro.updateCondition(newValue);
                },
                items: ConditionType.list.map((ConditionType condition) {
                  return DropdownMenuItem<ConditionType>(
                    value: condition,
                    child: Text(condition
                        .name), // Assuming ConditionType has a `name` property
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
                value: pro.selectedfootBrand,
                isExpanded: true,
                onChanged: (String? newValue) {
                  pro.setfootBrand(newValue);
                },
                items: pro.getfootBrands().map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand.tr()),
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
                  'sizes'.tr(),
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                value: pro.selectedfootSize, // Selected size
                isExpanded: true,
                onChanged: (String? newValue) {
                  pro.setfootsize(newValue); // Update selected size
                  pro.setAvailableFootColors(newValue);
                },
                items: pro.getFootSize().map((SizeColorEntity size) {
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
                  'Select Color',
                  style: textTheme.bodySmall,
                ),
                value: pro.selectedFootColor,
                isExpanded: true,
                onChanged: (String? newValue) {
                  pro.setFootColor(newValue);
                },
                items: pro.availablefootColors.map((ColorEntity colorEntity) {
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
              pro.applyFootFilters();
              debugPrint('filtered list:${pro.footCategoryFilteredList}');
            },
            title: 'search'.tr()),
        const SizedBox(width: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => pro.resetFilters(),
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
