import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterSheetCustomerReviewTile extends StatefulWidget {
  const FilterSheetCustomerReviewTile({super.key});

  @override
  State<FilterSheetCustomerReviewTile> createState() =>
      _FilterSheetCustomerReviewTileState();
}

class _FilterSheetCustomerReviewTileState
    extends State<FilterSheetCustomerReviewTile> {
  String? selectedValue;

  final List<String> options = <String>[
    'all_stars',
    '5_stars',
    '4_stars',
    '3_stars',
    '2_stars',
    '1_star',
  ];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'customer_review'.tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        hint: Text(
          'select_customer_review'.tr(),
          style: TextTheme.of(context)
              .bodyMedium
              ?.copyWith(color: ColorScheme.of(context).outline),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: ColorScheme.of(context).outline,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: options.map((String key) {
          return DropdownMenuItem<String>(
            value: key,
            child: Text(
              key.tr(),
              style: TextTheme.of(context)
                  .bodyMedium
                  ?.copyWith(color: ColorScheme.of(context).outline),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
      ),
    );
  }
}
