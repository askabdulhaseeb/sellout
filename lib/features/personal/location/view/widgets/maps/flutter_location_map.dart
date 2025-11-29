import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';

class FlutterLocationMap extends StatefulWidget {
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
  final double? circleRadius; // in km
  final RadiusType radiusType;

  @override
  State<FlutterLocationMap> createState() => _FlutterLocationMapState();
}

class _FlutterLocationMapState extends State<FlutterLocationMap> {
  @override
  void didUpdateWidget(covariant FlutterLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update if radius changes
    if (widget.circleRadius != oldWidget.circleRadius &&
        widget.showMapCircle &&
        widget.radiusType == RadiusType.local) {
      _fitCircleBounds(widget.circleRadius ?? 1);
    }
  }

  void _fitCircleBounds(double radiusKm) async {
    // Run heavy calculation off the main thread
    final LatLngBounds bounds = await compute(
      _calculateBounds,
      [
        widget.selectedLatLng.latitude,
        widget.selectedLatLng.longitude,
        radiusKm,
      ],
    );

    if (mounted) {
      widget.mapController.fitCamera(CameraFit.bounds(bounds: bounds));
    }
  }

  static LatLngBounds _calculateBounds(List<dynamic> params) {
    final double lat = params[0];
    final double lon = params[1];
    final double radiusKm = params[2];

    final double radiusMeters = radiusKm * 1000;
    final double latOffset = radiusMeters / 111320;
    final double lonOffset = radiusMeters / (111320 * cos(lat * pi / 180));

    return LatLngBounds(
      LatLng(lat - latOffset, lon - lonOffset),
      LatLng(lat + latOffset, lon + lonOffset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            initialCenter: widget.selectedLatLng,
            initialZoom: 9,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: dotenv.env['MAP_TILE_URL'] ??
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  dotenv.env['APP_PACKAGE_NAME'] ?? 'com.sellout.sellout',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  width: 40,
                  height: 40,
                  point: widget.selectedLatLng,
                  child: widget.showMapCircle == false
                      ? Icon(Icons.location_pin,
                          color: Theme.of(context).primaryColor, size: 40)
                      : const Icon(Icons.circle, color: Colors.blue, size: 25),
                ),
              ],
            ),
            if (widget.showMapCircle && widget.radiusType == RadiusType.local)
              CircleLayer(
                circles: <CircleMarker>[
                  CircleMarker(
                    point: widget.selectedLatLng,
                    radius: ((widget.circleRadius ?? 0) * 1000)
                        .clamp(0, double.infinity),
                    useRadiusInMeter: true,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
                    borderColor: Theme.of(context).colorScheme.onSurface,
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
