import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/enum/radius_type.dart';
import '../../../../providers/marketplace_provider.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final Completer<GoogleMapController> _mapController = Completer();
  late final MarketPlaceProvider _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = context.read<MarketPlaceProvider>();
    _provider.addListener(_onProviderUpdate);
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    super.dispose();
  }

  void _onProviderUpdate() async {
    if (!mounted || !_mapController.isCompleted) return;

    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(_provider.selectedLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Consumer<MarketPlaceProvider>(
        builder: (BuildContext context, MarketPlaceProvider provider, _) {
          return GoogleMap(
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
            circles: provider.radiusType == RadiusType.local
                ? <Circle>{
                    Circle(
                      circleId: const CircleId('radius'),
                      center: provider.selectedLocation,
                      radius: provider.selectedRadius * 10000000000,
                      fillColor: Colors.black.withValues(alpha: 0.1),
                      strokeWidth: 2,
                      strokeColor: Colors.black,
                    ),
                  }
                : <Circle>{},
            onMapCreated: (GoogleMapController controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
          );
        },
      ),
    );
  }
}
