import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/location_name_entity.dart';
import '../../../../domain/enum/radius_type.dart';
import '../../../providers/marketplace_provider.dart';
import 'widget/location_header.dart';
import 'widget/location_map.dart';
import 'widget/marketplace_location_field.dart';
import 'widget/radius_option.dart';
import 'widget/radius_slider.dart';
import 'widget/update_location_button.dart';

class LocationRadiusBottomSheet extends StatelessWidget {
  LocationRadiusBottomSheet({super.key});
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider provider = context.watch<MarketPlaceProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: <Widget>[
          const LocationHeader(),
          const SizedBox(height: 8),
          MarketplaceLocationField(
            controller: _locationController,
            initialText: provider.selectedLocationName,
            onLocationSelected: (LocationNameEntity location) async {
              final LatLng coords =
                  await provider.getLocationCoordinates(location.description);
              provider.updateLocation(coords, location.description);
            },
          ),
          const SizedBox(height: 8),
          const LocationMap(),
          const SizedBox(height: 4),
          const RadiusOptions(),
          if (provider.radiusType == RadiusType.local) const RadiusSlider(),
          const UpdateLocationButton(),
        ],
      ),
    );
  }
}
