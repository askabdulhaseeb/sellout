import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterFoodDrinkCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterFoodDrinkCategoryAndLocationWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          Row(
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
            ),
          ),
          // Expanded(
          //   child: LocationField(
          //     initialText: marketPro.selectedLocationName,
          //     onLocationSelected: (LocationNameEntity location) async {
          //       final LatLng coords = await marketPro
          //           .getLocationCoordinates(location.description);
          //       marketPro.updateLocation(coords, location.description);
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
