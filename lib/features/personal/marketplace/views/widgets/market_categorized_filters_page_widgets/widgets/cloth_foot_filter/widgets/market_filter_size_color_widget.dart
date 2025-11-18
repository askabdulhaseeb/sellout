import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_multi_selection_dropdown.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../providers/marketplace_provider.dart';
import 'multi_selection_color_dropdown.dart';

class MarketFilterSizeColorWidget extends StatelessWidget {
  const MarketFilterSizeColorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder:
        (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
      final List<DropdownOptionEntity> clothesSizes =
          LocalCategoriesSource.clothesSizes ?? <DropdownOptionEntity>[];
      final List<DropdownOptionEntity> footSizes =
          LocalCategoriesSource.footSizes ?? <DropdownOptionEntity>[];
      final List<DropdownOptionEntity> sizeOptions =
          marketPro.cLothFootCategory == 'clothes' ? clothesSizes : footSizes;
      return Row(
        spacing: 4,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Expanded(
              flex: 2,
              child: MultiSelectionDropdown<DropdownOptionEntity>(
                title: 'sizes',
                hint: 'sizes'.tr(),
                items: sizeOptions
                    .map(
                      (DropdownOptionEntity e) =>
                          DropdownMenuItem<DropdownOptionEntity>(
                        value: e,
                        child: Text(e.label),
                      ),
                    )
                    .toList(),
                selectedItems: sizeOptions
                    .where((DropdownOptionEntity opt) =>
                        marketPro.selectedSize.contains(opt.value.value))
                    .toList(),
                onChanged: (List<DropdownOptionEntity> newSelection) {
                  // Convert entities to string values
                  final List<String> selectedValues = newSelection
                      .map((DropdownOptionEntity e) => e.value.value)
                      .toList();
                  marketPro.setSize(selectedValues);
                },
              ),
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
      );
    });
  }
}
