import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../providers/marketplace_provider.dart';

class FilterSheetDeliveryTypeTile extends StatelessWidget {
  const FilterSheetDeliveryTypeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) {
        return ListTile(
          title: Text(
            'delivery_type'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: DropdownButtonFormField<DeliveryType>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorScheme.of(context).outline,
            ),
            value: pro.selectedDeliveryType,
            isExpanded: true,
            hint: Text(
              'select_delivery_type'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ColorScheme.of(context).outline),
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: DeliveryType.values.map((DeliveryType type) {
              return DropdownMenuItem<DeliveryType>(
                value: type,
                child: Text(
                  type.code.tr(), // make sure `code` exists in your enum
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ColorScheme.of(context).outline),
                ),
              );
            }).toList(),
            onChanged: (DeliveryType? newValue) {
              pro.setSelectedDeliveryType(newValue);
            },
          ),
        );
      },
    );
  }
}
