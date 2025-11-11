import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';

class PostCollectionButtons extends StatefulWidget {
  const PostCollectionButtons({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  State<PostCollectionButtons> createState() => _PostCollectionButtonsState();
}

class _PostCollectionButtonsState extends State<PostCollectionButtons> {
  LatLng? _collectionPoint;
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _collectionPoint = LatLng(
      widget.post.collectionLatitude,
      widget.post.collectionLongitude,
    );
  }

  Future<List<LatLng>> _getRoutePoints(LatLng start, LatLng end) async {
    try {
      // Using OSRM (Open Source Routing Machine) - free and reliable
      final String url =
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

      print('Fetching real road route from: $url');
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      print('OSRM API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('OSRM Response: ${data.toString().substring(0, 200)}...');

        if (data['routes'] != null &&
            data['routes'].isNotEmpty &&
            data['routes'][0]['geometry'] != null &&
            data['routes'][0]['geometry']['coordinates'] != null) {
          final List<dynamic> coordinates =
              data['routes'][0]['geometry']['coordinates'];
          print('Real road route points: ${coordinates.length}');

          final List<LatLng> routePoints = coordinates
              .map<LatLng>(
                  (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
              .toList();

          print(
              '✅ SUCCESS: Using real road route with ${routePoints.length} points');
          return routePoints;
        }
      } else {
        print('❌ OSRM API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Route fetching error: $e');
    }

    print('⚠️ Fallback: Using curved line since real road routing failed');
    return _createFallbackRoute(start, end);
  }

  List<LatLng> _createFallbackRoute(LatLng start, LatLng end) {
    final List<LatLng> points = [start];

    // Create intermediate points for a more visible curved effect
    const int steps = 15;

    final double distance = Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);
    final double curveOffset = (distance / 111000) * 0.1;

    for (int i = 1; i < steps; i++) {
      final double ratio = i / steps;
      final double lat =
          start.latitude + (end.latitude - start.latitude) * ratio;
      final double lng =
          start.longitude + (end.longitude - start.longitude) * ratio;
      final double curveAmount = math.sin(ratio * math.pi) * curveOffset;
      final double bearing = Geolocator.bearingBetween(
          start.latitude, start.longitude, end.latitude, end.longitude);
      final double perpBearing = (bearing + 90) * (math.pi / 180);

      final double curvedLat = lat + (curveAmount * math.cos(perpBearing));
      final double curvedLng = lng + (curveAmount * math.sin(perpBearing));

      points.add(LatLng(curvedLat, curvedLng));
    }

    points.add(end);
    print(
        'Using fallback route with ${points.length} points and ${curveOffset} offset');
    return points;
  }

  Future<void> _handleCollectionWorkflow() async {
    setState(() {
      _isLoadingRoute = true;
    });

    // Use LocalAuth.latlng as user location
    final LatLng userLocation = LocalAuth.latlng;

    // Calculate distance between user and collection point
    double distanceInMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      _collectionPoint!.latitude,
      _collectionPoint!.longitude,
    );

    // Fetch the actual road route
    final List<LatLng> routePoints =
        await _getRoutePoints(userLocation, _collectionPoint!);

    setState(() {
      _isLoadingRoute = false;
    });

    // Show collection workflow dialog
    _showCollectionBottomSheet(distanceInMeters, userLocation, routePoints);
  }

  void _showCollectionBottomSheet(
      double distanceInMeters, LatLng userLocation, List<LatLng> routePoints) {
    double distanceInKm = distanceInMeters / 1000;
    String distanceText = distanceInKm < 1
        ? '${distanceInMeters.toInt()} meters'
        : '${distanceInKm.toStringAsFixed(1)} km';

    // Check if we have a real route (more than 2 points) or fallback
    bool isRealRoute = routePoints.length > 2;
    print(
        'Showing route with ${routePoints.length} points. Real route: $isRealRoute');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _CollectionMapBottomSheet(
          userLocation: userLocation,
          collectionPoint: _collectionPoint!,
          distanceText: distanceText,
          post: widget.post,
          onConfirm: _proceedWithCollection,
          routePoints: routePoints,
          isRealRoute: isRealRoute,
        );
      },
    );
  }

  void _proceedWithCollection() {
    // TODO: Implement the actual collection logic
    // This could include:
    // - Adding item to collection queue
    // - Sending notification to store
    // - Creating collection appointment
    // - Navigating to collection confirmation screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('collection_confirmed'.tr()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      title: 'View Location & Collect',
      isLoading: _isLoadingRoute,
      onTap: () => _handleCollectionWorkflow(),
    );
  }
}

class _CollectionMapBottomSheet extends StatefulWidget {
  const _CollectionMapBottomSheet({
    required this.userLocation,
    required this.collectionPoint,
    required this.distanceText,
    required this.post,
    required this.onConfirm,
    required this.routePoints,
    required this.isRealRoute,
  });

  final LatLng userLocation;
  final LatLng collectionPoint;
  final String distanceText;
  final PostEntity post;
  final VoidCallback onConfirm;
  final List<LatLng> routePoints;
  final bool isRealRoute;

  @override
  State<_CollectionMapBottomSheet> createState() =>
      _CollectionMapBottomSheetState();
}

class _CollectionMapBottomSheetState extends State<_CollectionMapBottomSheet> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMapToBounds();
    });
  }

  void _fitMapToBounds() {
    // Create bounds that include all route points
    final List<LatLng> allPoints = [
      widget.userLocation,
      widget.collectionPoint,
      ...widget.routePoints,
    ];

    final LatLngBounds bounds = LatLngBounds.fromPoints(allPoints);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(60), // Increased padding for better view
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with close button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Collection Location',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.route_outlined,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.distanceText} away',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.collectionPoint,
                    initialZoom: 13,
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.sellout.sellout',
                    ),

                    // Road route polyline - actual road path or curved fallback
                    PolylineLayer(
                      polylines: <Polyline<Object>>[
                        if (widget.isRealRoute)
                          // Real route - solid line
                          Polyline(
                            points: widget.routePoints,
                            color: const Color(0xFF2DD4BF),
                            strokeWidth: 6,
                            borderColor: Colors.white,
                            borderStrokeWidth: 2,
                          )
                        else
                          // Fallback route - dashed line
                          Polyline(
                            points: widget.routePoints,
                            color: const Color(0xFF94A3B8),
                            strokeWidth: 4,
                            borderColor: Colors.white,
                            borderStrokeWidth: 2,
                            pattern:
                                StrokePattern.dashed(segments: <double>[8, 4]),
                          ),
                      ],
                    ),

                    // Markers
                    MarkerLayer(
                      markers: <Marker>[
                        // Collection point marker (Store)
                        Marker(
                          point: widget.collectionPoint,
                          width: 60,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xFF2DD4BF),
                                  Color(0xFF14B8A6)
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.store_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // User location marker
                        Marker(
                          point: widget.userLocation,
                          width: 50,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xFF3B82F6),
                                  Color(0xFF1D4ED8)
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom info section
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DD4BF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ready for Collection',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isRealRoute
                            ? 'Showing actual driving route to the store location'
                            : 'Showing approximate path - actual route may vary',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
