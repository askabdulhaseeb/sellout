import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../location/domain/entities/location_entity.dart';

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
  });
  final void Function(LocationEntity, LatLng) onLocationSelected;
  final String? initialText;
  final Widget? icon;
  final MapDisplayMode displayMode;
  final bool? showMapCircle;
  final double? circleRadius;
  final LatLng selectedLatLng;

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
    _selectedLatLng = widget.selectedLatLng;
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSuggestions(String pattern) async {
    if (pattern.isEmpty) return <Map<String, dynamic>>[];
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
    return <Map<String, dynamic>>[];
  }

  void _handleSuggestionSelected(Map<String, dynamic> suggestion) {
    final double? lat = double.tryParse(suggestion['lat']);
    final double? lon = double.tryParse(suggestion['lon']);
    final displayName = suggestion['display_name'] ?? '';

    _controller.text = displayName;

    if (lat != null && lon != null) {
      final LatLng latLng = LatLng(lat, lon);
      final LocationEntity location = LocationEntity(
        id: suggestion['place_id']?.toString() ?? '',
        title: displayName.toString().split(',').first,
        address: displayName,
        url: 'www.test.com',
        latitude: lat,
        longitude: lon,
      );

      setState(() {
        _selectedLatLng = latLng;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(latLng, 15);
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
          itemBuilder: (BuildContext context, Map<String, dynamic> suggestion) {
            return ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: Text(
                suggestion['display_name'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
          onSelected: _handleSuggestionSelected,
          builder: (BuildContext context, TextEditingController controller,
              FocusNode focusNode) {
            return CustomTextFormField(
              controller: controller,
              focusNode: focusNode,
              prefixIcon:
                  widget.icon ?? const Icon(Icons.search, color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            );
          },
          emptyBuilder: (BuildContext context) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No locations found', textAlign: TextAlign.center),
          ),
          loadingBuilder: (BuildContext context) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          ),
          errorBuilder: (BuildContext context, Object error) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  const Icon(Icons.error_outline, color: Colors.red),
                  Text('Failed to load: $error'),
                ],
              ),
            );
          },
          listBuilder: (BuildContext context, List<Widget> items) {
            return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) => items[index],
            );
          },
          itemSeparatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1, thickness: 1);
          },
          decorationBuilder: (BuildContext context, Widget child) {
            return Container(
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
            );
          },
          animationDuration: const Duration(milliseconds: 500),
        ),
        if (_shouldShowMap()) const SizedBox(height: 16),
        if (_shouldShowMap())
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 250,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLatLng,
                  initialZoom: 16,
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        width: 40,
                        height: 40,
                        point: _selectedLatLng,
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                  if (widget.showMapCircle == true)
                    CircleLayer(
                      circles: <CircleMarker<Object>>[
                        CircleMarker(
                          point: _selectedLatLng,
                          radius: (widget.circleRadius ?? 0) * 1000,
                          useRadiusInMeter: true,
                          color: Colors.blue.withAlpha(50),
                          borderColor: Colors.blue,
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
        (widget.displayMode == MapDisplayMode.showMapAfterSelection);
  }
}
