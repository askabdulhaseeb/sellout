import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/leaflet_map_field.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterpropertyCategoryAndLocationWIdget extends StatelessWidget {
  const MarketFilterpropertyCategoryAndLocationWIdget({
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
                    child: CustomListingDropDown<MarketPlaceProvider>(
                        validator: (bool? p0) => null,
                        hint: 'energy_rating',
                        categoryKey: 'energy_rating',
                        selectedValue: marketPro.energyRating,
                        onChanged: (String? p0) =>
                            marketPro.setEnergyRating(p0))),
                Expanded(
                  child: LocationDropdown(
                    selectedLatLng:
                        marketPro.selectedlatlng ?? const LatLng(0, 0),
                    displayMode: MapDisplayMode.neverShowMap,
                    initialText: marketPro.selectedLocation?.title ?? '',
                    onLocationSelected: (LocationEntity p0, LatLng p1) {
                      marketPro.updateLocation(p1, p0);
                    },
                  ),
                )
              ],
            ));
  }
}
