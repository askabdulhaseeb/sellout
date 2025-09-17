import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterClothFootCategoryAndBrandWidget extends StatefulWidget {
  const MarketFilterClothFootCategoryAndBrandWidget({super.key});

  @override
  State<MarketFilterClothFootCategoryAndBrandWidget> createState() =>
      _MarketFilterClothFootCategoryAndBrandWidgetState();
}

class _MarketFilterClothFootCategoryAndBrandWidgetState
    extends State<MarketFilterClothFootCategoryAndBrandWidget> {
  @override
  Widget build(BuildContext context) {
    // ✅ Provide explicit lists for clothes & footwear brands
    final List<DropdownOptionDataEntity> clothesBrands =
        LocalCategoriesSource.clothesBrands ?? <DropdownOptionDataEntity>[];
    final List<DropdownOptionDataEntity> footwearBrands =
        LocalCategoriesSource.footwearBrands ?? <DropdownOptionDataEntity>[];

    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        // decide which list to show
        final List<DropdownOptionDataEntity> brandOptions =
            marketPro.cLothFootCategory == 'clothes'
                ? clothesBrands
                : footwearBrands;

        return Row(
          children: <Widget>[
            /// Left: SubCategorySelectableWidget
            Expanded(
              child: SubCategorySelectableWidget<MarketPlaceProvider>(
                listenProvider:
                    Provider.of<MarketPlaceProvider>(context, listen: false),
                title: false,
                listType: marketPro.marketplaceCategory,
                subCategory: marketPro.selectedSubCategory,
                onSelected: marketPro.setSelectedCategory,
                cid: marketPro.cLothFootCategory ?? '',
              ),
            ),

            const SizedBox(width: 4),

            /// Right: Brands dropdown
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider,
                  DropdownOptionDataEntity>(
                options: brandOptions,
                valueGetter: (DropdownOptionDataEntity opt) => opt.value,
                labelGetter: (DropdownOptionDataEntity opt) => opt.label,
                validator: (bool? p0) => null,
                hint: 'brand'.tr(),
                selectedValue: marketPro.brand,
                onChanged: (String? p0) => marketPro.setBrand(p0),
              ),
            ),
          ],
        );
      },
    );
  }
}
