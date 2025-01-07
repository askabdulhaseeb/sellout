import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extension/int_ext.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../providers/add_service_provider.dart';

class AddServiceTimeAndPriceSection extends StatelessWidget {
  const AddServiceTimeAndPriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
      builder: (BuildContext context, AddServiceProvider pro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<int?>(
                    title: 'hours'.tr(),
                    items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        .map(
                          (int e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text('${e}H'),
                          ),
                        )
                        .toList(),
                    selectedItem: pro.selectedHour,
                    onChanged: (int? value) => pro.setSelectedHour(value),
                    validator: (_) => null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<int?>(
                    title: 'minutes'.tr(),
                    items: <int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
                        .map(
                          (int e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(
                                '${e.putInStart(sign: '0', length: 2)} mints'),
                          ),
                        )
                        .toList(),
                    selectedItem: pro.selectedMinute,
                    onChanged: (int? value) => pro.setSelectedMinute(value),
                    validator: (_) => null,
                  ),
                ),
              ],
            ),
            //
            CustomTextFormField(
              controller: pro.price,
              labelText: 'starting_price'.tr(),
              hint: 'Ex. 100',
              keyboardType: TextInputType.number,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
