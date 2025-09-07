import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterLocationWidget extends StatelessWidget {
  const MarketFilterLocationWidget({
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
            child: NominationLocationFieldWrapper(
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
