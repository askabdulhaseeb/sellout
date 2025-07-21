import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../providers/marketplace_provider.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_delivery_added_widget.dart';

class ItemFilterWidget extends StatelessWidget {
  const ItemFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        return Column(
          children: <Widget>[
            const MarketFilterSearchField(),
            SubCategorySelectableWidget<MarketPlaceProvider>(
              listenProvider:
                  Provider.of<MarketPlaceProvider>(context, listen: false),
              title: false,
              listType: marketPro.marketplaceCategory,
              subCategory: marketPro.selectedSubCategory,
              onSelected: marketPro.setSelectedCategory,
            ),
            const SizedBox(height: 8),
            const ItemFilterDeliveryAddedWidget(),
            const MarketFilterPriceWIdget(),
          ],
        );
      },
    );
  }
}
