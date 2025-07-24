import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class DeliveryFilterDropdown extends StatelessWidget {
  const DeliveryFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        return CustomDropdown<DeliveryType>(
          title: '',
          hint: 'delivery',
          items: DeliveryType.values
              .map(
                (DeliveryType item) => DropdownMenuItem<DeliveryType>(
                  value: item,
                  child: Text(
                    item.json,
                    style: TextTheme.of(context).bodyMedium,
                  ),
                ),
              )
              .toList(),
          selectedItem: marketPro.selectedDeliveryType,
          onChanged: marketPro.setDeliveryType,
          validator: (_) => null,
        );
      },
    );
  }
}
