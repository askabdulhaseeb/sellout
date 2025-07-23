import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../providers/marketplace_provider.dart';

class FilterSheetConditionTile extends StatelessWidget {
  const FilterSheetConditionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) {
        return ListTile(
          title: Text(
            'condition'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: DropdownButtonFormField<ConditionType>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorScheme.of(context).outline,
            ),
            value: pro.selectedConditionType,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            hint: Text(
              'select_condition'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ColorScheme.of(context).outline),
            ),
            items: ConditionType.values.map((ConditionType type) {
              return DropdownMenuItem<ConditionType>(
                value: type,
                child: Text(
                  type.code.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ColorScheme.of(context).outline),
                ),
              );
            }).toList(),
            onChanged: (ConditionType? newValue) {
              pro.setSelectedConditionType(newValue);
            },
          ),
        );
      },
    );
  }
}
