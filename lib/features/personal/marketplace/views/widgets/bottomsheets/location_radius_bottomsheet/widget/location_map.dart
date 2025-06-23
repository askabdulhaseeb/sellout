import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/enum/radius_type.dart';
import '../../../../providers/marketplace_provider.dart';

class LocationMap extends StatelessWidget {
  const LocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider provider = context.read<MarketPlaceProvider>();

    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: provider.selectedLocation,
          zoom: 10,
        ),
        markers: <Marker>{
          Marker(
            markerId: const MarkerId('selected-location'),
            position: provider.selectedLocation,
            infoWindow: InfoWindow(title: 'selected_location'.tr()),
          ),
        },
        circles: <Circle>{
          if (provider.radiusType == RadiusType.local)
            Circle(
              circleId: const CircleId('radius'),
              center: provider.selectedLocation,
              radius: provider.selectedRadius,
              fillColor: Colors.black.withValues(alpha: 0.3),
              strokeWidth: 2,
              strokeColor: Colors.black,
            ),
        },
        // onMapCreated: provider.onMapCreated,
        // onTap: provider.onLocationChanged,
      ),
    );
  }
}
