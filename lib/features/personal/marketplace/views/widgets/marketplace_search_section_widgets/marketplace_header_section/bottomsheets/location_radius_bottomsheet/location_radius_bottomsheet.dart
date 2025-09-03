import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../domain/enum/radius_type.dart';
import '../../../../../providers/marketplace_provider.dart';
import '../../../../../../../../../core/widgets/leaflet_map_field.dart';
import 'widget/location_header.dart';
import 'widget/radius_option.dart';
import 'widget/radius_slider.dart';

class LocationRadiusBottomSheet extends StatelessWidget {
  const LocationRadiusBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider provider =
        Provider.of<MarketPlaceProvider>(context);
    // LatLng? selectedlatlng;
    // LocationEntity? selectedLocation;
    // void updateLocation(LatLng latlng, LocationEntity location) {
    //   selectedlatlng = latlng;
    //   selectedLocation = location;
    // }

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const LocationHeader(),
              const SizedBox(height: 8),
              LocationDropdown(
                  radiusType: provider.radiusType,
                  selectedLatLng: provider.selectedlatlng,
                  circleRadius: provider.selectedRadius,
                  displayMode: MapDisplayMode.alwaysShowMap,
                  showMapCircle: true,
                  initialText: provider.selectedLocation?.title,
                  onLocationSelected: (LocationEntity p0, LatLng p1) =>
                      provider.updateLocation(p1, p0)),
              const SizedBox(height: 24),
              const RadiusOptions(),
              if (provider.radiusType == RadiusType.local) ...<Widget>[
                const SizedBox(height: 8),
                const RadiusSlider(),
              ],
              const SizedBox(height: 24),
              // UpdateLocationButton(
              //     latlng: selectedlatlng, selectedLocation: selectedLocation),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
