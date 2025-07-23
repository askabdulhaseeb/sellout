import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/location_field.dart';
import '../../../../../../domain/entities/location_name_entity.dart';
import '../../../../../../domain/enum/radius_type.dart';
import '../../../../../providers/marketplace_provider.dart';
import 'widget/location_header.dart';
import 'widget/location_map.dart';
import 'widget/radius_option.dart';
import 'widget/radius_slider.dart';
import 'widget/update_location_button.dart';

class LocationRadiusBottomSheet extends StatelessWidget {
  const LocationRadiusBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider provider = context.watch<MarketPlaceProvider>();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: <Widget>[
            const LocationHeader(),
            const SizedBox(height: 8),
            LocationField(
              initialText: provider.selectedLocationName,
              onLocationSelected: (LocationNameEntity location) async {
                final LatLng coords =
                    await provider.getLocationCoordinates(location.description);
                provider.updateLocation(coords, location.description);
              },
            ),
            const SizedBox(height: 8),
            const LocationMap(),
            const Spacer(),
            const RadiusOptions(),
            if (provider.radiusType == RadiusType.local) const RadiusSlider(),
            const UpdateLocationButton(),
          ],
        ),
      ),
    );
  }
}
