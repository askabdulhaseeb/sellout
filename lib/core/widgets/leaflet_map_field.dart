import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../features/personal/marketplace/domain/enum/radius_type.dart';
import '../theme/app_theme.dart';
import 'custom_textformfield.dart';
import '../../features/personal/location/domain/entities/location_entity.dart';

enum MapDisplayMode {
  alwaysShowMap,
  showMapAfterSelection,
  neverShowMap,
}

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({
    required this.onLocationSelected,
    required this.selectedLatLng,
    super.key,
    this.initialText,
    this.icon,
    this.displayMode = MapDisplayMode.showMapAfterSelection,
    this.showMapCircle,
    this.circleRadius,
    this.radiusType = RadiusType.worldwide,
  });

  final void Function(LocationEntity, LatLng) onLocationSelected;
  final String? initialText;
  final Widget? icon;
  final MapDisplayMode displayMode;
  final bool? showMapCircle;
  final double? circleRadius;
  final LatLng? selectedLatLng;
  final RadiusType radiusType;

  @override
  State<LocationDropdown> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationDropdown> {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();
  late LatLng _selectedLatLng;

  @override
  void initState() {
    super.initState();

    // ✅ Always fallback to a safe coordinate (London, UK)
    _selectedLatLng = widget.selectedLatLng ?? LocalAuth.latlng;

    if (widget.initialText?.isNotEmpty == true) {
      _controller.text = widget.initialText!;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSuggestions(String pattern) async {
    if (pattern.trim().isEmpty) return <Map<String, dynamic>>[];

    try {
      final String url =
          'https://nominatim.openstreetmap.org/search?q=$pattern&format=json&addressdetails=1&limit=5';

      final http.Response response =
          await http.get(Uri.parse(url), headers: <String, String>{
        'User-Agent': 'FlutterApp',
      });

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Suggestion fetch error: $e');
    }

    return <Map<String, dynamic>>[];
  }

  void _handleSuggestionSelected(Map<String, dynamic> suggestion) {
    final double? lat = double.tryParse(suggestion['lat']?.toString() ?? '');
    final double? lon = double.tryParse(suggestion['lon']?.toString() ?? '');
    final String displayName = suggestion['display_name']?.toString() ?? '';

    if (displayName.isNotEmpty) {
      _controller.text = displayName;
    }

    if (lat != null && lon != null) {
      final LatLng latLng = LatLng(lat, lon);
      final LocationEntity location = LocationEntity(
        id: suggestion['place_id']?.toString() ?? '',
        title: displayName.split(',').first,
        address: displayName,
        url: 'https://maps.google.com/?q=$lat,$lon',
        latitude: lat,
        longitude: lon,
      );

      setState(() {
        _selectedLatLng = latLng;
      });

      // ✅ Safe map move
      Future.microtask(() {
        try {
          _mapController.move(latLng, 15);
        } catch (e) {
          debugPrint('Map move error: $e');
        }
      });

      widget.onLocationSelected(location, latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TypeAheadField<Map<String, dynamic>>(
          controller: _controller,
          suggestionsCallback: _fetchSuggestions,
          itemBuilder:
              (BuildContext context, Map<String, dynamic> suggestion) =>
                  ListTile(
            title: Text(
              suggestion['display_name']?.toString() ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          onSelected: _handleSuggestionSelected,
          builder: (BuildContext context, TextEditingController controller,
                  FocusNode focusNode) =>
              CustomTextFormField(
            controller: controller,
            focusNode: focusNode,
            prefixIcon:
                widget.icon ?? const Icon(Icons.search, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          emptyBuilder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('no_location_found'.tr(), textAlign: TextAlign.center),
          ),
          loadingBuilder: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          ),
          errorBuilder: (_, Object error) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Icon(Icons.error_outline, color: Colors.red),
                Text('${'something_wrong'.tr()}: $error'),
              ],
            ),
          ),
          listBuilder: (BuildContext context, List<Widget> items) =>
              ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, int index) => items[index],
          ),
          itemSeparatorBuilder: (_, __) =>
              const Divider(height: 1, thickness: 1),
          decorationBuilder: (_, Widget child) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
          animationDuration: const Duration(milliseconds: 500),
        ),
        if (_shouldShowMap()) const SizedBox(height: 16),
        if (_shouldShowMap())
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLatLng,
                  initialZoom: 9,
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.sellout.sellout',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        width: 40,
                        height: 40,
                        point: _selectedLatLng,
                        child: widget.showMapCircle == false
                            ? const Icon(Icons.location_pin,
                                color: AppTheme.primaryColor, size: 40)
                            : const Icon(Icons.circle,
                                color: Colors.blue, size: 25),
                      ),
                    ],
                  ),
                  if (widget.showMapCircle == true &&
                      widget.radiusType == RadiusType.local)
                    CircleLayer(
                      circles: <CircleMarker<Object>>[
                        CircleMarker(
                          point: _selectedLatLng,
                          radius: ((widget.circleRadius ?? 0) * 1000)
                              .clamp(0, double.infinity),
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
          ),
      ],
    );
  }

  bool _shouldShowMap() {
    return widget.displayMode == MapDisplayMode.alwaysShowMap ||
        (widget.displayMode == MapDisplayMode.showMapAfterSelection &&
            _controller.text.isNotEmpty);
  }
}
