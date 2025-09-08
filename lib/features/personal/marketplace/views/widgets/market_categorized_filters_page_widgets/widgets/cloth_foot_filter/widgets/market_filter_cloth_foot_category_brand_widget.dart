import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<String> dropdownItems = <String>[];
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          spacing: 4,
          children: <Widget>[
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
            Expanded(
              child: CustomListingDropDown<MarketPlaceProvider>(
                validator: (bool? p0) => null,
                hint: 'brand'.tr(),
                categoryKey: marketPro.cLothFootCategory == 'clothes'
                    ? 'clothes_brands'
                    : 'footwear_brands',
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
