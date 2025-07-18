import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/location_field.dart';
import '../../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../../../domain/entities/location_name_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterClothFootCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterClothFootCategoryAndLocationWIdget({
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
            child: LocationField(
              initialText: marketPro.selectedLocationName,
              onLocationSelected: (LocationNameEntity location) async {
                final LatLng coords = await marketPro
                    .getLocationCoordinates(location.description);
                marketPro.updateLocation(coords, location.description);
              },
            ),
          )
        ],
      ),
    );
  }
}
