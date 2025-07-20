import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/marketplace_provider.dart';
import 'multi_selection_color_dropdown.dart';
import 'multiple_selection_listing_dropdown.dart';

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
            child: CustomListingMultiDropdown<MarketPlaceProvider>(
              hint: 'size',
              categoryKey: marketPro.cLothFootCategory == 'clothes'
                  ? 'clothes_sizes'
                  : 'foot_sizes',
              selectedValues: marketPro.selectedSize,
              onChanged: (List<String> p0) => marketPro.setSize(p0),
            ),
          ),
          Expanded(
            flex: 2,
            child: MultiColorDropdown(
              selectedColors: marketPro.selectedColor,
              onColorsChanged: (List<String> value) =>
                  marketPro.setColor(value),
            ),
          ),
        ],
      ),
    );
  }
}
