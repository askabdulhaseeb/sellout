import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';

class FlutterLocationMap extends StatelessWidget {
  const FlutterLocationMap({
    required this.mapController,
    required this.selectedLatLng,
    this.showMapCircle = false,
    this.circleRadius,
    this.radiusType = RadiusType.worldwide,
    super.key,
  });

  final MapController mapController;
  final LatLng selectedLatLng;
  final bool showMapCircle;
  final double? circleRadius;
  final RadiusType radiusType;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: selectedLatLng,
            initialZoom: 9,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.sellout.sellout',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  width: 40,
                  height: 40,
                  point: selectedLatLng,
                  child: showMapCircle == false
                      ? const Icon(Icons.location_pin,
                          color: AppTheme.primaryColor, size: 40)
                      : const Icon(Icons.circle, color: Colors.blue, size: 25),
                ),
              ],
            ),
            if (showMapCircle == true && radiusType == RadiusType.local)
              CircleLayer(
                circles: <CircleMarker<Object>>[
                  CircleMarker(
                    point: selectedLatLng,
                    radius:
                        ((circleRadius ?? 0) * 1000).clamp(0, double.infinity),
                    useRadiusInMeter: true,
                    color: AppTheme.darkScaffldColor.withOpacity(0.3),
                    borderColor: AppTheme.darkScaffldColor,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
