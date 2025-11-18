import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/extension/int_ext.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
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
                    items: <DropdownMenuItem<int?>>[
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text(''),
                      ),
                      ...<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map(
                        (int e) => DropdownMenuItem<int?>(
                          value: e,
                          child: Text(
                            '${e}H',
                            style: TextTheme.of(context).bodyLarge,
                          ),
                        ),
                      ),
                    ],
                    selectedItem: pro.selectedHour,
                    onChanged: (int? value) => pro.setSelectedHour(value),
                    validator: (bool? isValid) =>
                        (pro.selectedHour == null) ? 'select_type'.tr() : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<int?>(
                    title: 'minutes'.tr(),
                    items: <DropdownMenuItem<int?>>[
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text(''),
                      ),
                      ...<int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
                          .map(
                        (int e) => DropdownMenuItem<int?>(
                          value: e,
                          child: Text(
                            '${e.putInStart(sign: '0', length: 2)} mints',
                            style: TextTheme.of(context).bodyLarge,
                          ),
                        ),
                      ),
                    ],
                    selectedItem: pro.selectedMinute,
                    onChanged: (int? value) => pro.setSelectedMinute(value),
                    validator: (bool? isValid) => (pro.selectedMinute == null)
                        ? 'select_type'.tr()
                        : null,
                  ),
                ),
              ],
            ),
            //
            CustomTextFormField(
              controller: pro.price,
              labelText: 'starting_price'.tr(),
              hint: 'Ex. 100',
              prefixText: LocalAuth.currency.toUpperCase(),
              keyboardType: TextInputType.number,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
