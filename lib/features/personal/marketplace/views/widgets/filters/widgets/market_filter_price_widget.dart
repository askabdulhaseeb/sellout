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
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Row(
      spacing: 4,
      children: <Widget>[
        Expanded(
          child: CustomTextFormField(
              hint: 'min_price'.tr(), controller: marketPro.minPriceController),
        ),
        Expanded(
          child: CustomTextFormField(
              hint: 'max_price'.tr(), controller: marketPro.maxPriceController),
        )
      ],
    );
  }
}
