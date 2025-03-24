
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/explore_provider.dart';
import '../price_range_widget.dart';
class RentPropertyTabbar extends StatelessWidget {
  const RentPropertyTabbar({
    required this.exploreProvider, required this.textTheme, required this.colorScheme, super.key,
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
