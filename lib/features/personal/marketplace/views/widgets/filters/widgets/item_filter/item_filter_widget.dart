import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../providers/marketplace_provider.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';

class ItemFilterWidget extends StatelessWidget {
  const ItemFilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        const MarketFilterSearchField(),
        CustomDropdown<String>(
          title: '',
          items: ListingType.values
              .map((ListingType type) => DropdownMenuItem<String>(
                    value: type.json,
                    child: Text(type.code.tr()),
                  ))
              .toList(),
          selectedItem: marketPro.listingItemCategory,
          onChanged: (String? value) {
            marketPro.setItemCategory(value);
          },
          validator: (bool? value) => null,
        ),
        const MarketFilterPriceWIdget(),
      ],
    );
  }
}
