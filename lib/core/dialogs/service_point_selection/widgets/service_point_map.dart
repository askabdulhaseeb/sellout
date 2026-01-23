import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';

class ServicePointMap extends StatelessWidget {
  const ServicePointMap({
    required this.mapController,
    required this.servicePoints,
    required this.selectedPoint,
    required this.onPointTapped,
    super.key,
  });

  final MapController mapController;
  final List<ServicePointModel> servicePoints;
  final ServicePointModel? selectedPoint;
  final Function(ServicePointModel) onPointTapped;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (servicePoints.isEmpty) {
      return Center(child: Text('no_locations_available'.tr()));
    }

    final ServicePointModel centerPoint = selectedPoint ?? servicePoints.first;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(centerPoint.latitude, centerPoint.longitude),
        initialZoom: 15,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sellout.sellout',
        ),
        MarkerLayer(
          markers: servicePoints
              .map(
                (ServicePointModel sp) => Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(sp.latitude, sp.longitude),
                  child: GestureDetector(
                    onTap: () => onPointTapped(sp),
                    child: Icon(
                      Icons.location_pin,
                      color: sp.id == selectedPoint?.id
                          ? colorScheme.primary
                          : colorScheme.secondary,
                      size: sp.id == selectedPoint?.id ? 40 : 32,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
