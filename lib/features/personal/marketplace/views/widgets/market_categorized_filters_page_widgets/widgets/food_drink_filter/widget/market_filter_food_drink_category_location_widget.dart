import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
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
          Expanded(
            child: NominationLocationField(
              selectedLatLng: marketPro.selectedlatlng,
              displayMode: MapDisplayMode.neverShowMap,
              initialText: marketPro.selectedLocation?.address ?? '',
              onLocationSelected: (LocationEntity p0, LatLng p1) {
                marketPro.updateLocation(p1, p0);
              },
            ),
          )
        ],
      ),
    );
  }
}
