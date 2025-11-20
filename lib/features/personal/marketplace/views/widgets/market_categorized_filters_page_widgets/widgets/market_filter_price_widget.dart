import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../providers/marketplace_provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';

class MarketFilterPriceWIdget extends StatelessWidget {
  const MarketFilterPriceWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          spacing: 4,
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                keyboardType: TextInputType.number,
                hint: 'min_price'.tr(),
                controller: marketPro.minPriceController,
                validator: (String? value) {
                  // Optionally add min price validation here
                  return null;
                },
              ),
            ),
            Expanded(
              child: CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                hint: 'max_price'.tr(),
                controller: marketPro.maxPriceController,
                validator: (String? value) {
                  return AppValidator.greaterThen(
                    value,
                    double.tryParse(marketPro.minPriceController.text) ?? 0,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
