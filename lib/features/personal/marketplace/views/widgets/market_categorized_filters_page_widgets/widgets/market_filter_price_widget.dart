import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../providers/marketplace_provider.dart';

class MarketFilterPriceWIdget extends StatelessWidget {
  const MarketFilterPriceWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Row(
        spacing: 4,
        children: <Widget>[
          Expanded(
            child: CustomTextFormField(
                keyboardType: TextInputType.number,
                hint: 'min_price'.tr(),
                controller: marketPro.minPriceController),
          ),
          Expanded(
            child: CustomTextFormField(
                keyboardType: TextInputType.number,
                hint: 'max_price'.tr(),
                controller: marketPro.maxPriceController),
          )
        ],
      ),
    );
  }
}
