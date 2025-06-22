import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/dialogs/cart/dropdowns/color_dropdown.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterSizeColorWidget extends StatelessWidget {
  const MarketFilterSizeColorWidget({
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
            flex: 2,
            child: CustomListingDropDown(
              hint: 'size',
              categoryKey: marketPro.cLothFootCategory == 'clothes'
                  ? 'clothes_sizes'
                  : 'foot_sizes',
              selectedValue: marketPro.selectedSize,
              onChanged: (String? p0) => marketPro.setSize(p0),
            ),
          ),
          Expanded(
            flex: 2,
            child: ColorDropdown(
              selectedColor: marketPro.selectedColor,
              onColorChanged: (String? value) => marketPro.setColor(value),
            ),
          ),
        ],
      ),
    );
  }
}
